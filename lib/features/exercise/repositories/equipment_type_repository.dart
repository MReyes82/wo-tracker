import 'package:sqflite/sqflite.dart';
import '../../../core/db/database_helper.dart';
import '../models/equipment_type.dart';

class EquipmentTypeRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> create(EquipmentType equipmentType) async {
    final db = await _dbHelper.database;
    return await db.insert(
      'equipment_type',
      equipmentType.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<EquipmentType>> getAll() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('equipment_type');
    return List.generate(maps.length, (i) {
      return EquipmentType.fromMap(maps[i]);
    });
  }

  Future<EquipmentType?> getById(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'equipment_type',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return EquipmentType.fromMap(maps.first);
  }

  Future<int> update(EquipmentType equipmentType) async {
    final db = await _dbHelper.database;
    return await db.update(
      'equipment_type',
      equipmentType.toMap(),
      where: 'id = ?',
      whereArgs: [equipmentType.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('equipment_type', where: 'id = ?', whereArgs: [id]);
  }
}
