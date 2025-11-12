import 'package:sqflite/sqflite.dart';
import '../../../core/db/database_helper.dart';
import '../models/template_exercise.dart';

class TemplateExerciseRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> create(TemplateExercise templateExercise) async {
    final db = await _dbHelper.database;
    return await db.insert(
      'template_exercise',
      templateExercise.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TemplateExercise>> getAll() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('template_exercise');
    return List.generate(maps.length, (i) {
      return TemplateExercise.fromMap(maps[i]);
    });
  }

  Future<TemplateExercise?> getById(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'template_exercise',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return TemplateExercise.fromMap(maps.first);
  }

  Future<List<TemplateExercise>> getByTemplate(int templateId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'template_exercise',
      where: 'template_id = ?',
      whereArgs: [templateId],
      orderBy: 'position ASC',
    );
    return List.generate(maps.length, (i) {
      return TemplateExercise.fromMap(maps[i]);
    });
  }

  Future<int> update(TemplateExercise templateExercise) async {
    final db = await _dbHelper.database;
    return await db.update(
      'template_exercise',
      templateExercise.toMap(),
      where: 'id = ?',
      whereArgs: [templateExercise.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'template_exercise',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

