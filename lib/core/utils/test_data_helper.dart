import '../db/database_helper.dart';

class TestDataHelper {
  static Future<void> seedDatabase() async {
    print('=== Starting database seeding ===');

    final dbHelper = DatabaseHelper();
    final db = await dbHelper.database;
    
    print('Database instance obtained');

    try {
      // Check if we already have data
      print('Checking for existing data...');
      final result = await db.rawQuery('SELECT COUNT(*) as count FROM workout_session');
      final count = result.first['count'] as int;
      
      print('Found $count existing workout sessions');

      if (count > 0) {
        print('Database already has data, skipping seed');
        return;
      }
      
      print('Seeding test data...');
      
      // Add a workout type
      await db.insert('workout_type', {'id': 1, 'name': 'Push'});
      await db.insert('workout_type', {'id': 2, 'name': 'Pull'});
      await db.insert('workout_type', {'id': 3, 'name': 'Legs'});
      
      // Add a workout template
      await db.insert('workout_template', {
        'id': 1,
        'name': 'Push Day',
        'type_id': 1,
        'created_at': DateTime.now().toIso8601String(),
      });
      
      // Add some sample workout sessions
      final now = DateTime.now();
      
      // Today's workout
      await db.insert('workout_session', {
        'template_id': 1,
        'title': 'Push Day',
        'start_time': DateTime(now.year, now.month, now.day, 10, 0).toIso8601String(),
        'created_at': DateTime.now().toIso8601String(),
      });
      
      // Past workouts
      for (int i = 1; i <= 5; i++) {
        final date = now.subtract(Duration(days: i * 2));
        await db.insert('workout_session', {
          'template_id': 1,
          'title': i % 3 == 0 ? 'Pull Day' : 'Push Day',
          'start_time': DateTime(date.year, date.month, date.day, 10, 0).toIso8601String(),
          'end_time': DateTime(date.year, date.month, date.day, 11, 30).toIso8601String(),
          'created_at': date.toIso8601String(),
        });
      }
      
      print('Test data seeded successfully!');
    } catch (e) {
      print('Error seeding test data: $e');
    }
  }
}

