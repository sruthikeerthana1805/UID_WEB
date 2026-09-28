import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/quest.dart';
import '../theme/app_theme.dart';

/// Reusable card that shows one quest. Tapping it completes the quest,
/// which plays: check animation, card pulse, colour change and a
/// floating "+XP" label.
class QuestCard extends StatefulWidget {
  const QuestCard({super.key, required this.quest, required this.onTap});

  final Quest quest;
  final VoidCallback onTap;

  @override
  State<QuestCard> createState() => _QuestCardState();
}

class _QuestCardState extends State<QuestCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late bool _wasCompleted;

  @override
  void initState() {
    super.initState();
    _wasCompleted = widget.quest.isCompleted;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void didUpdateWidget(QuestCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final done = widget.quest.isCompleted;
    // Play the animation only at the moment the quest becomes completed.
    if (done && !_wasCompleted) {
      _controller.forward(from: 0);
    }
    _wasCompleted = done;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quest = widget.quest;
    final done = quest.isCompleted;

    final card = GestureDetector(
      onTap: done ? null : widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient:
              done ? AppTheme.completedGradient : AppTheme.cardGradient,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: done
                ? AppTheme.success.withValues(alpha: 0.6)
                : Colors.white.withValues(alpha: 0.08),
          ),
          boxShadow: [
            BoxShadow(
              color: (done ? AppTheme.success : AppTheme.primary)
                  .withValues(alpha: 0.2),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AnimatedCheck(done: done),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quest.title,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: done ? Colors.white60 : Colors.white,
                      decoration:
                          done ? TextDecoration.lineThrough : TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${quest.emoji} ${quest.subject}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _InfoChip(
                        icon: Icons.event,
                        text: 'Deadline: ${quest.deadlineLabel}',
                        color: quest.isOverdue
                            ? AppTheme.danger
                            : AppTheme.accent,
                      ),
                      _InfoChip(
                        icon: Icons.flag,
                        text: 'Priority: ${quest.priority.label}',
                        color: AppTheme.priorityColor(quest.priority),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                gradient: AppTheme.goldGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '+${quest.xpReward} XP',
                style: const TextStyle(
                  color: Color(0xFF2B1B00),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AnimatedBuilder(
        animation: _controller,
        child: card,
        builder: (context, child) {
          final t = _controller.value;
          // Card grows a little and shrinks back (sine wave 0 -> 1 -> 0).
          final scale = 1 + 0.04 * math.sin(t * math.pi);
          // Floating label: fades in fast, then fades out while moving up.
          double opacity = 0;
          if (t > 0) {
            opacity = t < 0.2 ? t / 0.2 : 1 - (t - 0.2) / 0.8;
          }
          return Transform.scale(
            scale: scale,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                child!,
                Positioned(
                  right: 24,
                  top: -4 - 36 * t,
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: opacity.clamp(0.0, 1.0).toDouble(),
                      child: Text(
                        '+${quest.xpReward} XP',
                        style: const TextStyle(
                          color: AppTheme.gold,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          shadows: [Shadow(color: Colors.black54, blurRadius: 6)],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Round checkbox that fills with green and pops in a tick.
class _AnimatedCheck extends StatelessWidget {
  const _AnimatedCheck({required this.done});

  final bool done;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: done ? AppTheme.success : Colors.transparent,
        border: Border.all(
          color: done ? AppTheme.success : Colors.white38,
          width: 2,
        ),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        transitionBuilder: (child, animation) =>
            ScaleTransition(scale: animation, child: child),
        child: done
            ? const Icon(Icons.check, key: ValueKey('done'), size: 18, color: Colors.white)
            : const SizedBox.shrink(key: ValueKey('todo')),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.text, required this.color});

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 12, color: color)),
        ],
      ),
    );
  }
}
