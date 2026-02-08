class ExerciseType {
  final int? id;
  final String name;

  ExerciseType({this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  factory ExerciseType.fromMap(Map<String, dynamic> map) {
    return ExerciseType(id: map['id'] as int?, name: map['name'] as String);
  }

  @override
  String toString() {
    return 'ExerciseType{id: $id, name: $name}';
  }
}
