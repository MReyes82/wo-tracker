class TemplateExercise {
  final int? id;
  final int templateId;
  final int exerciseId;
  final int position;
  final int plannedSets;

  TemplateExercise({
    this.id,
    required this.templateId,
    required this.exerciseId,
    this.position = 0,
    this.plannedSets = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'template_id': templateId,
      'exercise_id': exerciseId,
      'position': position,
      'planned_sets': plannedSets,
    };
  }

  factory TemplateExercise.fromMap(Map<String, dynamic> map) {
    return TemplateExercise(
      id: map['id'] as int?,
      templateId: map['template_id'] as int,
      exerciseId: map['exercise_id'] as int,
      position: map['position'] as int? ?? 0,
      plannedSets: map['planned_sets'] as int? ?? 0,
    );
  }

  @override
  String toString() {
    return 'TemplateExercise{id: $id, templateId: $templateId, exerciseId: $exerciseId, '
           'position: $position, plannedSets: $plannedSets}';
  }
}

