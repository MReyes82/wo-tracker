import 'package:flutter/foundation.dart';
import '../../workout/models/workout_session.dart';
import '../../workout/repositories/workout_session_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final WorkoutSessionRepository _sessionRepository = WorkoutSessionRepository();

  List<WorkoutSession> _recentWorkouts = [];
  WorkoutSession? _todayWorkout;
  bool _isLoading = false;
  String? _error;

  List<WorkoutSession> get recentWorkouts => _recentWorkouts;
  WorkoutSession? get todayWorkout => _todayWorkout;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadHomeData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Load recent workouts (last 5)
      final allSessions = await _sessionRepository.getAll();
      _recentWorkouts = allSessions.take(5).toList();

      // Check if there's a workout scheduled for today
      final today = DateTime.now();
      final todayStart = DateTime(today.year, today.month, today.day);
      final todayEnd = todayStart.add(const Duration(days: 1));

      if (allSessions.isNotEmpty) {
        try {
          _todayWorkout = allSessions.firstWhere(
            (session) =>
                session.startTime.isAfter(todayStart) &&
                session.startTime.isBefore(todayEnd),
          );
        } catch (e) {
          // No workout for today, that's okay
          _todayWorkout = null;
        }
      } else {
        _todayWorkout = null;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      // Log error but don't crash - show empty state instead
      _error = null; // Don't show error for empty database
      _recentWorkouts = [];
      _todayWorkout = null;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await loadHomeData();
  }
}

