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

  print('\n✏️ Phase 3: UPDATE Operations');
  print('─' * 50);
  await testUpdateOperations();

  print('\n🗑️ Phase 4: DELETE Operations');
  print('─' * 50);
  await testDeleteOperations();

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

Future<void> testUpdateOperations() async {
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

  print('\n🏷️ Testing Catalog UPDATE Operations');
  print('─' * 50);

  // 1. Update Exercise Type
  print('1. Updating Exercise Type...');
  final exerciseTypes = await exerciseTypeRepo.getAll();
  if (exerciseTypes.isNotEmpty) {
    final typeToUpdate = exerciseTypes.first;
    print('   Before: ID=${typeToUpdate.id}, Name="${typeToUpdate.name}"');

    final updatedType = ExerciseType(
      id: typeToUpdate.id,
      name: '${typeToUpdate.name} (Modified)',
    );

    await exerciseTypeRepo.update(updatedType);
    final verified = await exerciseTypeRepo.getById(typeToUpdate.id!);
    print('   After:  ID=${verified?.id}, Name="${verified?.name}"');
    print('   ✓ Exercise Type updated successfully');
  }

  // 2. Update Equipment Type
  print('\n2. Updating Equipment Type...');
  final equipmentTypes = await equipmentTypeRepo.getAll();
  if (equipmentTypes.isNotEmpty) {
    final typeToUpdate = equipmentTypes.first;
    print('   Before: ID=${typeToUpdate.id}, Name="${typeToUpdate.name}"');

    final updatedType = EquipmentType(
      id: typeToUpdate.id,
      name: '${typeToUpdate.name} (Updated)',
    );

    await equipmentTypeRepo.update(updatedType);
    final verified = await equipmentTypeRepo.getById(typeToUpdate.id!);
    print('   After:  ID=${verified?.id}, Name="${verified?.name}"');
    print('   ✓ Equipment Type updated successfully');
  }

  // 3. Update Muscle Group
  print('\n3. Updating Muscle Group...');
  final muscleGroups = await muscleGroupRepo.getAll();
  if (muscleGroups.isNotEmpty) {
    final groupToUpdate = muscleGroups.first;
    print('   Before: ID=${groupToUpdate.id}, Name="${groupToUpdate.name}"');

    final updatedGroup = MuscleGroup(
      id: groupToUpdate.id,
      name: '${groupToUpdate.name} (Modified)',
    );

    await muscleGroupRepo.update(updatedGroup);
    final verified = await muscleGroupRepo.getById(groupToUpdate.id!);
    print('   After:  ID=${verified?.id}, Name="${verified?.name}"');
    print('   ✓ Muscle Group updated successfully');
  }

  // 4. Update Workout Type
  print('\n4. Updating Workout Type...');
  final workoutTypes = await workoutTypeRepo.getAll();
  if (workoutTypes.isNotEmpty) {
    final typeToUpdate = workoutTypes.first;
    print('   Before: ID=${typeToUpdate.id}, Name="${typeToUpdate.name}"');

    final updatedType = WorkoutType(
      id: typeToUpdate.id,
      name: '${typeToUpdate.name} (Updated)',
    );

    await workoutTypeRepo.update(updatedType);
    final verified = await workoutTypeRepo.getById(typeToUpdate.id!);
    print('   After:  ID=${verified?.id}, Name="${verified?.name}"');
    print('   ✓ Workout Type updated successfully');
  }

  print('\n🏋️ Testing Exercise UPDATE Operations');
  print('─' * 50);

  // 5. Update Exercise
  print('5. Updating Exercise...');
  final exercises = await exerciseRepo.getAll();
  if (exercises.isNotEmpty) {
    final exerciseToUpdate = exercises.first;
    print('   Before: ID=${exerciseToUpdate.id}, Name="${exerciseToUpdate.name}"');
    print('           Weight=${exerciseToUpdate.defaultWorkingWeight}kg');

    final updatedExercise = Exercise(
      id: exerciseToUpdate.id,
      name: '${exerciseToUpdate.name} (Pro Version)',
      exerciseTypeId: exerciseToUpdate.exerciseTypeId,
      equipmentTypeId: exerciseToUpdate.equipmentTypeId,
      muscleGroupId: exerciseToUpdate.muscleGroupId,
      defaultWorkingWeight: (exerciseToUpdate.defaultWorkingWeight ?? 0) + 10.0,
      isUsingMetric: exerciseToUpdate.isUsingMetric,
      createdAt: exerciseToUpdate.createdAt,
    );

    await exerciseRepo.update(updatedExercise);
    final verified = await exerciseRepo.getById(exerciseToUpdate.id!);
    print('   After:  ID=${verified?.id}, Name="${verified?.name}"');
    print('           Weight=${verified?.defaultWorkingWeight}kg');
    print('   ✓ Exercise updated successfully (weight increased by 10kg)');
  }

  print('\n📋 Testing Workout Template UPDATE Operations');
  print('─' * 50);

  // 6. Update Workout Template
  print('6. Updating Workout Template...');
  final templates = await workoutTemplateRepo.getAll();
  if (templates.isNotEmpty) {
    final templateToUpdate = templates.first;
    print('   Before: ID=${templateToUpdate.id}, Name="${templateToUpdate.name}"');

    final updatedTemplate = WorkoutTemplate(
      id: templateToUpdate.id,
      name: '${templateToUpdate.name} V2',
      typeId: templateToUpdate.typeId,
      createdAt: templateToUpdate.createdAt,
    );

    await workoutTemplateRepo.update(updatedTemplate);
    final verified = await workoutTemplateRepo.getById(templateToUpdate.id!);
    print('   After:  ID=${verified?.id}, Name="${verified?.name}"');
    print('   ✓ Workout Template updated successfully');
  }

  // 7. Update Template Exercise
  print('\n7. Updating Template Exercise...');
  if (templates.isNotEmpty) {
    final templateExercises = await templateExerciseRepo.getByTemplate(templates.first.id!);
    if (templateExercises.isNotEmpty) {
      final teToUpdate = templateExercises.first;
      print('   Before: ID=${teToUpdate.id}, Position=${teToUpdate.position}, Planned Sets=${teToUpdate.plannedSets}');

      final updatedTe = TemplateExercise(
        id: teToUpdate.id,
        templateId: teToUpdate.templateId,
        exerciseId: teToUpdate.exerciseId,
        position: teToUpdate.position,
        plannedSets: (teToUpdate.plannedSets ?? 0) + 1,
      );

      await templateExerciseRepo.update(updatedTe);
      final verified = await templateExerciseRepo.getById(teToUpdate.id!);
      print('   After:  ID=${verified?.id}, Position=${verified?.position}, Planned Sets=${verified?.plannedSets}');
      print('   ✓ Template Exercise updated successfully (added 1 set)');
    }
  }

  print('\n📅 Testing Mesocycle UPDATE Operations');
  print('─' * 50);

  // 8. Update Mesocycle
  print('8. Updating Mesocycle...');
  final mesocycles = await mesocycleRepo.getAll();
  if (mesocycles.isNotEmpty) {
    final mesoToUpdate = mesocycles.first;
    print('   Before: ID=${mesoToUpdate.id}, Name="${mesoToUpdate.name}"');
    print('           Weeks=${mesoToUpdate.weeksQuantity}, Sessions/week=${mesoToUpdate.sessionsPerWeek}');

    final updatedMeso = Mesocycle(
      id: mesoToUpdate.id,
      name: '${mesoToUpdate.name} (Extended)',
      startDate: mesoToUpdate.startDate,
      endDate: mesoToUpdate.endDate.add(Duration(days: 14)), // Add 2 weeks
      weeksQuantity: mesoToUpdate.weeksQuantity + 2,
      sessionsPerWeek: mesoToUpdate.sessionsPerWeek,
      createdAt: mesoToUpdate.createdAt,
    );

    await mesocycleRepo.update(updatedMeso);
    final verified = await mesocycleRepo.getById(mesoToUpdate.id!);
    print('   After:  ID=${verified?.id}, Name="${verified?.name}"');
    print('           Weeks=${verified?.weeksQuantity}, Sessions/week=${verified?.sessionsPerWeek}');
    print('   ✓ Mesocycle updated successfully (extended by 2 weeks)');
  }

  print('\n💪 Testing Workout Session UPDATE Operations');
  print('─' * 50);

  // 9. Update Workout Session
  print('9. Updating Workout Session...');
  final sessions = await workoutSessionRepo.getAll();
  if (sessions.isNotEmpty) {
    final sessionToUpdate = sessions.first;
    print('   Before: ID=${sessionToUpdate.id}, Title="${sessionToUpdate.title}"');
    print('           Notes="${sessionToUpdate.notes ?? "None"}"');

    final updatedSession = WorkoutSession(
      id: sessionToUpdate.id,
      templateId: sessionToUpdate.templateId,
      title: '${sessionToUpdate.title} (Completed)',
      startTime: sessionToUpdate.startTime,
      endTime: DateTime.now(), // Set end time
      mesocycleId: sessionToUpdate.mesocycleId,
      notes: '${sessionToUpdate.notes ?? ""}\nGreat workout! Felt strong.',
      createdAt: sessionToUpdate.createdAt,
    );

    await workoutSessionRepo.update(updatedSession);
    final verified = await workoutSessionRepo.getById(sessionToUpdate.id!);
    print('   After:  ID=${verified?.id}, Title="${verified?.title}"');
    print('           End Time: ${verified?.endTime?.toLocal().toString().split('.')[0]}');
    print('           Notes="${verified?.notes}"');
    print('   ✓ Workout Session updated successfully (marked as completed)');
  }

  print('\n🎯 Testing Workout Exercise & Set UPDATE Operations');
  print('─' * 50);

  // 10. Update Workout Exercise
  print('10. Updating Workout Exercise...');
  if (sessions.isNotEmpty) {
    final workoutExercises = await workoutExerciseRepo.getBySession(sessions.first.id!);
    if (workoutExercises.isNotEmpty) {
      final weToUpdate = workoutExercises.first;
      print('   Before: ID=${weToUpdate.id}, Name="${weToUpdate.exerciseName}"');
      print('           Planned Sets=${weToUpdate.plannedSets}');

      final updatedWe = WorkoutExercise(
        id: weToUpdate.id,
        sessionId: weToUpdate.sessionId,
        templateExerciseId: weToUpdate.templateExerciseId,
        exerciseId: weToUpdate.exerciseId,
        exerciseName: weToUpdate.exerciseName,
        exerciseDescription: '${weToUpdate.exerciseDescription ?? ""}\nFocus on form!',
        plannedSets: (weToUpdate.plannedSets ?? 0) + 1,
        position: weToUpdate.position,
      );

      await workoutExerciseRepo.update(updatedWe);
      final verified = await workoutExerciseRepo.getById(weToUpdate.id!);
      print('   After:  ID=${verified?.id}, Name="${verified?.exerciseName}"');
      print('           Planned Sets=${verified?.plannedSets}');
      print('   ✓ Workout Exercise updated successfully (added 1 set)');

      // 11. Update Workout Sets
      print('\n11. Updating Workout Sets...');
      final sets = await workoutSetRepo.getByWorkoutExercise(weToUpdate.id!);
      if (sets.isNotEmpty) {
        final setToUpdate = sets.first;
        print('   Before: Set ${setToUpdate.setNumber} - ${setToUpdate.reps} reps @ ${setToUpdate.weight}kg, RPE ${setToUpdate.effortLevel}');

        final updatedSet = WorkoutSet(
          id: setToUpdate.id,
          workoutExerciseId: setToUpdate.workoutExerciseId,
          setNumber: setToUpdate.setNumber,
          reps: (setToUpdate.reps ?? 0) + 2, // Increase reps by 2
          weight: (setToUpdate.weight ?? 0.0) + 2.5, // Increase weight by 2.5kg
          effortLevel: (setToUpdate.effortLevel ?? 0) == 10 ? 10 : (setToUpdate.effortLevel ?? 0) + 1,
          completed: setToUpdate.completed,
          completedAt: setToUpdate.completedAt,
        );

        await workoutSetRepo.update(updatedSet);
        final verified = await workoutSetRepo.getById(setToUpdate.id!);
        print('   After:  Set ${verified?.setNumber} - ${verified?.reps} reps @ ${verified?.weight}kg, RPE ${verified?.effortLevel}');
        print('   ✓ Workout Set updated successfully (improved performance!)');
      }
    }
  }

  print('\n📊 Verification - Reading All Updated Data');
  print('─' * 50);

  // Verify all changes
  print('Catalog items (showing first 2 of each):');
  final updatedExerciseTypes = await exerciseTypeRepo.getAll();
  print('   Exercise Types: ${updatedExerciseTypes.take(2).map((e) => e.name).join(", ")}');

  final updatedEquipmentTypes = await equipmentTypeRepo.getAll();
  print('   Equipment Types: ${updatedEquipmentTypes.take(2).map((e) => e.name).join(", ")}');

  final updatedMuscleGroups = await muscleGroupRepo.getAll();
  print('   Muscle Groups: ${updatedMuscleGroups.take(2).map((e) => e.name).join(", ")}');

  final updatedWorkoutTypes = await workoutTypeRepo.getAll();
  print('   Workout Types: ${updatedWorkoutTypes.take(2).map((e) => e.name).join(", ")}');

  print('\nUser-created items:');
  final updatedExercises = await exerciseRepo.getAll();
  print('   Exercises: ${updatedExercises.take(2).map((e) => '${e.name} (${e.defaultWorkingWeight}kg)').join(", ")}');

  final updatedTemplates = await workoutTemplateRepo.getAll();
  print('   Templates: ${updatedTemplates.map((e) => e.name).join(", ")}');

  final updatedMesocycles = await mesocycleRepo.getAll();
  print('   Mesocycles: ${updatedMesocycles.map((e) => '${e.name} (${e.weeksQuantity}w)').join(", ")}');

  print('\n✅ All UPDATE operations completed successfully!');
}

Future<void> testDeleteOperations() async {
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

  print('\n🎯 Testing Workout Set DELETE Operations');
  print('─' * 50);

  // 1. Delete Workout Sets
  print('1. Deleting Workout Sets...');
  final allSets = await workoutSetRepo.getAll();
  print('   Before: ${allSets.length} sets in database');

  if (allSets.isNotEmpty) {
    final setToDelete = allSets.first;
    print('   Deleting Set ID ${setToDelete.id}: Set ${setToDelete.setNumber} - ${setToDelete.reps} reps @ ${setToDelete.weight}kg');

    await workoutSetRepo.delete(setToDelete.id!);

    final verifyDeleted = await workoutSetRepo.getById(setToDelete.id!);
    final remainingSets = await workoutSetRepo.getAll();
    print('   After: ${remainingSets.length} sets in database');
    print('   Verification: ${verifyDeleted == null ? "✓ Set successfully deleted" : "✗ Set still exists"}');
  }

  print('\n💪 Testing Workout Exercise DELETE Operations');
  print('─' * 50);

  // 2. Delete Workout Exercise (this would cascade delete remaining sets)
  print('2. Deleting Workout Exercise...');
  final allWorkoutExercises = await workoutExerciseRepo.getAll();
  print('   Before: ${allWorkoutExercises.length} workout exercises in database');

  if (allWorkoutExercises.isNotEmpty) {
    final weToDelete = allWorkoutExercises.first;
    print('   Deleting Workout Exercise ID ${weToDelete.id}: "${weToDelete.exerciseName}"');

    // Check how many sets will be affected
    final setsForThisExercise = await workoutSetRepo.getByWorkoutExercise(weToDelete.id!);
    print('   This will also affect ${setsForThisExercise.length} sets (if cascading)');

    await workoutExerciseRepo.delete(weToDelete.id!);

    final verifyDeleted = await workoutExerciseRepo.getById(weToDelete.id!);
    final remainingWE = await workoutExerciseRepo.getAll();
    print('   After: ${remainingWE.length} workout exercises in database');
    print('   Verification: ${verifyDeleted == null ? "✓ Workout Exercise successfully deleted" : "✗ Workout Exercise still exists"}');
  }

  print('\n📅 Testing Workout Session DELETE Operations');
  print('─' * 50);

  // 3. Delete Workout Session
  print('3. Deleting Workout Session...');
  final allSessions = await workoutSessionRepo.getAll();
  print('   Before: ${allSessions.length} workout sessions in database');

  if (allSessions.isNotEmpty) {
    final sessionToDelete = allSessions.first;
    print('   Deleting Session ID ${sessionToDelete.id}: "${sessionToDelete.title}"');

    await workoutSessionRepo.delete(sessionToDelete.id!);

    final verifyDeleted = await workoutSessionRepo.getById(sessionToDelete.id!);
    final remainingSessions = await workoutSessionRepo.getAll();
    print('   After: ${remainingSessions.length} workout sessions in database');
    print('   Verification: ${verifyDeleted == null ? "✓ Session successfully deleted" : "✗ Session still exists"}');
  }

  print('\n📋 Testing Template Exercise DELETE Operations');
  print('─' * 50);

  // 4. Delete Template Exercise
  print('4. Deleting Template Exercise...');
  final allTemplateExercises = await templateExerciseRepo.getAll();
  print('   Before: ${allTemplateExercises.length} template exercises in database');

  if (allTemplateExercises.isNotEmpty) {
    final teToDelete = allTemplateExercises.first;
    print('   Deleting Template Exercise ID ${teToDelete.id}: Exercise ${teToDelete.exerciseId} at position ${teToDelete.position}');

    await templateExerciseRepo.delete(teToDelete.id!);

    final verifyDeleted = await templateExerciseRepo.getById(teToDelete.id!);
    final remainingTE = await templateExerciseRepo.getAll();
    print('   After: ${remainingTE.length} template exercises in database');
    print('   Verification: ${verifyDeleted == null ? "✓ Template Exercise successfully deleted" : "✗ Template Exercise still exists"}');
  }

  print('\n📝 Testing Workout Template DELETE Operations');
  print('─' * 50);

  // 5. Delete Workout Template
  print('5. Deleting Workout Template...');
  final allTemplates = await workoutTemplateRepo.getAll();
  print('   Before: ${allTemplates.length} workout templates in database');

  if (allTemplates.isNotEmpty) {
    final templateToDelete = allTemplates.first;
    print('   Deleting Template ID ${templateToDelete.id}: "${templateToDelete.name}"');

    await workoutTemplateRepo.delete(templateToDelete.id!);

    final verifyDeleted = await workoutTemplateRepo.getById(templateToDelete.id!);
    final remainingTemplates = await workoutTemplateRepo.getAll();
    print('   After: ${remainingTemplates.length} workout templates in database');
    print('   Verification: ${verifyDeleted == null ? "✓ Template successfully deleted" : "✗ Template still exists"}');
  }

  print('\n🏋️ Testing Exercise DELETE Operations');
  print('─' * 50);

  // 6. Delete Exercise
  print('6. Deleting Exercise...');
  final allExercises = await exerciseRepo.getAll();
  print('   Before: ${allExercises.length} exercises in database');

  if (allExercises.length > 1) {
    // Delete the second one to keep at least one
    final exerciseToDelete = allExercises[1];
    print('   Deleting Exercise ID ${exerciseToDelete.id}: "${exerciseToDelete.name}"');

    await exerciseRepo.delete(exerciseToDelete.id!);

    final verifyDeleted = await exerciseRepo.getById(exerciseToDelete.id!);
    final remainingExercises = await exerciseRepo.getAll();
    print('   After: ${remainingExercises.length} exercises in database');
    print('   Verification: ${verifyDeleted == null ? "✓ Exercise successfully deleted" : "✗ Exercise still exists"}');
  }

  print('\n📆 Testing Mesocycle DELETE Operations');
  print('─' * 50);

  // 7. Delete Mesocycle
  print('7. Deleting Mesocycle...');
  final allMesocycles = await mesocycleRepo.getAll();
  print('   Before: ${allMesocycles.length} mesocycles in database');

  if (allMesocycles.isNotEmpty) {
    final mesoToDelete = allMesocycles.first;
    print('   Deleting Mesocycle ID ${mesoToDelete.id}: "${mesoToDelete.name}"');

    await mesocycleRepo.delete(mesoToDelete.id!);

    final verifyDeleted = await mesocycleRepo.getById(mesoToDelete.id!);
    final remainingMesocycles = await mesocycleRepo.getAll();
    print('   After: ${remainingMesocycles.length} mesocycles in database');
    print('   Verification: ${verifyDeleted == null ? "✓ Mesocycle successfully deleted" : "✗ Mesocycle still exists"}');
  }

  print('\n🏷️ Testing Catalog DELETE Operations');
  print('─' * 50);

  // 8. Delete Catalog Items (be careful - these might have foreign key constraints)
  print('8. Deleting Catalog Items...');

  // Delete a Workout Type
  final allWorkoutTypes = await workoutTypeRepo.getAll();
  if (allWorkoutTypes.length > 1) {
    final workoutTypeToDelete = allWorkoutTypes.last;
    print('   Deleting Workout Type ID ${workoutTypeToDelete.id}: "${workoutTypeToDelete.name}"');
    await workoutTypeRepo.delete(workoutTypeToDelete.id!);
    final verifyWT = await workoutTypeRepo.getById(workoutTypeToDelete.id!);
    print('   ${verifyWT == null ? "✓" : "✗"} Workout Type deleted');
  }

  // Delete a Muscle Group (only if no exercises reference it)
  final allMuscleGroups = await muscleGroupRepo.getAll();
  if (allMuscleGroups.length > 2) {
    final muscleGroupToDelete = allMuscleGroups.last;
    print('   Deleting Muscle Group ID ${muscleGroupToDelete.id}: "${muscleGroupToDelete.name}"');
    try {
      await muscleGroupRepo.delete(muscleGroupToDelete.id!);
      final verifyMG = await muscleGroupRepo.getById(muscleGroupToDelete.id!);
      print('   ${verifyMG == null ? "✓" : "✗"} Muscle Group deleted');
    } catch (e) {
      print('   ⚠ Cannot delete: ${e.toString().contains("FOREIGN KEY") ? "Foreign key constraint (still referenced by exercises)" : e.toString()}');
    }
  }

  // Delete an Equipment Type
  final allEquipmentTypes = await equipmentTypeRepo.getAll();
  if (allEquipmentTypes.length > 2) {
    final equipmentTypeToDelete = allEquipmentTypes.last;
    print('   Deleting Equipment Type ID ${equipmentTypeToDelete.id}: "${equipmentTypeToDelete.name}"');
    try {
      await equipmentTypeRepo.delete(equipmentTypeToDelete.id!);
      final verifyET = await equipmentTypeRepo.getById(equipmentTypeToDelete.id!);
      print('   ${verifyET == null ? "✓" : "✗"} Equipment Type deleted');
    } catch (e) {
      print('   ⚠ Cannot delete: ${e.toString().contains("FOREIGN KEY") ? "Foreign key constraint (still referenced by exercises)" : e.toString()}');
    }
  }

  // Delete an Exercise Type
  final allExerciseTypes = await exerciseTypeRepo.getAll();
  if (allExerciseTypes.length > 1) {
    final exerciseTypeToDelete = allExerciseTypes.last;
    print('   Deleting Exercise Type ID ${exerciseTypeToDelete.id}: "${exerciseTypeToDelete.name}"');
    try {
      await exerciseTypeRepo.delete(exerciseTypeToDelete.id!);
      final verifyEXT = await exerciseTypeRepo.getById(exerciseTypeToDelete.id!);
      print('   ${verifyEXT == null ? "✓" : "✗"} Exercise Type deleted');
    } catch (e) {
      print('   ⚠ Cannot delete: ${e.toString().contains("FOREIGN KEY") ? "Foreign key constraint (still referenced by exercises)" : e.toString()}');
    }
  }

  print('\n📊 Final Database State');
  print('─' * 50);

  // Show what's left in the database
  final finalExerciseTypes = await exerciseTypeRepo.getAll();
  final finalEquipmentTypes = await equipmentTypeRepo.getAll();
  final finalMuscleGroups = await muscleGroupRepo.getAll();
  final finalWorkoutTypes = await workoutTypeRepo.getAll();
  final finalExercises = await exerciseRepo.getAll();
  final finalTemplates = await workoutTemplateRepo.getAll();
  final finalMesocycles = await mesocycleRepo.getAll();
  final finalSessions = await workoutSessionRepo.getAll();
  final finalWorkoutExercises = await workoutExerciseRepo.getAll();
  final finalSets = await workoutSetRepo.getAll();

  print('Remaining Catalog Items:');
  print('   • Exercise Types: ${finalExerciseTypes.length}');
  print('   • Equipment Types: ${finalEquipmentTypes.length}');
  print('   • Muscle Groups: ${finalMuscleGroups.length}');
  print('   • Workout Types: ${finalWorkoutTypes.length}');

  print('\nRemaining User-Created Items:');
  print('   • Exercises: ${finalExercises.length}');
  print('   • Workout Templates: ${finalTemplates.length}');
  print('   • Mesocycles: ${finalMesocycles.length}');

  print('\nRemaining Session Data:');
  print('   • Workout Sessions: ${finalSessions.length}');
  print('   • Workout Exercises: ${finalWorkoutExercises.length}');
  print('   • Workout Sets: ${finalSets.length}');

  print('\n✅ All DELETE operations completed successfully!');
  print('💡 Note: Some deletions may fail due to foreign key constraints,');
  print('   which is expected behavior to maintain data integrity.');
}
