import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../../../shared/models/workout_exercise.dart';

class WorkoutExerciseRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> create(WorkoutExercise workoutExercise) async {
    final db = await _dbHelper.database;
    return await db.insert(
      'workout_exercise',
      workoutExercise.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<WorkoutExercise>> getAll() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('workout_exercise');
    return List.generate(maps.length, (i) {
      return WorkoutExercise.fromMap(maps[i]);
    });
  }

  Future<WorkoutExercise?> getById(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'workout_exercise',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return WorkoutExercise.fromMap(maps.first);
  }

  Future<List<WorkoutExercise>> getBySession(int sessionId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'workout_exercise',
      where: 'session_id = ?',
      whereArgs: [sessionId],
      orderBy: 'position ASC',
    );
    return List.generate(maps.length, (i) {
      return WorkoutExercise.fromMap(maps[i]);
    });
  }
}

