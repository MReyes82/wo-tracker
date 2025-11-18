import 'package:flutter/foundation.dart';
import '../models/workout_session.dart';
import '../models/workout_exercise.dart';
import '../models/workout_set.dart';
import '../repositories/workout_session_repository.dart';
import '../repositories/workout_exercise_repository.dart';
import '../repositories/workout_set_repository.dart';
import '../../exercise/models/exercise.dart';
import '../../exercise/repositories/exercise_repository.dart';
import '../../exercise/repositories/muscle_group_repository.dart';
import '../../exercise/repositories/equipment_type_repository.dart';

class ExerciseWithSets {
  final WorkoutExercise exercise;
  final List<WorkoutSet> sets;
  final String? equipmentName;
  final String? muscleGroupName;
  final bool isUsingMetric;

  ExerciseWithSets({
    required this.exercise,
    required this.sets,
    this.equipmentName,
    this.muscleGroupName,
    this.isUsingMetric = true,
  });
}

class WorkoutDetailViewModel extends ChangeNotifier {
  final WorkoutSessionRepository _sessionRepository = WorkoutSessionRepository();
  final WorkoutExerciseRepository _exerciseRepository = WorkoutExerciseRepository();
  final WorkoutSetRepository _setRepository = WorkoutSetRepository();
  final ExerciseRepository _exerciseCatalogRepository = ExerciseRepository();
  final MuscleGroupRepository _muscleGroupRepository = MuscleGroupRepository();
  final EquipmentTypeRepository _equipmentTypeRepository = EquipmentTypeRepository();

  WorkoutSession? _session;
  List<ExerciseWithSets> _exercises = [];
  List<Exercise> _availableExercises = [];
  Map<int, int> _exercisesMarkedForWeightUpdate = {}; // Track exercises to update default weight - maps exerciseId to setId
  bool _isLoading = false;
  bool _isEditable = false;
  String? _error;

  WorkoutSession? get session => _session;
  List<ExerciseWithSets> get exercises => _exercises;
  List<Exercise> get availableExercises => _availableExercises;
  bool get isLoading => _isLoading;
  bool get isEditable => _isEditable;
  String? get error => _error;

  Future<void> loadWorkoutDetails(int sessionId, {bool editable = false}) async {
    _isLoading = true;
    _isEditable = editable;
    _error = null;
    notifyListeners();

    try {
      final session = await _sessionRepository.getById(sessionId);

      if (session == null) {
        _error = 'Workout session not found';
        _isLoading = false;
        notifyListeners();
        return;
      }

      _session = session;

      // Load exercises for this session
      final workoutExercises = await _exerciseRepository.getBySession(sessionId);

      // Load sets for each exercise
      _exercises = [];
      for (var exercise in workoutExercises) {
        final sets = await _setRepository.getByWorkoutExercise(exercise.id!);

        // Fetch muscle group and equipment names if exercise_id is available
        String? muscleGroupName;
        String? equipmentName;
        bool isUsingMetric = true; // Default to metric

        if (exercise.exerciseId != null) {
          // Fetch the exercise details from catalog
          final exerciseDetails = await _exerciseCatalogRepository.getById(exercise.exerciseId!);

          if (exerciseDetails != null) {
            // Fetch muscle group name
            final muscleGroup = await _muscleGroupRepository.getById(exerciseDetails.muscleGroupId);
            muscleGroupName = muscleGroup?.name;

            // Fetch equipment type name
            final equipmentType = await _equipmentTypeRepository.getById(exerciseDetails.equipmentTypeId);
            equipmentName = equipmentType?.name;

            // Get unit preference
            isUsingMetric = exerciseDetails.isUsingMetric;
          }
        }

        _exercises.add(ExerciseWithSets(
          exercise: exercise,
          sets: sets,
          equipmentName: equipmentName ?? 'Unknown',
          muscleGroupName: muscleGroupName ?? 'Unknown',
          isUsingMetric: isUsingMetric,
        ));
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load workout details: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addSet(int exerciseId) async {
    try {
      final exerciseIndex = _exercises.indexWhere((e) => e.exercise.id == exerciseId);
      if (exerciseIndex == -1) return;

      final exercise = _exercises[exerciseIndex];
      final newSetNumber = exercise.sets.length + 1;

      final newSet = WorkoutSet(
        workoutExerciseId: exerciseId,
        setNumber: newSetNumber,
        reps: null,
        weight: null,
        completed: false,
      );

      await _setRepository.create(newSet);

      // Reload sets for this exercise
      final updatedSets = await _setRepository.getByWorkoutExercise(exerciseId);
      _exercises[exerciseIndex] = ExerciseWithSets(
        exercise: exercise.exercise,
        sets: updatedSets,
        equipmentName: exercise.equipmentName,
        muscleGroupName: exercise.muscleGroupName,
      );

      notifyListeners();
    } catch (e) {
      print('Error adding set: $e');
    }
  }

  Future<void> deleteLastSet(int exerciseId) async {
    try {
      final exerciseIndex = _exercises.indexWhere((e) => e.exercise.id == exerciseId);
      if (exerciseIndex == -1) return;

      final exercise = _exercises[exerciseIndex];
      if (exercise.sets.isEmpty) return;

      final lastSet = exercise.sets.last;
      await _setRepository.delete(lastSet.id!);

      // Reload sets for this exercise
      final updatedSets = await _setRepository.getByWorkoutExercise(exerciseId);
      _exercises[exerciseIndex] = ExerciseWithSets(
        exercise: exercise.exercise,
        sets: updatedSets,
        equipmentName: exercise.equipmentName,
        muscleGroupName: exercise.muscleGroupName,
      );

      notifyListeners();
    } catch (e) {
      print('Error deleting set: $e');
    }
  }

  Future<void> updateSet(WorkoutSet updatedSet) async {
    try {
      await _setRepository.update(updatedSet);

      // Find and update the set in memory
      for (var i = 0; i < _exercises.length; i++) {
        final setIndex = _exercises[i].sets.indexWhere((s) => s.id == updatedSet.id);
        if (setIndex != -1) {
          final updatedSets = List<WorkoutSet>.from(_exercises[i].sets);
          updatedSets[setIndex] = updatedSet;
          _exercises[i] = ExerciseWithSets(
            exercise: _exercises[i].exercise,
            sets: updatedSets,
            equipmentName: _exercises[i].equipmentName,
            muscleGroupName: _exercises[i].muscleGroupName,
          );
          break;
        }
      }

      notifyListeners();
    } catch (e) {
      print('Error updating set: $e');
    }
  }

  Future<void> updateNotes(String notes) async {
    if (_session == null) return;

    try {
      final updatedSession = WorkoutSession(
        id: _session!.id,
        templateId: _session!.templateId,
        title: _session!.title,
        startTime: _session!.startTime,
        mesocycleId: _session!.mesocycleId,
        endTime: _session!.endTime,
        notes: notes,
        createdAt: _session!.createdAt,
      );

      await _sessionRepository.update(updatedSession);
      _session = updatedSession;
      notifyListeners();
      print('WorkoutDetailViewModel: Updated workout notes');
    } catch (e) {
      print('Error updating notes: $e');
    }
  }

  Future<void> markStartTime() async {
    if (_session == null) return;

    try {
      final updatedSession = WorkoutSession(
        id: _session!.id,
        templateId: _session!.templateId,
        title: _session!.title,
        startTime: DateTime.now(), // Mark start time to NOW
        mesocycleId: _session!.mesocycleId,
        endTime: _session!.endTime,
        notes: _session!.notes,
        createdAt: _session!.createdAt,
      );

      await _sessionRepository.update(updatedSession);
      _session = updatedSession;
      notifyListeners();
      print('WorkoutDetailViewModel: Marked start time to now');
    } catch (e) {
      print('Error marking start time: $e');
    }
  }

  Future<void> updateExerciseNotes(int exerciseId, String notes) async {
    try {
      // Find the exercise and update notes
      for (var i = 0; i < _exercises.length; i++) {
        if (_exercises[i].exercise.id == exerciseId) {
          final updatedExercise = WorkoutExercise(
            id: _exercises[i].exercise.id,
            sessionId: _exercises[i].exercise.sessionId,
            templateExerciseId: _exercises[i].exercise.templateExerciseId,
            exerciseId: _exercises[i].exercise.exerciseId,
            exerciseName: _exercises[i].exercise.exerciseName,
            exerciseDescription: _exercises[i].exercise.exerciseDescription,
            plannedSets: _exercises[i].exercise.plannedSets,
            position: _exercises[i].exercise.position,
            notes: notes,
          );

          await _exerciseRepository.update(updatedExercise);

          _exercises[i] = ExerciseWithSets(
            exercise: updatedExercise,
            sets: _exercises[i].sets,
            equipmentName: _exercises[i].equipmentName,
            muscleGroupName: _exercises[i].muscleGroupName,
            isUsingMetric: _exercises[i].isUsingMetric,
          );

          notifyListeners();
          print('WorkoutDetailViewModel: Updated exercise notes');
          break;
        }
      }
    } catch (e) {
      print('Error updating exercise notes: $e');
    }
  }

  Future<void> loadAvailableExercises() async {
    try {
      _availableExercises = await _exerciseCatalogRepository.getAll();
      notifyListeners();
      print('WorkoutDetailViewModel: Loaded ${_availableExercises.length} available exercises');
    } catch (e) {
      print('Error loading available exercises: $e');
    }
  }

  Future<void> swapExercise(int workoutExerciseId, int newCatalogExerciseId) async {
    try {
      // Find the workout exercise to swap
      for (var i = 0; i < _exercises.length; i++) {
        if (_exercises[i].exercise.id == workoutExerciseId) {
          // Get the new exercise details from catalog
          final newExercise = await _exerciseCatalogRepository.getById(newCatalogExerciseId);
          if (newExercise == null) {
            print('Error: New exercise not found in catalog');
            return;
          }

          // Get muscle group and equipment for the new exercise
          final muscleGroup = await _muscleGroupRepository.getById(newExercise.muscleGroupId);
          final equipment = await _equipmentTypeRepository.getById(newExercise.equipmentTypeId);

          // Store the original template_exercise_id if not already stored
          final originalTemplateExerciseId = _exercises[i].exercise.templateExerciseId;

          // Update the workout exercise with new exercise details
          final updatedWorkoutExercise = WorkoutExercise(
            id: _exercises[i].exercise.id,
            sessionId: _exercises[i].exercise.sessionId,
            templateExerciseId: originalTemplateExerciseId, // Keep original for tracking
            exerciseId: newCatalogExerciseId, // Update to new exercise
            exerciseName: newExercise.name,
            exerciseDescription: newExercise.name,
            plannedSets: _exercises[i].exercise.plannedSets,
            position: _exercises[i].exercise.position,
            notes: _exercises[i].exercise.notes,
          );

          await _exerciseRepository.update(updatedWorkoutExercise);

          // Update all sets with the new exercise's default working weight
          final updatedSets = <WorkoutSet>[];
          final newDefaultWeight = newExercise.defaultWorkingWeight ?? 0.0;

          for (var set in _exercises[i].sets) {
            final updatedSet = WorkoutSet(
              id: set.id,
              workoutExerciseId: set.workoutExerciseId,
              setNumber: set.setNumber,
              weight: newDefaultWeight, // Update to new exercise's default weight
              reps: set.reps,
              completed: set.completed,
              completedAt: set.completedAt,
              effortLevel: set.effortLevel,
              effortLevelSpecifier: set.effortLevelSpecifier,
              notes: set.notes,
            );
            await _setRepository.update(updatedSet);
            updatedSets.add(updatedSet);
          }

          // Update in memory
          _exercises[i] = ExerciseWithSets(
            exercise: updatedWorkoutExercise,
            sets: updatedSets,
            equipmentName: equipment?.name ?? 'Unknown',
            muscleGroupName: muscleGroup?.name ?? 'Unknown',
            isUsingMetric: newExercise.isUsingMetric,
          );

          notifyListeners();
          print('WorkoutDetailViewModel: Swapped exercise to ${newExercise.name} and updated ${updatedSets.length} sets with default weight $newDefaultWeight');
          break;
        }
      }
    } catch (e) {
      print('Error swapping exercise: $e');
    }
  }

  void markExerciseForDefaultWeightUpdate(int workoutExerciseId, int setId) {
    _exercisesMarkedForWeightUpdate[workoutExerciseId] = setId;
  }

  Future<void> completeWorkout() async {
    if (_session == null) return;

    try {
      // Update default weights for marked exercises before completing
      await _updateMarkedExerciseWeights();

      // Update session with end time
      final updatedSession = WorkoutSession(
        id: _session!.id,
        templateId: _session!.templateId,
        title: _session!.title,
        startTime: _session!.startTime,
        mesocycleId: _session!.mesocycleId,
        endTime: DateTime.now(),
        notes: _session!.notes,
        createdAt: _session!.createdAt,
      );

      await _sessionRepository.update(updatedSession);
      _session = updatedSession;
      _isEditable = false;
      notifyListeners();
    } catch (e) {
      _error = 'Error completing workout: $e';
    }
  }

  Future<void> _updateMarkedExerciseWeights() async {
    for (var entry in _exercisesMarkedForWeightUpdate.entries) {
      final workoutExerciseId = entry.key;
      final setId = entry.value;

      try {
        // Find the exercise in our list
        final exerciseData = _exercises.firstWhere(
          (e) => e.exercise.id == workoutExerciseId,
          orElse: () => throw Exception('Exercise not found'),
        );

        // Get the catalog exercise ID
        int? catalogExerciseId = exerciseData.exercise.exerciseId;

        if (catalogExerciseId == null) {
          // Try to find by exercise name in catalog
          final allExercises = await _exerciseCatalogRepository.getAll();
          final matchingExercise = allExercises.firstWhere(
            (e) => e.name == exerciseData.exercise.exerciseName,
            orElse: () => throw Exception('Exercise not found in catalog'),
          );
          catalogExerciseId = matchingExercise.id;
        }

        if (catalogExerciseId == null) continue;

        // Get the specific set's weight
        final markedSet = exerciseData.sets.firstWhere(
          (s) => s.id == setId,
          orElse: () => throw Exception('Set not found'),
        );

        final newDefaultWeight = markedSet.weight ?? 0.0;

        // Update the catalog exercise
        final catalogExercise = await _exerciseCatalogRepository.getById(catalogExerciseId);
        if (catalogExercise != null) {
          final updatedExercise = Exercise(
            id: catalogExercise.id,
            name: catalogExercise.name,
            exerciseTypeId: catalogExercise.exerciseTypeId,
            equipmentTypeId: catalogExercise.equipmentTypeId,
            muscleGroupId: catalogExercise.muscleGroupId,
            defaultWorkingWeight: newDefaultWeight,
            isUsingMetric: catalogExercise.isUsingMetric,
          );
          await _exerciseCatalogRepository.update(updatedExercise);

          // Also update all future uncompleted sessions with the same exercise
          await _updateFutureSessionWeights(exerciseData.exercise.exerciseName, newDefaultWeight);
        }
      } catch (e) {
        print('Error updating exercise weight: $e');
        // Silent fail - don't block workout completion
      }
    }

    // Clear the marked exercises
    _exercisesMarkedForWeightUpdate.clear();
  }

  Future<void> _updateFutureSessionWeights(String exerciseName, double newWeight) async {
    try {
      // Get all uncompleted sessions from the same mesocycle
      if (_session?.mesocycleId == null) return;

      // Get all sessions in this mesocycle
      final allSessions = await _sessionRepository.getSessionsByMesocycle(_session!.mesocycleId!);

      // Filter to only future/uncompleted sessions
      final futureSessions = allSessions.where((s) => s.endTime == null && s.id != _session!.id).toList();

      for (var session in futureSessions) {
        // Get exercises for this session
        final sessionExercises = await _exerciseRepository.getBySession(session.id!);

        // Find exercises matching the name
        for (var exercise in sessionExercises) {
          if (exercise.exerciseName == exerciseName) {
            // Get all sets for this exercise
            final sets = await _setRepository.getByWorkoutExercise(exercise.id!);

            // Update each set's weight
            for (var set in sets) {
              final updatedSet = WorkoutSet(
                id: set.id,
                workoutExerciseId: set.workoutExerciseId,
                setNumber: set.setNumber,
                weight: newWeight,
                reps: set.reps,
                completed: set.completed,
                completedAt: set.completedAt,
                effortLevel: set.effortLevel,
                effortLevelSpecifier: set.effortLevelSpecifier,
                notes: set.notes,
              );
              await _setRepository.update(updatedSet);
            }
          }
        }
      }
    } catch (e) {
      // Silent fail
    }
  }
}

