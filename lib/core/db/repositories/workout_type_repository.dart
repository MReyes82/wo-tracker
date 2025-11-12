import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../../../shared/models/workout_type.dart';

class WorkoutTypeRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> create(WorkoutType workoutType) async {
    final db = await _dbHelper.database;
    return await db.insert(
      'workout_type',
      workoutType.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<WorkoutType>> getAll() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('workout_type');
    return List.generate(maps.length, (i) {
      return WorkoutType.fromMap(maps[i]);
    });
  }

  Future<WorkoutType?> getById(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'workout_type',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return WorkoutType.fromMap(maps.first);
  }
}

