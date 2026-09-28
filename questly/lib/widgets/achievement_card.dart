import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/achievement.dart';
import '../theme/app_theme.dart';

/// Shows one achievement. Locked ones look grey with a lock icon.
/// When [justUnlocked] is true the card scales, the icon bounces and
/// rotates, and small stars burst out.
class AchievementCard extends StatefulWidget {
  const AchievementCard({
    super.key,
    required this.achievement,
    this.justUnlocked = false,
  });

  final Achievement achievement;
  final bool justUnlocked;

  @override
  State<AchievementCard> createState() => _AchievementCardState();
}

class _AchievementCardState extends State<AchievementCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    if (widget.justUnlocked) _controller.forward();
  }

  @override
  void didUpdateWidget(AchievementCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.justUnlocked && !oldWidget.justUnlocked) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Widget> _sparkles(double t) {
    if (t <= 0 || t >= 1) return [];
    return [
      for (int i = 0; i < 8; i++)
        Transform.translate(
          offset: Offset(
            math.cos(i * math.pi / 4) * (24 + 28 * t),
            math.sin(i * math.pi / 4) * (24 + 28 * t),
          ),
          child: Opacity(
            opacity: (1 - t).clamp(0.0, 1.0).toDouble(),
            child: const Icon(Icons.star_rounded, size: 14, color: AppTheme.gold),
          ),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final achievement = widget.achievement;
    final unlocked = achievement.isUnlocked;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        final scale = 1 + 0.08 * math.sin(t * math.pi);
        final angle = math.sin(t * math.pi * 4) * 0.4 * (1 - t);
        final bounce = -math.sin(t * math.pi * 3).abs() * 12 * (1 - t);

        return Transform.scale(
          scale: scale,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: unlocked
                  ? AppTheme.cardGradient
                  : const LinearGradient(
                      colors: [Color(0xFF1A1A2E), Color(0xFF16161F)],
                    ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: unlocked
                    ? AppTheme.gold.withValues(alpha: 0.7)
                    : Colors.white12,
                width: unlocked ? 1.5 : 1,
              ),
              boxShadow: unlocked
                  ? [
                      BoxShadow(
                        color: AppTheme.gold.withValues(alpha: 0.2),
                        blurRadius: 16,
                      ),
                    ]
                  : [],
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      ..._sparkles(t),
                      Transform.translate(
                        offset: Offset(0, bounce),
                        child: Transform.rotate(
                          angle: angle,
                          child: Container(
                            width: 56,
                            height: 56,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: unlocked ? AppTheme.goldGradient : null,
                              color: unlocked ? null : Colors.white10,
                            ),
                            child: unlocked
                                ? Text(
                                    achievement.emoji,
                                    style: const TextStyle(fontSize: 28),
                                  )
                                : const Icon(Icons.lock_rounded,
                                    color: Colors.white38),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        achievement.title,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: unlocked ? Colors.white : Colors.white54,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        achievement.description,
                        style: TextStyle(
                          color: unlocked ? Colors.white70 : Colors.white38,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        unlocked ? '✓ UNLOCKED' : '🔒 LOCKED',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: unlocked ? AppTheme.gold : Colors.white38,
                        ),
                      ),
                    ],
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
