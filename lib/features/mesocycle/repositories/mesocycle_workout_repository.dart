import '../../../core/db/database_helper.dart';
import '../models/mesocycle_workout.dart';

class MesocycleWorkoutRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> create(MesocycleWorkout mesocycleWorkout) async {
    final db = await _dbHelper.database;
    return await db.insert('mesocycle_workout', mesocycleWorkout.toMap());
  }

  Future<MesocycleWorkout?> getById(int id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'mesocycle_workout',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return MesocycleWorkout.fromMap(maps.first);
  }

  Future<List<MesocycleWorkout>> getByMesocycle(int mesocycleId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'mesocycle_workout',
      where: 'mesocycle_id = ?',
      whereArgs: [mesocycleId],
      orderBy: 'day_of_week ASC',
    );
    return List.generate(maps.length, (i) => MesocycleWorkout.fromMap(maps[i]));
  }

  Future<int> update(MesocycleWorkout mesocycleWorkout) async {
    final db = await _dbHelper.database;
    return await db.update(
      'mesocycle_workout',
      mesocycleWorkout.toMap(),
      where: 'id = ?',
      whereArgs: [mesocycleWorkout.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'mesocycle_workout',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteByMesocycle(int mesocycleId) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'mesocycle_workout',
      where: 'mesocycle_id = ?',
      whereArgs: [mesocycleId],
    );
  }
}
