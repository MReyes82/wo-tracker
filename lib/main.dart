import 'package:flutter/material.dart';
import 'core/db/database_helper.dart';
import 'features/exercise/repositories/exercise_type_repository.dart';
import 'features/exercise/repositories/equipment_type_repository.dart';
import 'features/exercise/repositories/muscle_group_repository.dart';
import 'features/workout/repositories/workout_type_repository.dart';
import 'features/exercise/repositories/exercise_repository.dart';
import 'features/workout/repositories/workout_template_repository.dart';
import 'features/workout/repositories/template_exercise_repository.dart';
import 'features/workout/repositories/workout_session_repository.dart';
import 'features/workout/repositories/workout_exercise_repository.dart';
import 'features/workout/repositories/workout_set_repository.dart';
import 'features/mesocycle/repositories/mesocycle_repository.dart';
import 'features/exercise/models/exercise_type.dart';
import 'features/exercise/models/equipment_type.dart';
import 'features/exercise/models/muscle_group.dart';
import 'features/workout/models/workout_type.dart';
import 'features/exercise/models/exercise.dart';
import 'features/workout/models/workout_template.dart';
import 'features/workout/models/template_exercise.dart';
import 'features/workout/models/workout_session.dart';
import 'features/workout/models/workout_exercise.dart';
import 'features/workout/models/workout_set.dart';
import 'features/mesocycle/models/mesocycle.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('=== WoTracker CRUD Testing - CREATE Operations ===\n');

  await testCreateOperations();

  // Show database location and cleanup
  final dbHelper = DatabaseHelper();
  final dbPath = await dbHelper.getDatabasePath();

  print('\n📁 Database location: $dbPath');
  print('🧹 Cleaning up: Deleting database file...');
  await dbHelper.deleteDatabase();

  print('💡 Database file has been deleted.');
  print('   Next run will create a fresh database.');
  print('\n=== Testing Complete ===');
}

Future<void> testCreateOperations() async {
  // Initialize repositories
  final exerciseTypeRepo = ExerciseTypeRepository();
  final equipmentTypeRepo = EquipmentTypeRepository();
  final muscleGroupRepo = MuscleGroupRepository();
  final workoutTypeRepo = WorkoutTypeRepository();
  final exerciseRepo = ExerciseRepository();
  final workoutTemplateRepo = WorkoutTemplateRepository();
  final templateExerciseRepo = TemplateExerciseRepository();
  final workoutSessionRepo = WorkoutSessionRepository();
  final workoutExerciseRepo = WorkoutExerciseRepository();
  final workoutSetRepo = WorkoutSetRepository();
  final mesocycleRepo = MesocycleRepository();

  // 1. Create Exercise Types
  print('1. Creating Exercise Types...');
  final compoundTypeId = await exerciseTypeRepo.create(
    ExerciseType(name: 'Strength')
  );
  final isolationTypeId = await exerciseTypeRepo.create(
    ExerciseType(name: 'Cardio')
  );
  print('   ✓ Created Compound (ID: $compoundTypeId)');
  print('   ✓ Created Isolation (ID: $isolationTypeId)');

  // 2. Create Equipment Types
  print('\n2. Creating Equipment Types...');
  final barbellId = await equipmentTypeRepo.create(
    EquipmentType(name: 'Barbell')
  );
  final dumbbellId = await equipmentTypeRepo.create(
    EquipmentType(name: 'Dumbbell')
  );
  final machineId = await equipmentTypeRepo.create(
    EquipmentType(name: 'Machine')
  );
  final bodyweightId = await equipmentTypeRepo.create(
    EquipmentType(name: 'Bodyweight')
  );
  print('   ✓ Created Barbell (ID: $barbellId)');
  print('   ✓ Created Dumbbell (ID: $dumbbellId)');
  print('   ✓ Created Machine (ID: $machineId)');
  print('   ✓ Created Bodyweight (ID: $bodyweightId)');

  // 3. Create Muscle Groups
  print('\n3. Creating Muscle Groups...');
  final chestId = await muscleGroupRepo.create(
    MuscleGroup(name: 'Chest')
  );
  final backId = await muscleGroupRepo.create(
    MuscleGroup(name: 'Back')
  );
  final legsId = await muscleGroupRepo.create(
    MuscleGroup(name: 'Legs')
  );
  final shouldersId = await muscleGroupRepo.create(
    MuscleGroup(name: 'Shoulders')
  );
  print('   ✓ Created Chest (ID: $chestId)');
  print('   ✓ Created Back (ID: $backId)');
  print('   ✓ Created Legs (ID: $legsId)');
  print('   ✓ Created Shoulders (ID: $shouldersId)');

  // 4. Create Workout Types
  print('\n4. Creating Workout Types...');
  final pushId = await workoutTypeRepo.create(
    WorkoutType(name: 'Push')
  );
  final pullId = await workoutTypeRepo.create(
    WorkoutType(name: 'Pull')
  );
  final legDayId = await workoutTypeRepo.create(
    WorkoutType(name: 'Leg Day')
  );
  print('   ✓ Created Push (ID: $pushId)');
  print('   ✓ Created Pull (ID: $pullId)');
  print('   ✓ Created Leg Day (ID: $legDayId)');

  // 5. Create Exercises
  print('\n5. Creating Exercises...');
  final benchPressId = await exerciseRepo.create(
    Exercise(
      name: 'Bench Press',
      exerciseTypeId: compoundTypeId,
      equipmentTypeId: barbellId,
      muscleGroupId: chestId,
      defaultWorkingWeight: 80.0,
      isUsingMetric: true,
    )
  );
  final squatId = await exerciseRepo.create(
    Exercise(
      name: 'Barbell Squat',
      exerciseTypeId: compoundTypeId,
      equipmentTypeId: barbellId,
      muscleGroupId: legsId,
      defaultWorkingWeight: 100.0,
      isUsingMetric: true,
    )
  );
  final pullUpId = await exerciseRepo.create(
    Exercise(
      name: 'Pull-ups',
      exerciseTypeId: compoundTypeId,
      equipmentTypeId: bodyweightId,
      muscleGroupId: backId,
      defaultWorkingWeight: null,
      isUsingMetric: true,
    )
  );
  print('   ✓ Created Bench Press (ID: $benchPressId)');
  print('   ✓ Created Barbell Squat (ID: $squatId)');
  print('   ✓ Created Pull-ups (ID: $pullUpId)');

  // 6. Create Mesocycle
  print('\n6. Creating Mesocycle...');
  final mesocycleId = await mesocycleRepo.create(
    Mesocycle(
      name: 'Hypertrophy Phase 1',
      startDate: DateTime(2025, 11, 1),
      endDate: DateTime(2025, 12, 26),
      weeksQuantity: 8,
      sessionsPerWeek: 4,
      createdAt: DateTime.now(),
    )
  );
  print('   ✓ Created Hypertrophy Phase 1 (ID: $mesocycleId, 8 weeks, 4 sessions/week)');

  // 7. Create Workout Template
  print('\n7. Creating Workout Template...');
  final pushTemplateId = await workoutTemplateRepo.create(
    WorkoutTemplate(
      name: 'Push Day A',
      typeId: pushId,
    )
  );
  print('   ✓ Created Push Day A template (ID: $pushTemplateId)');

  // 8. Add Exercises to Template
  print('\n8. Adding Exercises to Template...');
  final te1Id = await templateExerciseRepo.create(
    TemplateExercise(
      templateId: pushTemplateId,
      exerciseId: benchPressId,
      position: 1,
      plannedSets: 4,
    )
  );
  print('   ✓ Added Bench Press to template (ID: $te1Id)');

  // 9. Create Workout Session
  print('\n9. Creating Workout Session...');
  final sessionId = await workoutSessionRepo.create(
    WorkoutSession(
      templateId: pushTemplateId,
      title: 'Push Day - Nov 11, 2025',
      startTime: DateTime.now(),
      mesocycleId: mesocycleId,
      notes: 'First workout session test',
    )
  );
  print('   ✓ Created workout session (ID: $sessionId) linked to mesocycle');

  // 10. Add Exercise to Session (snapshot)
  print('\n10. Adding Exercise to Session...');
  final workoutExerciseId = await workoutExerciseRepo.create(
    WorkoutExercise(
      sessionId: sessionId,
      templateExerciseId: te1Id,
      exerciseId: benchPressId,
      exerciseName: 'Bench Press',
      exerciseDescription: 'Barbell compound chest exercise',
      plannedSets: 4,
      position: 1,
    )
  );
  print('   ✓ Added Bench Press to session (ID: $workoutExerciseId)');

  // 11. Create Sets for the Exercise
  print('\n11. Creating Sets...');
  for (int i = 1; i <= 4; i++) {
    final setId = await workoutSetRepo.create(
      WorkoutSet(
        workoutExerciseId: workoutExerciseId,
        setNumber: i,
        reps: 8,
        weight: 80.0,
        effortLevel: 7 + i, // RPE increases each set
        completed: true,
        completedAt: DateTime.now(),
      )
    );
    print('   ✓ Created Set $i (ID: $setId) - 8 reps @ 80kg, RPE ${7 + i}');
  }

  // 12. Retrieve and Display Data
  print('\n12. Retrieving Created Data...');

  final allExerciseTypes = await exerciseTypeRepo.getAll();
  print('   Exercise Types: ${allExerciseTypes.length} total');
  for (var type in allExerciseTypes) {
    print('      - $type');
  }

  final allExercises = await exerciseRepo.getAll();
  print('   Exercises: ${allExercises.length} total');
  for (var exercise in allExercises) {
    print('      - $exercise');
  }

  final allMesocycles = await mesocycleRepo.getAll();
  print('   Mesocycles: ${allMesocycles.length} total');
  for (var mesocycle in allMesocycles) {
    print('      - $mesocycle');
  }

  final allTemplates = await workoutTemplateRepo.getAll();
  print('   Workout Templates: ${allTemplates.length} total');
  for (var template in allTemplates) {
    print('      - $template');
  }

  final allSessions = await workoutSessionRepo.getAll();
  print('   Workout Sessions: ${allSessions.length} total');
  for (var session in allSessions) {
    print('      - $session');
  }

  final sessionExercises = await workoutExerciseRepo.getBySession(sessionId);
  print('   Exercises in Session: ${sessionExercises.length} total');
  for (var we in sessionExercises) {
    print('      - $we');
    final sets = await workoutSetRepo.getByWorkoutExercise(we.id!);
    for (var set in sets) {
      print('         └─ $set');
    }
  }
}
