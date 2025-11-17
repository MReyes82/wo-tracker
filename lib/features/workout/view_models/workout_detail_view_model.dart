import 'package:flutter/foundation.dart';
import '../models/workout_session.dart';
import '../models/workout_exercise.dart';
import '../models/workout_set.dart';
import '../repositories/workout_session_repository.dart';
import '../repositories/workout_exercise_repository.dart';
import '../repositories/workout_set_repository.dart';
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
  bool _isLoading = false;
  bool _isEditable = false;
  String? _error;

  WorkoutSession? get session => _session;
  List<ExerciseWithSets> get exercises => _exercises;
  bool get isLoading => _isLoading;
  bool get isEditable => _isEditable;
  String? get error => _error;

  Future<void> loadWorkoutDetails(int sessionId, {bool editable = false}) async {
    print('WorkoutDetailViewModel: Loading workout details for session $sessionId (editable: $editable)');
    _isLoading = true;
    _isEditable = editable;
    _error = null;
    notifyListeners();

    try {
      // Load workout session
      _session = await _sessionRepository.getById(sessionId);
      print('WorkoutDetailViewModel: Loaded session: ${_session?.toString()}');

      if (_session == null) {
        _error = 'Workout session not found';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Load exercises for this session
      final workoutExercises = await _exerciseRepository.getBySession(sessionId);
      print('WorkoutDetailViewModel: Loaded ${workoutExercises.length} exercises');

      // Load sets for each exercise
      _exercises = [];
      for (var exercise in workoutExercises) {
        final sets = await _setRepository.getByWorkoutExercise(exercise.id!);
        print('WorkoutDetailViewModel: Exercise ${exercise.exerciseName} has ${sets.length} sets');
        print('WorkoutDetailViewModel: Exercise ID in catalog: ${exercise.exerciseId}');

        // Fetch muscle group and equipment names if exercise_id is available
        String? muscleGroupName;
        String? equipmentName;
        bool isUsingMetric = true; // Default to metric

        if (exercise.exerciseId != null) {
          // Fetch the exercise details from catalog
          final exerciseDetails = await _exerciseCatalogRepository.getById(exercise.exerciseId!);
          print('WorkoutDetailViewModel: Exercise details from catalog: $exerciseDetails');

          if (exerciseDetails != null) {
            // Fetch muscle group name
            final muscleGroup = await _muscleGroupRepository.getById(exerciseDetails.muscleGroupId);
            muscleGroupName = muscleGroup?.name;
            print('WorkoutDetailViewModel: Muscle group: $muscleGroupName');

            // Fetch equipment type name
            final equipmentType = await _equipmentTypeRepository.getById(exerciseDetails.equipmentTypeId);
            equipmentName = equipmentType?.name;
            print('WorkoutDetailViewModel: Equipment type: $equipmentName');

            // Get unit preference
            isUsingMetric = exerciseDetails.isUsingMetric;
            print('WorkoutDetailViewModel: Unit preference: ${isUsingMetric ? "kg" : "lbs"}');
          }
        } else {
          print('WorkoutDetailViewModel: No exercise_id found for ${exercise.exerciseName}');
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
      print('WorkoutDetailViewModel: Error loading workout details: $e');
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

  Future<void> completeWorkout() async {
    if (_session == null) return;

    try {
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
      print('Error completing workout: $e');
    }
  }
}

