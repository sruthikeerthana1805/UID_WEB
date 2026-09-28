/// A badge the student can unlock.
class Achievement {
  Achievement({
    required this.id,
    required this.emoji,
    required this.title,
    required this.description,
    this.isUnlocked = false,
  });

  final String id;
  final String emoji;
  final String title;
  final String description;
  bool isUnlocked;
}
