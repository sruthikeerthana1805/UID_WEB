import '../models/achievement.dart';
import '../models/quest.dart';
import '../models/student_profile.dart';

/// Starting data. Replace these lists later (for example with a database)
/// without touching any screen code.
class SampleData {
  SampleData._();

  static StudentProfile profile() => StudentProfile(
        name: 'Student',
        course: 'B.Tech - Computer Science Engineering',
        totalXp: 1120,
        streak: 7,
      );

  static List<Quest> quests() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return [
      Quest(
        id: 'q1',
        title: 'DBMS Assignment',
        subject: 'DBMS',
        description: 'Solve the normalization and SQL query problems.',
        deadline: today,
        priority: Priority.high,
        xpReward: 50,
      ),
      Quest(
        id: 'q2',
        title: 'Flutter Lab',
        subject: 'Flutter',
        description: 'Finish the Questly UI screens.',
        deadline: today,
        priority: Priority.high,
        xpReward: 60,
      ),
      Quest(
        id: 'q3',
        title: 'Data Structures Practice',
        subject: 'DSA',
        description: 'Solve 5 linked list problems.',
        deadline: today,
        priority: Priority.medium,
        xpReward: 30,
      ),
      Quest(
        id: 'q4',
        title: 'CN Presentation',
        subject: 'CN',
        description: 'Prepare slides on the TCP/IP model.',
        deadline: today.add(const Duration(days: 1)),
        priority: Priority.medium,
        xpReward: 40,
      ),
      Quest(
        id: 'q5',
        title: 'Operating Systems Notes',
        subject: 'OS',
        description: 'Summarize process scheduling algorithms.',
        deadline: today.add(const Duration(days: 3)),
        priority: Priority.low,
        xpReward: 20,
      ),
    ];
  }

  static List<Achievement> achievements() => [
        Achievement(
          id: 'first_quest',
          emoji: '🏆',
          title: 'First Quest',
          description: 'Complete your first quest.',
        ),
        Achievement(
          id: 'streak_7',
          emoji: '🔥',
          title: '7 Day Warrior',
          description: 'Maintain a 7-day streak.',
        ),
        Achievement(
          id: 'xp_hunter',
          emoji: '⚡',
          title: 'XP Hunter',
          description: 'Earn 500 XP.',
        ),
        Achievement(
          id: 'high_flyer',
          emoji: '🎯',
          title: 'High Flyer',
          description: 'Complete a high priority quest.',
        ),
        Achievement(
          id: 'level_up',
          emoji: '🚀',
          title: 'Rising Star',
          description: 'Reach Level 6.',
        ),
        Achievement(
          id: 'academic_warrior',
          emoji: '📚',
          title: 'Academic Warrior',
          description: 'Complete 10 quests.',
        ),
      ];
}
