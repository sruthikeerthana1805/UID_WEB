/// How important a quest is.
enum Priority { low, medium, high }

/// Whether the quest is still to do or already finished.
enum QuestStatus { pending, completed }

/// An extension adds a helper to an enum without changing the enum itself.
extension PriorityLabel on Priority {
  String get label {
    switch (this) {
      case Priority.low:
        return 'Low';
      case Priority.medium:
        return 'Medium';
      case Priority.high:
        return 'High';
    }
  }
}

/// A single academic task turned into a quest.
class Quest {
  Quest({
    required this.id,
    required this.title,
    required this.subject,
    required this.deadline,
    required this.priority,
    required this.xpReward,
    this.description = '',
    this.status = QuestStatus.pending,
  });

  final String id;
  final String title;
  final String subject;
  final String description;
  final DateTime deadline;
  final Priority priority;
  final int xpReward;
  QuestStatus status;

  bool get isCompleted => status == QuestStatus.completed;

  /// Number of days from today until the deadline (0 = today).
  int get daysLeft {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(deadline.year, deadline.month, deadline.day);
    return due.difference(today).inDays;
  }

  bool get isDueToday => daysLeft == 0;
  bool get isOverdue => daysLeft < 0 && !isCompleted;

  /// Friendly text such as "Today", "Tomorrow" or "12/5".
  String get deadlineLabel {
    if (daysLeft == 0) return 'Today';
    if (daysLeft == 1) return 'Tomorrow';
    if (daysLeft < 0) return 'Overdue';
    return '${deadline.day}/${deadline.month}';
  }

  /// A small emoji that matches the subject.
  String get emoji {
    const emojis = {
      'DBMS': '📚',
      'CN': '📝',
      'DSA': '💻',
      'OS': '🖥️',
      'Flutter': '📱',
    };
    return emojis[subject] ?? '🎯';
  }
}
