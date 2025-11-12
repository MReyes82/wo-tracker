class EquipmentType {
  final int? id;
  final String name;

  EquipmentType({
    this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory EquipmentType.fromMap(Map<String, dynamic> map) {
    return EquipmentType(
      id: map['id'] as int?,
      name: map['name'] as String,
    );
  }

  @override
  String toString() {
    return 'EquipmentType{id: $id, name: $name}';
  }
}

