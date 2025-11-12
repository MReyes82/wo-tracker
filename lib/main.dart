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

  print('=== WoTracker CRUD Testing ===\n');

  print('📝 Phase 1: CREATE Operations');
  print('─' * 50);
  await testCreateOperations();

  print('\n📖 Phase 2: READ Operations');
  print('─' * 50);
  await testReadOperations();

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

Future<void> testReadOperations() async {
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

  print('\n🔍 Testing Catalog READ Operations');
  print('─' * 50);

  // 1. Read Exercise Types
  print('1. Reading Exercise Types...');
  final exerciseTypes = await exerciseTypeRepo.getAll();
  print('   ✓ Found ${exerciseTypes.length} exercise types');
  for (var type in exerciseTypes) {
    print('      • ID: ${type.id}, Name: ${type.name}');
  }

  // Test getById
  if (exerciseTypes.isNotEmpty) {
    final firstType = await exerciseTypeRepo.getById(exerciseTypes.first.id!);
    print('   ✓ Retrieved by ID: ${firstType?.name}');
  }

  // 2. Read Equipment Types
  print('\n2. Reading Equipment Types...');
  final equipmentTypes = await equipmentTypeRepo.getAll();
  print('   ✓ Found ${equipmentTypes.length} equipment types');
  for (var type in equipmentTypes) {
    print('      • ID: ${type.id}, Name: ${type.name}');
  }

  // 3. Read Muscle Groups
  print('\n3. Reading Muscle Groups...');
  final muscleGroups = await muscleGroupRepo.getAll();
  print('   ✓ Found ${muscleGroups.length} muscle groups');
  for (var group in muscleGroups) {
    print('      • ID: ${group.id}, Name: ${group.name}');
  }

  // 4. Read Workout Types
  print('\n4. Reading Workout Types...');
  final workoutTypes = await workoutTypeRepo.getAll();
  print('   ✓ Found ${workoutTypes.length} workout types');
  for (var type in workoutTypes) {
    print('      • ID: ${type.id}, Name: ${type.name}');
  }

  print('\n🏋️ Testing Exercise READ Operations');
  print('─' * 50);

  // 5. Read All Exercises
  print('5. Reading All Exercises...');
  final exercises = await exerciseRepo.getAll();
  print('   ✓ Found ${exercises.length} exercises');
  for (var exercise in exercises) {
    print('      • ID: ${exercise.id}, Name: ${exercise.name}');
    print('        Type: ${exercise.exerciseTypeId}, Equipment: ${exercise.equipmentTypeId}');
    print('        Muscle Group: ${exercise.muscleGroupId}, Default Weight: ${exercise.defaultWorkingWeight}');
  }

  // 6. Test getById for Exercise
  if (exercises.isNotEmpty) {
    print('\n6. Testing getById for Exercise...');
    final exercise = await exerciseRepo.getById(exercises.first.id!);
    print('   ✓ Retrieved exercise: ${exercise?.name}');
  }

  // 7. Test getByMuscleGroup
  if (muscleGroups.isNotEmpty) {
    print('\n7. Testing getByMuscleGroup...');
    final chestGroup = muscleGroups.firstWhere(
      (g) => g.name == 'Chest',
      orElse: () => muscleGroups.first,
    );
    final chestExercises = await exerciseRepo.getByMuscleGroup(chestGroup.id!);
    print('   ✓ Found ${chestExercises.length} exercises for ${chestGroup.name}');
    for (var ex in chestExercises) {
      print('      • ${ex.name}');
    }
  }

  print('\n📋 Testing Workout Template READ Operations');
  print('─' * 50);

  // 8. Read All Workout Templates
  print('8. Reading All Workout Templates...');
  final templates = await workoutTemplateRepo.getAll();
  print('   ✓ Found ${templates.length} templates');
  for (var template in templates) {
    print('      • ID: ${template.id}, Name: ${template.name}, Type: ${template.typeId}');
  }

  // 9. Test getById for Template
  if (templates.isNotEmpty) {
    print('\n9. Testing getById for Template...');
    final template = await workoutTemplateRepo.getById(templates.first.id!);
    print('   ✓ Retrieved template: ${template?.name}');
  }

  // 10. Test getByType for Templates
  if (workoutTypes.isNotEmpty && templates.isNotEmpty) {
    print('\n10. Testing getByType for Templates...');
    final pushType = workoutTypes.firstWhere(
      (t) => t.name == 'Push',
      orElse: () => workoutTypes.first,
    );
    final pushTemplates = await workoutTemplateRepo.getByType(pushType.id!);
    print('   ✓ Found ${pushTemplates.length} templates for ${pushType.name}');
    for (var tmpl in pushTemplates) {
      print('      • ${tmpl.name}');
    }
  }

  // 11. Read Template Exercises
  if (templates.isNotEmpty) {
    print('\n11. Reading Template Exercises...');
    for (var template in templates) {
      final templateExercises = await templateExerciseRepo.getByTemplate(template.id!);
      print('   ✓ Template "${template.name}" has ${templateExercises.length} exercises');
      for (var te in templateExercises) {
        print('      • Position ${te.position}: Exercise ID ${te.exerciseId}, Planned Sets: ${te.plannedSets}');
      }
    }
  }

  print('\n📅 Testing Mesocycle READ Operations');
  print('─' * 50);

  // 12. Read All Mesocycles
  print('12. Reading All Mesocycles...');
  final mesocycles = await mesocycleRepo.getAll();
  print('   ✓ Found ${mesocycles.length} mesocycles');
  for (var meso in mesocycles) {
    print('      • ID: ${meso.id}, Name: ${meso.name}');
    print('        Duration: ${meso.startDate.toLocal().toString().split(' ')[0]} to ${meso.endDate.toLocal().toString().split(' ')[0]}');
    print('        ${meso.weeksQuantity} weeks, ${meso.sessionsPerWeek} sessions/week');
  }

  // 13. Test getById for Mesocycle
  if (mesocycles.isNotEmpty) {
    print('\n13. Testing getById for Mesocycle...');
    final meso = await mesocycleRepo.getById(mesocycles.first.id!);
    print('   ✓ Retrieved mesocycle: ${meso?.name}');
  }

  // 14. Test getActiveMesocycles
  print('\n14. Testing getActiveMesocycles...');
  final activeMesocycles = await mesocycleRepo.getActiveMesocycles();
  print('   ✓ Found ${activeMesocycles.length} active mesocycles');
  for (var meso in activeMesocycles) {
    print('      • ${meso.name}');
  }

  // 15. Test getCurrentMesocycle
  print('\n15. Testing getCurrentMesocycle...');
  final currentMeso = await mesocycleRepo.getCurrentMesocycle();
  if (currentMeso != null) {
    print('   ✓ Current mesocycle: ${currentMeso.name}');
  } else {
    print('   ℹ No current mesocycle (none started or all ended)');
  }

  print('\n💪 Testing Workout Session READ Operations');
  print('─' * 50);

  // 16. Read All Sessions
  print('16. Reading All Workout Sessions...');
  final sessions = await workoutSessionRepo.getAll();
  print('   ✓ Found ${sessions.length} workout sessions');
  for (var session in sessions) {
    print('      • ID: ${session.id}, Title: ${session.title}');
    print('        Template: ${session.templateId}, Mesocycle: ${session.mesocycleId}');
    print('        Start: ${session.startTime.toLocal().toString()}');
    if (session.endTime != null) {
      print('        End: ${session.endTime!.toLocal().toString()}');
    }
  }

  // 17. Test getById for Session
  if (sessions.isNotEmpty) {
    print('\n17. Testing getById for Session...');
    final session = await workoutSessionRepo.getById(sessions.first.id!);
    print('   ✓ Retrieved session: ${session?.title}');
  }

  // 18. Test getByTemplate
  if (templates.isNotEmpty && sessions.isNotEmpty) {
    print('\n18. Testing getByTemplate for Sessions...');
    final firstSession = sessions.first;
    if (firstSession.templateId != null) {
      final templateSessions = await workoutSessionRepo.getByTemplate(firstSession.templateId!);
      print('   ✓ Found ${templateSessions.length} sessions for template ID ${firstSession.templateId}');
    } else {
      print('   ℹ First session has no template ID');
    }
  }

  // 19. Test getRecent
  print('\n19. Testing getRecent Sessions...');
  final recentSessions = await workoutSessionRepo.getRecent(5);
  print('   ✓ Retrieved ${recentSessions.length} most recent sessions');
  for (var session in recentSessions) {
    print('      • ${session.title} - ${session.startTime.toLocal().toString().split('.')[0]}');
  }

  print('\n🎯 Testing Workout Exercise & Set READ Operations');
  print('─' * 50);

  // 20. Read Workout Exercises for Sessions
  if (sessions.isNotEmpty) {
    print('20. Reading Workout Exercises for Sessions...');
    for (var session in sessions) {
      final workoutExercises = await workoutExerciseRepo.getBySession(session.id!);
      print('   ✓ Session "${session.title}" has ${workoutExercises.length} exercises');

      for (var we in workoutExercises) {
        print('      • Position ${we.position}: ${we.exerciseName}');
        print('        Planned Sets: ${we.plannedSets}, Exercise ID: ${we.exerciseId}');

        // 21. Read Sets for each Workout Exercise
        final sets = await workoutSetRepo.getByWorkoutExercise(we.id!);
        print('        Sets (${sets.length}):');
        for (var set in sets) {
          final completedMark = set.completed ? '✓' : '○';
          print('          $completedMark Set ${set.setNumber}: ${set.reps} reps @ ${set.weight}kg, RPE ${set.effortLevel}');
        }
      }
    }
  }

  print('\n📊 Testing Summary Statistics');
  print('─' * 50);
  print('Total Catalog Entries:');
  print('   • Exercise Types: ${exerciseTypes.length}');
  print('   • Equipment Types: ${equipmentTypes.length}');
  print('   • Muscle Groups: ${muscleGroups.length}');
  print('   • Workout Types: ${workoutTypes.length}');
  print('\nTotal User-Created Templates:');
  print('   • Exercises: ${exercises.length}');
  print('   • Workout Templates: ${templates.length}');
  print('   • Mesocycles: ${mesocycles.length}');
  print('\nTotal Session Data:');
  print('   • Workout Sessions: ${sessions.length}');

  int totalSets = 0;
  for (var session in sessions) {
    final workoutExercises = await workoutExerciseRepo.getBySession(session.id!);
    for (var we in workoutExercises) {
      final sets = await workoutSetRepo.getByWorkoutExercise(we.id!);
      totalSets += sets.length;
    }
  }
  print('   • Total Sets Logged: $totalSets');
}


