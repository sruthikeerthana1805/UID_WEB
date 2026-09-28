import 'package:flutter/material.dart';

import '../utils/format.dart';

/// Shows an XP number that counts up smoothly whenever it changes.
class AnimatedXP extends StatelessWidget {
  const AnimatedXP({
    super.key,
    required this.xp,
    this.style,
    this.suffix = '',
  });

  final int xp;
  final TextStyle? style;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    // TweenAnimationBuilder animates from the old value to the new one.
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: xp.toDouble()),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Text('${formatNumber(value.round())}$suffix', style: style);
      },
    );
  }
}
