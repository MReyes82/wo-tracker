class Exercise {
  final int? id;
  final String name;
  final int exerciseTypeId;
  final int equipmentTypeId;
  final int muscleGroupId;
  final double? defaultWorkingWeight;
  final bool isUsingMetric;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Exercise({
    this.id,
    required this.name,
    required this.exerciseTypeId,
    required this.equipmentTypeId,
    required this.muscleGroupId,
    this.defaultWorkingWeight,
    this.isUsingMetric = true,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'exercise_type_id': exerciseTypeId,
      'equipment_type_id': equipmentTypeId,
      'muscle_group_id': muscleGroupId,
      'default_working_weight': defaultWorkingWeight,
      'is_using_metric': isUsingMetric ? 1 : 0,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'] as int?,
      name: map['name'] as String,
      exerciseTypeId: map['exercise_type_id'] as int,
      equipmentTypeId: map['equipment_type_id'] as int,
      muscleGroupId: map['muscle_group_id'] as int,
      defaultWorkingWeight: map['default_working_weight'] as double?,
      isUsingMetric: (map['is_using_metric'] as int) == 1,
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
    return 'Exercise{id: $id, name: $name, exerciseTypeId: $exerciseTypeId, '
           'equipmentTypeId: $equipmentTypeId, muscleGroupId: $muscleGroupId, '
           'defaultWorkingWeight: $defaultWorkingWeight, isUsingMetric: $isUsingMetric}';
  }
}

