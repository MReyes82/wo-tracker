class Mesocycle {
  final int? id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int weeksQuantity;
  final int sessionsPerWeek;

  Mesocycle({
    this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    this.createdAt,
    this.updatedAt,
    this.weeksQuantity = 0,
    this.sessionsPerWeek = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'weeks_quantity': weeksQuantity,
      'sessions_per_week': sessionsPerWeek,
    };
  }

  factory Mesocycle.fromMap(Map<String, dynamic> map) {
    return Mesocycle(
      id: map['id'] as int?,
      name: map['name'] as String,
      startDate: DateTime.parse(map['start_date'] as String),
      endDate: DateTime.parse(map['end_date'] as String),
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
      weeksQuantity: map['weeks_quantity'] as int? ?? 0,
      sessionsPerWeek: map['sessions_per_week'] as int? ?? 0,
    );
  }

  @override
  String toString() {
    return 'Mesocycle{id: $id, name: $name, startDate: $startDate, endDate: $endDate, '
        'weeksQuantity: $weeksQuantity, sessionsPerWeek: $sessionsPerWeek}';
  }

  Mesocycle copyWith({
    int? id,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? weeksQuantity,
    int? sessionsPerWeek,
  }) {
    return Mesocycle(
      id: id ?? this.id,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      weeksQuantity: weeksQuantity ?? this.weeksQuantity,
      sessionsPerWeek: sessionsPerWeek ?? this.sessionsPerWeek,
    );
  }
}
