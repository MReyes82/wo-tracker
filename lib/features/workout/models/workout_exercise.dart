class WorkoutExercise {
  final int? id;
  final int sessionId;
  final int? templateExerciseId;
  final int? exerciseId;
  final String exerciseName;
  final String? exerciseDescription;
  final int? plannedSets;
  final int? position;
  final String? notes;

  WorkoutExercise({
    this.id,
    required this.sessionId,
    this.templateExerciseId,
    this.exerciseId,
    required this.exerciseName,
    this.exerciseDescription,
    this.plannedSets,
    this.position,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'session_id': sessionId,
      'template_exercise_id': templateExerciseId,
      'exercise_id': exerciseId,
      'exercise_name': exerciseName,
      'exercise_description': exerciseDescription,
      'planned_sets': plannedSets,
      'position': position,
      'notes': notes,
    };
  }

  factory WorkoutExercise.fromMap(Map<String, dynamic> map) {
    return WorkoutExercise(
      id: map['id'] as int?,
      sessionId: map['session_id'] as int,
      templateExerciseId: map['template_exercise_id'] as int?,
      exerciseId: map['exercise_id'] as int?,
      exerciseName: map['exercise_name'] as String,
      exerciseDescription: map['exercise_description'] as String?,
      plannedSets: map['planned_sets'] as int?,
      position: map['position'] as int?,
      notes: map['notes'] as String?,
    );
  }

  @override
  String toString() {
    return 'WorkoutExercise{id: $id, sessionId: $sessionId, exerciseName: $exerciseName, '
        'plannedSets: $plannedSets, position: $position}';
  }
}
