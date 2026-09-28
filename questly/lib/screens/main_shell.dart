import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_bottom_navigation.dart';
import 'achievements_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'progress_screen.dart';
import 'quests_screen.dart';

/// Holds the bottom navigation and switches between the 5 main screens.
/// On wide screens (tablet / web) a side navigation rail is used instead.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final AppState _state = AppState();
  int _index = 0;

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  void _select(int index) => setState(() => _index = index);

  Widget _buildPage() {
    switch (_index) {
      case 0:
        return HomeScreen(state: _state, onSeeAllQuests: () => _select(1));
      case 1:
        return QuestsScreen(state: _state);
      case 2:
        return ProgressScreen(state: _state);
      case 3:
        return AchievementsScreen(state: _state);
      default:
        return ProfileScreen(state: _state);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 720;

        return Scaffold(
          bottomNavigationBar: isWide
              ? null
              : AppBottomNavigation(selectedIndex: _index, onSelected: _select),
          body: Container(
            decoration:
                const BoxDecoration(gradient: AppTheme.backgroundGradient),
            child: Row(
              children: [
                if (isWide)
                  NavigationRail(
                    selectedIndex: _index,
                    onDestinationSelected: _select,
                    backgroundColor: AppTheme.surface,
                    labelType: NavigationRailLabelType.all,
                    destinations: [
                      for (final item in appNavItems)
                        NavigationRailDestination(
                          icon: Icon(item.icon),
                          selectedIcon: Icon(item.selectedIcon),
                          label: Text(item.label),
                        ),
                    ],
                  ),
                Expanded(
                  child: SafeArea(
                    bottom: false,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 900),
                        // Fades between tabs when the page changes.
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: KeyedSubtree(
                            key: ValueKey(_index),
                            child: _buildPage(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
