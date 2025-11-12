import 'package:sqflite/sqflite.dart';
import '../../../core/db/database_helper.dart';
import '../models/workout_set.dart';

class WorkoutSetRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> create(WorkoutSet workoutSet) async {
    final db = await _dbHelper.database;
    return await db.insert(
      'workout_set',
      workoutSet.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<WorkoutSet>> getAll() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('workout_set');
    return List.generate(maps.length, (i) {
      return WorkoutSet.fromMap(maps[i]);
    });
  }

  Future<WorkoutSet?> getById(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'workout_set',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return WorkoutSet.fromMap(maps.first);
  }

  Future<List<WorkoutSet>> getByWorkoutExercise(int workoutExerciseId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'workout_set',
      where: 'workout_exercise_id = ?',
      whereArgs: [workoutExerciseId],
      orderBy: 'set_number ASC',
    );
    return List.generate(maps.length, (i) {
      return WorkoutSet.fromMap(maps[i]);
    });
  }

  Future<int> update(WorkoutSet workoutSet) async {
    final db = await _dbHelper.database;
    return await db.update(
      'workout_set',
      workoutSet.toMap(),
      where: 'id = ?',
      whereArgs: [workoutSet.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'workout_set',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

