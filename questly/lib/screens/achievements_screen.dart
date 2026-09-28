import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../widgets/achievement_card.dart';
import '../widgets/responsive_wrap.dart';
import '../widgets/screen_header.dart';
import '../widgets/xp_progress_bar.dart';

/// Grid of achievement cards. Newly unlocked ones play a celebration.
class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key, required this.state});

  final AppState state;

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  @override
  void initState() {
    super.initState();
    // After the first build, forget which achievements were "new" so the
    // celebration only plays once.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.state.clearRecentlyUnlocked();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    return ListenableBuilder(
      listenable: state,
      builder: (context, child) {
        final total = state.achievements.length;
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            ScreenHeader(
              title: 'Achievements',
              subtitle: '${state.unlockedCount} of $total unlocked',
            ),
            XPProgressBar(
              progress: total == 0 ? 0 : state.unlockedCount / total,
              height: 10,
            ),
            const SizedBox(height: 20),
            ResponsiveWrap(
              minItemWidth: 340,
              children: [
                for (final achievement in state.achievements)
                  AchievementCard(
                    key: ValueKey(achievement.id),
                    achievement: achievement,
                    justUnlocked: state.recentlyUnlocked.contains(achievement.id),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
