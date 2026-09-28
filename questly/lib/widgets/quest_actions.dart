import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../models/quest.dart';

/// Completes a quest and shows a message about XP, level ups and
/// unlocked achievements.
void completeQuestWithFeedback(
  BuildContext context,
  AppState state,
  Quest quest,
) {
  final result = state.completeQuest(quest.id);
  if (result == null) return;

  final lines = <String>['+${result.xp} XP earned!'];
  if (result.leveledUp) lines.add('🎉 Level Up! You are now Level ${result.newLevel}');
  for (final achievement in result.unlocked) {
    lines.add('${achievement.emoji} Achievement unlocked: ${achievement.title}');
  }

  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      content: Text(lines.join('\n')),
      duration: const Duration(seconds: 3),
    ),
  );
}
