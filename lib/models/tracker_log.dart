class TrackerLog {
  final int? id;
  final int trackerId;
  final String date; // YYYY-MM-DD
  final double valueLogged;
  final DateTime timestamp;
  final String? note;

  TrackerLog({
    this.id,
    required this.trackerId,
    required this.date,
    required this.valueLogged,
    required this.timestamp,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'tracker_id': trackerId,
      'date': date,
      'value_logged': valueLogged,
      'timestamp': timestamp.toIso8601String(),
      'note': note,
    };
  }

  factory TrackerLog.fromMap(Map<String, dynamic> map) {
    return TrackerLog(
      id: map['id'] as int?,
      trackerId: map['tracker_id'] as int,
      date: map['date'] as String,
      valueLogged: (map['value_logged'] as num).toDouble(),
      timestamp: DateTime.parse(map['timestamp'] as String),
      note: map['note'] as String?,
    );
  }
}
