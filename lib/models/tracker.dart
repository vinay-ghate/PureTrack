enum TrackerType { habit, goal, counter, timer }

extension TrackerTypeExtension on TrackerType {
  String toShortString() {
    return toString().split('.').last;
  }

  static TrackerType fromString(String value) {
    return TrackerType.values.firstWhere(
      (e) => e.toShortString().toLowerCase() == value.toLowerCase(),
      orElse: () => TrackerType.habit,
    );
  }
}

class Tracker {
  final int? id;
  final String name;
  final String icon;
  final String color;
  final int? categoryId;
  final TrackerType type;
  final double targetValue; // 1.0 for habits, variable for counters/goals/timers
  final String unit; // "done", "glasses", "pages", "minutes", etc.
  final String frequency; // "Daily", "Weekly", "Custom:Monday,Wednesday,Friday"
  final String? reminderTime; // Format "HH:mm"
  final DateTime createdAt;
  final bool isArchived;

  Tracker({
    this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.categoryId,
    required this.type,
    this.targetValue = 1.0,
    required this.unit,
    this.frequency = "Daily",
    this.reminderTime,
    required this.createdAt,
    this.isArchived = false,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'icon': icon,
      'color': color,
      'category_id': categoryId,
      'type': type.toShortString(),
      'target_value': targetValue,
      'unit': unit,
      'frequency': frequency,
      'reminder_time': reminderTime,
      'created_at': createdAt.toIso8601String(),
      'is_archived': isArchived ? 1 : 0,
    };
  }

  factory Tracker.fromMap(Map<String, dynamic> map) {
    return Tracker(
      id: map['id'] as int?,
      name: map['name'] as String,
      icon: map['icon'] as String,
      color: map['color'] as String,
      categoryId: map['category_id'] as int?,
      type: TrackerTypeExtension.fromString(map['type'] as String),
      targetValue: (map['target_value'] as num).toDouble(),
      unit: map['unit'] as String,
      frequency: map['frequency'] as String,
      reminderTime: map['reminder_time'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      isArchived: (map['is_archived'] as int) == 1,
    );
  }
}
