/// Information about the student and their game progress.
class StudentProfile {
  StudentProfile({
    required this.name,
    required this.course,
    required this.totalXp,
    required this.streak,
  });

  /// XP needed to move from one level to the next.
  static const int xpPerLevel = 250;

  final String name;
  final String course;
  int totalXp;
  final int streak;

  int get level => totalXp ~/ xpPerLevel + 1;
  int get xpIntoLevel => totalXp % xpPerLevel;
  int get xpToNextLevel => xpPerLevel - xpIntoLevel;
  double get levelProgress => xpIntoLevel / xpPerLevel;
}
