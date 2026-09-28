import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../models/student_profile.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_xp.dart';
import '../widgets/level_badge.dart';
import '../widgets/responsive_wrap.dart';
import '../widgets/screen_header.dart';
import '../widgets/stat_card.dart';
import '../widgets/xp_progress_bar.dart';

/// Progress dashboard with an animated level bar and completion ring.
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key, required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: state,
      builder: (context, child) {
        final profile = state.profile;
        final percent = (profile.levelProgress * 100).round();
        final completion = (state.completionRatio * 100).round();

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            const ScreenHeader(
              title: 'Progress',
              subtitle: 'Your journey so far',
            ),
            Container(
              padding: const EdgeInsets.all(20),
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
              child: Column(
                children: [
                  Row(
                    children: [
                      LevelBadge(level: profile.level, size: 68),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'LEVEL ${profile.level}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                              ),
                            ),
                            AnimatedXP(
                              xp: profile.totalXp,
                              suffix: ' XP total',
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  XPProgressBar(progress: profile.levelProgress, height: 20),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$percent% to Level ${profile.level + 1}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${profile.xpIntoLevel} / ${StudentProfile.xpPerLevel} XP',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppTheme.cardGradient,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 110,
                    height: 110,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: state.completionRatio),
                      duration: const Duration(milliseconds: 1200),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 110,
                              height: 110,
                              child: CircularProgressIndicator(
                                value: value,
                                strokeWidth: 10,
                                backgroundColor: Colors.white12,
                                color: AppTheme.success,
                              ),
                            ),
                            Text(
                              '${(value * 100).round()}%',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Quest Completion',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${state.completedCount} of ${state.quests.length} quests completed',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SectionTitle(title: 'Your Stats'),
            ResponsiveWrap(
              minItemWidth: 150,
              children: [
                StatCard(
                  icon: Icons.bolt,
                  label: 'Total XP',
                  value: '${profile.totalXp}',
                  color: AppTheme.accent,
                ),
                StatCard(
                  icon: Icons.military_tech,
                  label: 'Current Level',
                  value: '${profile.level}',
                  color: AppTheme.gold,
                ),
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
                  icon: Icons.local_fire_department,
                  label: 'Day Streak',
                  value: '${profile.streak}',
                  color: AppTheme.danger,
                ),
                StatCard(
                  icon: Icons.pie_chart,
                  label: 'Completion',
                  value: '$completion%',
                  color: AppTheme.primary,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
