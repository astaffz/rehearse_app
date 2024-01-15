class Reminder {
  const Reminder({
    required this.id,
    this.reminderTitle,
    required this.reminderContent,
    required this.scheduledTime,
  });

  final int id;
  static const String defaultTitle = "RehearseApp Podsjetnik!";
  final String? reminderTitle;
  final String reminderContent;
  final DateTime scheduledTime;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reminder_content': reminderContent,
      'scheduled_at': scheduledTime,
    };
  }
}
