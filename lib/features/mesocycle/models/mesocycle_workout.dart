class MesocycleWorkout {
  final int? id;
  final int mesocycleId;
  final int workoutTemplateId;
  final int dayOfWeek; // 1 = Monday, 2 = Tuesday, etc., up to 7 = Sunday

  MesocycleWorkout({
    this.id,
    required this.mesocycleId,
    required this.workoutTemplateId,
    required this.dayOfWeek,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mesocycle_id': mesocycleId,
      'workout_template_id': workoutTemplateId,
      'day_of_week': dayOfWeek,
    };
  }

  factory MesocycleWorkout.fromMap(Map<String, dynamic> map) {
    return MesocycleWorkout(
      id: map['id'] as int?,
      mesocycleId: map['mesocycle_id'] as int,
      workoutTemplateId: map['workout_template_id'] as int,
      dayOfWeek: map['day_of_week'] as int,
    );
  }

  @override
  String toString() {
    return 'MesocycleWorkout{id: $id, mesocycleId: $mesocycleId, '
        'workoutTemplateId: $workoutTemplateId, dayOfWeek: $dayOfWeek}';
  }
}
