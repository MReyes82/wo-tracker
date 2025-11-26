class WorkoutSession {
  final int? id;
  final int? templateId;
  final String? title;
  final DateTime? startTime;
  final int? mesocycleId;
  final int? weekNumber;
  final int? sessionOrder;
  final DateTime? endTime;
  final String? notes;
  final DateTime? createdAt;

  WorkoutSession({
    this.id,
    this.templateId,
    this.title,
    this.startTime,
    this.mesocycleId,
    this.weekNumber,
    this.sessionOrder,
    this.endTime,
    this.notes,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'template_id': templateId,
      'title': title,
      'start_time': startTime?.toIso8601String(),
      'mesocycle_id': mesocycleId,
      'week_number': weekNumber,
      'session_order': sessionOrder,
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
      startTime: map['start_time'] != null
          ? DateTime.parse(map['start_time'] as String)
          : null,
      mesocycleId: map['mesocycle_id'] as int?,
      weekNumber: map['week_number'] as int?,
      sessionOrder: map['session_order'] as int?,
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
           'startTime: $startTime, mesocycleId: $mesocycleId, weekNumber: $weekNumber, sessionOrder: $sessionOrder, endTime: $endTime}';
  }
}

