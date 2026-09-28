import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// A glowing gradient progress bar. [progress] is between 0.0 and 1.0.
/// It animates when first shown and every time [progress] changes.
class XPProgressBar extends StatelessWidget {
  const XPProgressBar({super.key, required this.progress, this.height = 14});

  final double progress;
  final double height;

  @override
  Widget build(BuildContext context) {
    final target = progress.clamp(0.0, 1.0).toDouble();
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: target),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Container(
          height: height,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(height),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: value,
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppTheme.xpGradient,
                  borderRadius: BorderRadius.circular(height),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.accent.withValues(alpha: 0.5),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
