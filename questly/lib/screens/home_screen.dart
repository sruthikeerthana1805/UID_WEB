import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../models/student_profile.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_xp.dart';
import '../widgets/level_badge.dart';
import '../widgets/quest_actions.dart';
import '../widgets/quest_card.dart';
import '../widgets/responsive_wrap.dart';
import '../widgets/screen_header.dart';
import '../widgets/stat_card.dart';
import '../widgets/streak_card.dart';
import '../widgets/xp_progress_bar.dart';

/// Dashboard: level, XP, streak, quick stats and today's quests.
class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.state,
    required this.onSeeAllQuests,
  });

  final AppState state;
  final VoidCallback onSeeAllQuests;

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    // ListenableBuilder rebuilds this part whenever AppState changes.
    return ListenableBuilder(
      listenable: state,
      builder: (context, child) {
        final profile = state.profile;
        final todays = state.todaysQuests;

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            ScreenHeader(
              title: '${_greeting()}, ${profile.name} 👋',
              subtitle: 'Ready to conquer today\'s quests?',
            ),
            _LevelHeader(profile: profile),
            const SizedBox(height: 12),
            StreakCard(streak: profile.streak),
            const SectionTitle(title: 'Quick Stats'),
            ResponsiveWrap(
              minItemWidth: 140,
              children: [
                StatCard(
                  icon: Icons.check_circle,
                  label: 'Completed',
                  value: '${state.completedCount}',
                  color: AppTheme.success,
                ),
                StatCard(
                  icon: Icons.pending_actions,
                  label: 'Pending',
                  value: '${state.pendingCount}',
                  color: AppTheme.orange,
                ),
                StatCard(
                  icon: Icons.emoji_events,
                  label: 'Achievements',
                  value: '${state.unlockedCount}/${state.achievements.length}',
                  color: AppTheme.gold,
                ),
              ],
            ),
            SectionTitle(
              title: 'Today\'s Quests',
              trailing: TextButton(
                onPressed: onSeeAllQuests,
                child: const Text('See all'),
              ),
            ),
            if (todays.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: Text(
                    'No quests due today. Add one from the Quests tab!',
                    style: TextStyle(color: Colors.white60),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              for (final quest in todays)
                QuestCard(
                  key: ValueKey(quest.id),
                  quest: quest,
                  onTap: () => completeQuestWithFeedback(context, state, quest),
                ),
          ],
        );
      },
    );
  }
}

class _LevelHeader extends StatelessWidget {
  const _LevelHeader({required this.profile});

  final StudentProfile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.45),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          LevelBadge(level: profile.level, size: 76),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LEVEL ${profile.level}',
                  style: const TextStyle(
                    fontSize: 13,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    AnimatedXP(
                      xp: profile.totalXp,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text(
                      ' XP',
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                XPProgressBar(progress: profile.levelProgress),
                const SizedBox(height: 6),
                Text(
                  '${profile.xpIntoLevel} / ${StudentProfile.xpPerLevel} XP  •  '
                  '${profile.xpToNextLevel} XP to Level ${profile.level + 1}',
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
