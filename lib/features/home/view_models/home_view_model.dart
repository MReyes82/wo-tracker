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
      // Load all workouts
      final allSessions = await _sessionRepository.getAll();
      print('HomeViewModel: Loaded ${allSessions.length} sessions');
      for (var session in allSessions) {
        print('  - Session: id=${session.id}, title=${session.title}, startTime=${session.startTime}');
      }

      // Check if there's a workout scheduled for today
      final today = DateTime.now();
      final todayStart = DateTime(today.year, today.month, today.day);
      final todayEnd = todayStart.add(const Duration(days: 1));

      print('HomeViewModel: Looking for today\'s workout between $todayStart and $todayEnd');

      if (allSessions.isNotEmpty) {
        try {
          _todayWorkout = allSessions.firstWhere(
            (session) =>
                session.startTime.isAfter(todayStart) &&
                session.startTime.isBefore(todayEnd) &&
                session.endTime == null, // Only show incomplete workouts as today's workout
          );
          print('HomeViewModel: Found today\'s workout: ${_todayWorkout?.title}');
        } catch (e) {
          // No workout for today, that's okay
          print('HomeViewModel: No workout for today');
          _todayWorkout = null;
        }
      } else {
        _todayWorkout = null;
      }

      // Load recent workouts (exclude today's workout if found, and only show completed workouts)
      _recentWorkouts = allSessions
          .where((session) =>
              session.id != _todayWorkout?.id && // Exclude today's workout
              session.endTime != null) // Only show completed workouts
          .take(5)
          .toList();
      print('HomeViewModel: ${_recentWorkouts.length} recent workouts (excluding today)');

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      // Log error but don't crash - show empty state instead
      print('HomeViewModel: Error loading home data: $e');
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

