class Reminder {
  Reminder({
    required this.id,
    this.reminderTitle,
    required this.reminderContent,
    required this.Iso8601scheduledTime,
  });

  int? id;
  static const String defaultTitle = "RehearseApp Podsjetnik!";
  final String? reminderTitle;
  final String reminderContent;
  final String Iso8601scheduledTime;

  Map<String, dynamic> toMap() {
    return {
      'content': reminderContent,
      'scheduled_at': Iso8601scheduledTime,
    };
  }

  Reminder.withoutID({
    this.reminderTitle,
    required this.reminderContent,
    required this.Iso8601scheduledTime,
  });
}
