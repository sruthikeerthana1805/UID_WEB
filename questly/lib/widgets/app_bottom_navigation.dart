import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// One tab of the main navigation.
class NavItem {
  const NavItem(this.label, this.icon, this.selectedIcon);

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

const List<NavItem> appNavItems = [
  NavItem('Home', Icons.home_outlined, Icons.home),
  NavItem('Quests', Icons.sports_esports_outlined, Icons.sports_esports),
  NavItem('Progress', Icons.insights_outlined, Icons.insights),
  NavItem('Achievements', Icons.emoji_events_outlined, Icons.emoji_events),
  NavItem('Profile', Icons.person_outline, Icons.person),
];

/// Material 3 bottom navigation bar for the five main screens.
class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onSelected,
      backgroundColor: AppTheme.surface,
      destinations: [
        for (final item in appNavItems)
          NavigationDestination(
            icon: Icon(item.icon),
            selectedIcon: Icon(item.selectedIcon),
            label: item.label,
          ),
      ],
    );
  }
}
