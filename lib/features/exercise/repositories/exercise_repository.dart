import 'package:sqflite/sqflite.dart';
import '../../../core/db/database_helper.dart';
import '../models/exercise.dart';

class ExerciseRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> create(Exercise exercise) async {
    final db = await _dbHelper.database;
    final exerciseMap = exercise.toMap();
    // Set timestamps if not provided
    if (exerciseMap['created_at'] == null) {
      exerciseMap['created_at'] = DateTime.now().toIso8601String();
    }
    if (exerciseMap['updated_at'] == null) {
      exerciseMap['updated_at'] = DateTime.now().toIso8601String();
    }

    return await db.insert(
      'exercise',
      exerciseMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Exercise>> getAll() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('exercise');
    return List.generate(maps.length, (i) {
      return Exercise.fromMap(maps[i]);
    });
  }

  Future<Exercise?> getById(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'exercise',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return Exercise.fromMap(maps.first);
  }

  Future<List<Exercise>> getByMuscleGroup(int muscleGroupId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'exercise',
      where: 'muscle_group_id = ?',
      whereArgs: [muscleGroupId],
    );
    return List.generate(maps.length, (i) {
      return Exercise.fromMap(maps[i]);
    });
  }

  Future<int> update(Exercise exercise) async {
    final db = await _dbHelper.database;
    final exerciseMap = exercise.toMap();
    // Update the updated_at timestamp
    exerciseMap['updated_at'] = DateTime.now().toIso8601String();

    return await db.update(
      'exercise',
      exerciseMap,
      where: 'id = ?',
      whereArgs: [exercise.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'exercise',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

