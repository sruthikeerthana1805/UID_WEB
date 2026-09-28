import 'package:flutter/foundation.dart';

import '../models/achievement.dart';
import '../models/quest.dart';
import '../models/student_profile.dart';
import 'sample_data.dart';

/// What happened when a quest was completed (used to show messages).
class QuestResult {
  const QuestResult({
    required this.xp,
    required this.leveledUp,
    required this.newLevel,
    required this.unlocked,
  });

  final int xp;
  final bool leveledUp;
  final int newLevel;
  final List<Achievement> unlocked;
}

/// Holds all app data in memory. Screens listen to it and rebuild
/// automatically whenever notifyListeners() is called.
class AppState extends ChangeNotifier {
  AppState()
      : profile = SampleData.profile(),
        quests = SampleData.quests(),
        achievements = SampleData.achievements() {
    // Unlock the achievements the student already deserves at start-up.
    for (final achievement in achievements) {
      achievement.isUnlocked = _isEarned(achievement.id);
    }
  }

  final StudentProfile profile;
  final List<Quest> quests;
  final List<Achievement> achievements;

  /// Ids of achievements unlocked but not yet "celebrated" on screen.
  final Set<String> recentlyUnlocked = {};

  int get completedCount => quests.where((q) => q.isCompleted).length;
  int get pendingCount => quests.length - completedCount;
  int get unlockedCount => achievements.where((a) => a.isUnlocked).length;

  double get completionRatio =>
      quests.isEmpty ? 0 : completedCount / quests.length;

  List<Quest> get todaysQuests => quests.where((q) => q.isDueToday).toList();

  void addQuest(Quest quest) {
    quests.insert(0, quest);
    notifyListeners();
  }

  /// Marks a quest as done, gives XP and checks achievements.
  QuestResult? completeQuest(String id) {
    final index = quests.indexWhere((q) => q.id == id);
    if (index == -1 || quests[index].isCompleted) return null;

    final quest = quests[index];
    final oldLevel = profile.level;

    quest.status = QuestStatus.completed;
    profile.totalXp += quest.xpReward;

    final unlocked = <Achievement>[];
    for (final achievement in achievements) {
      if (!achievement.isUnlocked && _isEarned(achievement.id)) {
        achievement.isUnlocked = true;
        unlocked.add(achievement);
        recentlyUnlocked.add(achievement.id);
      }
    }

    notifyListeners();
    return QuestResult(
      xp: quest.xpReward,
      leveledUp: profile.level > oldLevel,
      newLevel: profile.level,
      unlocked: unlocked,
    );
  }

  void clearRecentlyUnlocked() => recentlyUnlocked.clear();

  bool _isEarned(String id) {
    switch (id) {
      case 'first_quest':
        return completedCount >= 1;
      case 'streak_7':
        return profile.streak >= 7;
      case 'xp_hunter':
        return profile.totalXp >= 500;
      case 'high_flyer':
        return quests.any((q) => q.isCompleted && q.priority == Priority.high);
      case 'level_up':
        return profile.level >= 6;
      case 'academic_warrior':
        return completedCount >= 10;
      default:
        return false;
    }
  }
}
