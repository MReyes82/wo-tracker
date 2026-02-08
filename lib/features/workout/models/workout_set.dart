class WorkoutSet {
  final int? id;
  final int workoutExerciseId;
  final int setNumber;
  final int? reps;
  final double? weight;
  final int? effortLevel;
  final String? effortLevelSpecifier;
  final bool completed;
  final DateTime? completedAt;
  final String? notes;

  WorkoutSet({
    this.id,
    required this.workoutExerciseId,
    required this.setNumber,
    this.reps,
    this.weight,
    this.effortLevel,
    this.effortLevelSpecifier,
    this.completed = false,
    this.completedAt,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'workout_exercise_id': workoutExerciseId,
      'set_number': setNumber,
      'reps': reps,
      'weight': weight,
      'effort_level': effortLevel,
      'effort_level_specifier': effortLevelSpecifier,
      'completed': completed ? 1 : 0,
      'completed_at': completedAt?.toIso8601String(),
      'notes': notes,
    };
  }

  factory WorkoutSet.fromMap(Map<String, dynamic> map) {
    return WorkoutSet(
      id: map['id'] as int?,
      workoutExerciseId: map['workout_exercise_id'] as int,
      setNumber: map['set_number'] as int,
      reps: map['reps'] as int?,
      weight: map['weight'] as double?,
      effortLevel: map['effort_level'] as int?,
      effortLevelSpecifier: map['effort_level_specifier'] as String?,
      completed: (map['completed'] as int) == 1,
      completedAt: map['completed_at'] != null
          ? DateTime.parse(map['completed_at'] as String)
          : null,
      notes: map['notes'] as String?,
    );
  }

  @override
  String toString() {
    return 'WorkoutSet{id: $id, workoutExerciseId: $workoutExerciseId, setNumber: $setNumber, '
        'reps: $reps, weight: $weight, effortLevel: $effortLevel, completed: $completed}';
  }
}
