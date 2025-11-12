import 'package:sqflite/sqflite.dart';
import '../../../core/db/database_helper.dart';
import '../models/exercise_type.dart';

class ExerciseTypeRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> create(ExerciseType exerciseType) async {
    final db = await _dbHelper.database;
    return await db.insert(
      'exercise_type',
      exerciseType.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ExerciseType>> getAll() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('exercise_type');
    return List.generate(maps.length, (i) {
      return ExerciseType.fromMap(maps[i]);
    });
  }

  Future<ExerciseType?> getById(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'exercise_type',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return ExerciseType.fromMap(maps.first);
  }

  Future<int> update(ExerciseType exerciseType) async {
    final db = await _dbHelper.database;
    return await db.update(
      'exercise_type',
      exerciseType.toMap(),
      where: 'id = ?',
      whereArgs: [exerciseType.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'exercise_type',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

