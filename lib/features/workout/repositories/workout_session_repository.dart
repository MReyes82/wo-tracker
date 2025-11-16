import 'package:sqflite/sqflite.dart';
import '../../../core/db/database_helper.dart';
import '../models/workout_session.dart';

class WorkoutSessionRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();


  Future<int> create(WorkoutSession session) async {
    final db = await _dbHelper.database;
    final sessionMap = session.toMap();
    // Set created_at timestamp if not provided
    if (sessionMap['created_at'] == null) {
      sessionMap['created_at'] = DateTime.now().toIso8601String();
    }

    return await db.insert(
      'workout_session',
      sessionMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<WorkoutSession>> getAll() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'workout_session',
      orderBy: 'start_time DESC',
    );
    return List.generate(maps.length, (i) {
      return WorkoutSession.fromMap(maps[i]);
    });
  }

  Future<WorkoutSession?> getById(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'workout_session',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return WorkoutSession.fromMap(maps.first);
  }

  Future<List<WorkoutSession>> getByTemplate(int templateId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'workout_session',
      where: 'template_id = ?',
      whereArgs: [templateId],
      orderBy: 'start_time DESC',
    );
    return List.generate(maps.length, (i) {
      return WorkoutSession.fromMap(maps[i]);
    });
  }

  Future<List<WorkoutSession>> getRecent(int limit) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'workout_session',
      orderBy: 'start_time DESC',
      limit: limit,
    );
    return List.generate(maps.length, (i) {
      return WorkoutSession.fromMap(maps[i]);
    });
  }

  Future<int> update(WorkoutSession session) async {
    final db = await _dbHelper.database;
    return await db.update(
      'workout_session',
      session.toMap(),
      where: 'id = ?',
      whereArgs: [session.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'workout_session',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

