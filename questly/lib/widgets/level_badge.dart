import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// A round golden badge showing the current level.
class LevelBadge extends StatelessWidget {
  const LevelBadge({super.key, required this.level, this.size = 72});

  final int level;
  final double size;

  @override
  Widget build(BuildContext context) {
    const textColor = Color(0xFF2B1B00);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppTheme.goldGradient,
        boxShadow: [
          BoxShadow(
            color: AppTheme.gold.withValues(alpha: 0.45),
            blurRadius: 18,
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'LVL',
              style: TextStyle(
                fontSize: size * 0.16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Text(
              '$level',
              style: TextStyle(
                fontSize: size * 0.38,
                fontWeight: FontWeight.w900,
                color: textColor,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
