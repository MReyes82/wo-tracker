import '../db/database_helper.dart';

class TestDataHelper {
  static Future<void> seedDatabase() async {
    print('=== Starting database seeding ===');

    final dbHelper = DatabaseHelper();
    final db = await dbHelper.database;
    
    print('Database instance obtained');

    try {
      print('Seeding test data...');
      
      // Add muscle groups
      await db.insert('muscle_group', {'id': 1, 'name': 'Chest'});
      await db.insert('muscle_group', {'id': 2, 'name': 'Back'});
      await db.insert('muscle_group', {'id': 3, 'name': 'Legs'});
      await db.insert('muscle_group', {'id': 4, 'name': 'Shoulders'});
      await db.insert('muscle_group', {'id': 5, 'name': 'Arms'});

      // Add equipment types
      await db.insert('equipment_type', {'id': 1, 'name': 'Barbell'});
      await db.insert('equipment_type', {'id': 2, 'name': 'Dumbbell'});
      await db.insert('equipment_type', {'id': 3, 'name': 'Cable'});
      await db.insert('equipment_type', {'id': 4, 'name': 'Machine'});

      // Add exercise types
      await db.insert('exercise_type', {'id': 1, 'name': 'Compound'});
      await db.insert('exercise_type', {'id': 2, 'name': 'Isolation'});

      // Add exercises
      final benchPressExId = await db.insert('exercise', {
        'name': 'Bench Press',
        'exercise_type_id': 1,
        'equipment_type_id': 1,
        'muscle_group_id': 1,
        'created_at': DateTime.now().toIso8601String(),
      });

      final inclineDbPressExId = await db.insert('exercise', {
        'name': 'Incline Dumbbell Press',
        'exercise_type_id': 1,
        'equipment_type_id': 2,
        'muscle_group_id': 1,
        'created_at': DateTime.now().toIso8601String(),
      });

      final lateralRaisesExId = await db.insert('exercise', {
        'name': 'Lateral Raises',
        'exercise_type_id': 2,
        'equipment_type_id': 2,
        'muscle_group_id': 4,
        'created_at': DateTime.now().toIso8601String(),
      });

      final barbellRowExId = await db.insert('exercise', {
        'name': 'Barbell Row',
        'exercise_type_id': 1,
        'equipment_type_id': 1,
        'muscle_group_id': 2,
        'created_at': DateTime.now().toIso8601String(),
      });

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
      
      // Add template exercises
      await db.insert('template_exercise', {
        'template_id': 1,
        'exercise_id': benchPressExId,
        'position': 1,
        'planned_sets': 4,
      });

      await db.insert('template_exercise', {
        'template_id': 1,
        'exercise_id': inclineDbPressExId,
        'position': 2,
        'planned_sets': 3,
      });

      await db.insert('template_exercise', {
        'template_id': 1,
        'exercise_id': lateralRaisesExId,
        'position': 3,
        'planned_sets': 3,
      });

      // Add some sample workout sessions
      final now = DateTime.now();
      
      // Today's workout
      final todaySessionId = await db.insert('workout_session', {
        'template_id': 1,
        'title': 'Push Day',
        'start_time': DateTime(now.year, now.month, now.day, 10, 0).toIso8601String(),
        'created_at': DateTime.now().toIso8601String(),
      });
      
      // Add exercises to today's workout
      final benchPressId = await db.insert('workout_exercise', {
        'session_id': todaySessionId,
        'exercise_id': benchPressExId,
        'exercise_name': 'Bench Press',
        'exercise_description': 'Barbell bench press',
        'planned_sets': 4,
        'position': 1,
        'notes': 'Focus on form',
      });

      final inclineDbPressId = await db.insert('workout_exercise', {
        'session_id': todaySessionId,
        'exercise_id': inclineDbPressExId,
        'exercise_name': 'Incline Dumbbell Press',
        'exercise_description': 'Incline press with dumbbells',
        'planned_sets': 3,
        'position': 2,
      });

      final lateralRaisesId = await db.insert('workout_exercise', {
        'session_id': todaySessionId,
        'exercise_id': lateralRaisesExId,
        'exercise_name': 'Lateral Raises',
        'exercise_description': 'Dumbbell lateral raises',
        'planned_sets': 3,
        'position': 3,
        'notes': 'Light weight, high reps',
      });

      // Add sets for bench press
      for (int i = 1; i <= 4; i++) {
        await db.insert('workout_set', {
          'workout_exercise_id': benchPressId,
          'set_number': i,
          'reps': null,
          'weight': null,
          'completed': 0,
        });
      }

      // Add sets for incline dumbbell press
      for (int i = 1; i <= 3; i++) {
        await db.insert('workout_set', {
          'workout_exercise_id': inclineDbPressId,
          'set_number': i,
          'reps': null,
          'weight': null,
          'completed': 0,
        });
      }

      // Add sets for lateral raises
      for (int i = 1; i <= 3; i++) {
        await db.insert('workout_set', {
          'workout_exercise_id': lateralRaisesId,
          'set_number': i,
          'reps': null,
          'weight': null,
          'completed': 0,
        });
      }

      // Past workouts
      for (int i = 1; i <= 5; i++) {
        final date = now.subtract(Duration(days: i * 2));
        final sessionId = await db.insert('workout_session', {
          'template_id': 1,
          'title': i % 3 == 0 ? 'Pull Day' : 'Push Day',
          'start_time': DateTime(date.year, date.month, date.day, 10, 0).toIso8601String(),
          'end_time': DateTime(date.year, date.month, date.day, 11, 30).toIso8601String(),
          'created_at': date.toIso8601String(),
        });

        // Add sample exercise to past workout
        final exerciseId = await db.insert('workout_exercise', {
          'session_id': sessionId,
          'exercise_id': i % 3 == 0 ? barbellRowExId : benchPressExId,
          'exercise_name': i % 3 == 0 ? 'Barbell Row' : 'Bench Press',
          'exercise_description': 'Compound exercise',
          'planned_sets': 3,
          'position': 1,
        });

        // Add completed sets for past workouts
        for (int j = 1; j <= 3; j++) {
          await db.insert('workout_set', {
            'workout_exercise_id': exerciseId,
            'set_number': j,
            'reps': 8 + j,
            'weight': 100.0 + (j * 10),
            'completed': 1,
            'completed_at': date.toIso8601String(),
          });
        }
      }
      
      print('Test data seeded successfully!');
    } catch (e) {
      print('Error seeding test data: $e');
    }
  }
}

