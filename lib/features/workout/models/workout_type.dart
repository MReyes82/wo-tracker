class WorkoutType {
  final int? id;
  final String name;

  WorkoutType({this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  factory WorkoutType.fromMap(Map<String, dynamic> map) {
    return WorkoutType(id: map['id'] as int?, name: map['name'] as String);
  }

  @override
  String toString() {
    return 'WorkoutType{id: $id, name: $name}';
  }
}
