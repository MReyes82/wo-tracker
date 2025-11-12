class WorkoutSession {
  final int? id;
  final int? templateId;
  final String? title;
  final DateTime startTime;
  final DateTime? endTime;
  final String? notes;
  final DateTime? createdAt;

  WorkoutSession({
    this.id,
    this.templateId,
    this.title,
    required this.startTime,
    this.endTime,
    this.notes,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'template_id': templateId,
      'title': title,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'notes': notes,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  factory WorkoutSession.fromMap(Map<String, dynamic> map) {
    return WorkoutSession(
      id: map['id'] as int?,
      templateId: map['template_id'] as int?,
      title: map['title'] as String?,
      startTime: DateTime.parse(map['start_time'] as String),
      endTime: map['end_time'] != null
          ? DateTime.parse(map['end_time'] as String)
          : null,
      notes: map['notes'] as String?,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
    );
  }

  @override
  String toString() {
    return 'WorkoutSession{id: $id, templateId: $templateId, title: $title, '
           'startTime: $startTime, endTime: $endTime}';
  }
}

