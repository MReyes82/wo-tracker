import 'package:flutter/foundation.dart';
import '../../exercise/models/exercise.dart';
import '../../exercise/repositories/exercise_repository.dart';
import '../../workout/models/workout_template.dart';
import '../../workout/repositories/workout_template_repository.dart';
import '../../mesocycle/models/mesocycle.dart';
import '../../mesocycle/repositories/mesocycle_repository.dart';
import '../../workout/models/workout_session.dart';
import '../../workout/repositories/workout_session_repository.dart';

class RecordsViewModel extends ChangeNotifier {
  final ExerciseRepository _exerciseRepository = ExerciseRepository();
  final WorkoutTemplateRepository _workoutRepository = WorkoutTemplateRepository();
  final MesocycleRepository _mesocycleRepository = MesocycleRepository();
  final WorkoutSessionRepository _sessionRepository = WorkoutSessionRepository();

  List<Exercise> _exercises = [];
  List<WorkoutTemplate> _workouts = [];
  List<Mesocycle> _mesocycles = [];
  List<WorkoutSession> _sessions = [];

  bool _isLoading = false;
  String? _error;

  List<Exercise> get exercises => _exercises;
  List<WorkoutTemplate> get workouts => _workouts;
  List<Mesocycle> get mesocycles => _mesocycles;
  List<WorkoutSession> get sessions => _sessions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadExercises() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _exercises = await _exerciseRepository.getAll();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load exercises: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadWorkouts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _workouts = await _workoutRepository.getAll();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load workouts: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMesocycles() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _mesocycles = await _mesocycleRepository.getAll();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load mesocycles: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadSessions() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final allSessions = await _sessionRepository.getAll();
      // Filter to only show completed sessions
      _sessions = allSessions.where((session) => session.endTime != null).toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load sessions: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Exercise> filterExercises(String query) {
    if (query.isEmpty) return _exercises;
    return _exercises.where((e) => e.name.toLowerCase().contains(query)).toList();
  }

  List<WorkoutTemplate> filterWorkouts(String query) {
    if (query.isEmpty) return _workouts;
    return _workouts.where((w) => w.name.toLowerCase().contains(query)).toList();
  }

  List<Mesocycle> filterMesocycles(String query) {
    if (query.isEmpty) return _mesocycles;
    return _mesocycles.where((m) => m.name.toLowerCase().contains(query)).toList();
  }

  List<WorkoutSession> filterSessions(String query) {
    if (query.isEmpty) return _sessions;
    return _sessions.where((s) => (s.title?.toLowerCase() ?? '').contains(query)).toList();
  }
}

