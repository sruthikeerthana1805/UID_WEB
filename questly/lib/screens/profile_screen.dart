import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/level_badge.dart';
import '../widgets/responsive_wrap.dart';
import '../widgets/screen_header.dart';
import '../widgets/stat_card.dart';

/// Student profile: avatar, name, level and summary stats.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: state,
      builder: (context, child) {
        final profile = state.profile;
        final unlocked =
            state.achievements.where((a) => a.isUnlocked).toList();

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            const ScreenHeader(title: 'Profile', subtitle: 'Your student card'),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppTheme.cardGradient,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppTheme.xpGradient,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.accent.withValues(alpha: 0.4),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: AppTheme.surface,
                      child: Text(
                        profile.name.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    profile.name,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profile.course,
                    style: const TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  LevelBadge(level: profile.level, size: 64),
                ],
              ),
            ),
            const SectionTitle(title: 'Overview'),
            ResponsiveWrap(
              minItemWidth: 150,
              children: [
                StatCard(
                  icon: Icons.military_tech,
                  label: 'Level',
                  value: '${profile.level}',
                  color: AppTheme.gold,
                ),
                StatCard(
                  icon: Icons.bolt,
                  label: 'Total XP',
                  value: '${profile.totalXp}',
                  color: AppTheme.accent,
                ),
                StatCard(
                  icon: Icons.local_fire_department,
                  label: 'Day Streak',
                  value: '${profile.streak}',
                  color: AppTheme.danger,
                ),
                StatCard(
                  icon: Icons.check_circle,
                  label: 'Completed Quests',
                  value: '${state.completedCount}',
                  color: AppTheme.success,
                ),
              ],
            ),
            SectionTitle(
              title: 'Achievements (${unlocked.length}/${state.achievements.length})',
            ),
            if (unlocked.isEmpty)
              const Text(
                'Complete quests to unlock achievements.',
                style: TextStyle(color: Colors.white60),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final achievement in unlocked)
                    Chip(
                      avatar: Text(achievement.emoji),
                      label: Text(achievement.title),
                    ),
                ],
              ),
          ],
        );
      },
    );
  }
}
