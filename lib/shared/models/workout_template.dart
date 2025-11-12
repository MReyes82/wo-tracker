class WorkoutTemplate {
  final int? id;
  final String name;
  final int typeId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  WorkoutTemplate({
    this.id,
    required this.name,
    required this.typeId,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type_id': typeId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory WorkoutTemplate.fromMap(Map<String, dynamic> map) {
    return WorkoutTemplate(
      id: map['id'] as int?,
      name: map['name'] as String,
      typeId: map['type_id'] as int,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
    );
  }

  @override
  String toString() {
    return 'WorkoutTemplate{id: $id, name: $name, typeId: $typeId}';
  }
}

