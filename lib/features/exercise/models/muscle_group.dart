class MuscleGroup {
  final int? id;
  final String name;

  MuscleGroup({this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  factory MuscleGroup.fromMap(Map<String, dynamic> map) {
    return MuscleGroup(id: map['id'] as int?, name: map['name'] as String);
  }

  @override
  String toString() {
    return 'MuscleGroup{id: $id, name: $name}';
  }
}
