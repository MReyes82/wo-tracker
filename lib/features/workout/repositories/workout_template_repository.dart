import 'package:sqflite/sqflite.dart';
import '../../../core/db/database_helper.dart';
import '../models/workout_template.dart';

class WorkoutTemplateRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> create(WorkoutTemplate template) async {
    final db = await _dbHelper.database;
    final templateMap = template.toMap();
    // Set timestamps if not provided
    if (templateMap['created_at'] == null) {
      templateMap['created_at'] = DateTime.now().toIso8601String();
    }
    if (templateMap['updated_at'] == null) {
      templateMap['updated_at'] = DateTime.now().toIso8601String();
    }

    return await db.insert(
      'workout_template',
      templateMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<WorkoutTemplate>> getAll() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('workout_template');
    return List.generate(maps.length, (i) {
      return WorkoutTemplate.fromMap(maps[i]);
    });
  }

  Future<WorkoutTemplate?> getById(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'workout_template',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return WorkoutTemplate.fromMap(maps.first);
  }

  Future<List<WorkoutTemplate>> getByType(int typeId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'workout_template',
      where: 'type_id = ?',
      whereArgs: [typeId],
    );
    return List.generate(maps.length, (i) {
      return WorkoutTemplate.fromMap(maps[i]);
    });
  }

  Future<int> update(WorkoutTemplate template) async {
    final db = await _dbHelper.database;
    final templateMap = template.toMap();
    // Update the updated_at timestamp
    templateMap['updated_at'] = DateTime.now().toIso8601String();

    return await db.update(
      'workout_template',
      templateMap,
      where: 'id = ?',
      whereArgs: [template.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'workout_template',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

