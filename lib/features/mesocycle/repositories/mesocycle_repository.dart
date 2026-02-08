import '../../../core/db/database_helper.dart';
import '../models/mesocycle.dart';

class MesocycleRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> create(Mesocycle mesocycle) async {
    final db = await _dbHelper.database;
    return await db.insert('mesocycle', mesocycle.toMap());
  }

  Future<Mesocycle?> getById(int id) async {
    final db = await _dbHelper.database;
    final maps = await db.query('mesocycle', where: 'id = ?', whereArgs: [id]);

    if (maps.isEmpty) return null;
    return Mesocycle.fromMap(maps.first);
  }

  Future<List<Mesocycle>> getAll() async {
    final db = await _dbHelper.database;
    final maps = await db.query('mesocycle', orderBy: 'start_date DESC');
    return List.generate(maps.length, (i) => Mesocycle.fromMap(maps[i]));
  }

  Future<int> update(Mesocycle mesocycle) async {
    final db = await _dbHelper.database;
    return await db.update(
      'mesocycle',
      mesocycle.toMap(),
      where: 'id = ?',
      whereArgs: [mesocycle.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('mesocycle', where: 'id = ?', whereArgs: [id]);
  }

  /// Get active mesocycles (those that haven't ended yet)
  Future<List<Mesocycle>> getActiveMesocycles() async {
    final db = await _dbHelper.database;
    final now = DateTime.now().toIso8601String();
    final maps = await db.query(
      'mesocycle',
      where: 'end_date >= ?',
      whereArgs: [now],
      orderBy: 'start_date ASC',
    );
    return List.generate(maps.length, (i) => Mesocycle.fromMap(maps[i]));
  }

  /// Get current mesocycle (active and started)
  Future<Mesocycle?> getCurrentMesocycle() async {
    final db = await _dbHelper.database;
    final now = DateTime.now().toIso8601String();
    final maps = await db.query(
      'mesocycle',
      where: 'start_date <= ? AND end_date >= ?',
      whereArgs: [now, now],
      orderBy: 'start_date DESC',
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return Mesocycle.fromMap(maps.first);
  }
}
