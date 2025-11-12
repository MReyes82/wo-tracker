import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../../../shared/models/muscle_group.dart';

class MuscleGroupRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> create(MuscleGroup muscleGroup) async {
    final db = await _dbHelper.database;
    return await db.insert(
      'muscle_group',
      muscleGroup.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<MuscleGroup>> getAll() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('muscle_group');
    return List.generate(maps.length, (i) {
      return MuscleGroup.fromMap(maps[i]);
    });
  }

  Future<MuscleGroup?> getById(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'muscle_group',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return MuscleGroup.fromMap(maps.first);
  }
}

