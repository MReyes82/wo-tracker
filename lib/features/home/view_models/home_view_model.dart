import 'package:flutter/foundation.dart';
import '../../workout/models/workout_session.dart';
import '../../workout/repositories/workout_session_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final WorkoutSessionRepository _sessionRepository =
      WorkoutSessionRepository();

  List<WorkoutSession> _recentWorkouts = [];
  WorkoutSession? _todayWorkout;
  bool _isLoading = false;
  String? _error;
  int _totalCompletedWorkouts = 0;

  List<WorkoutSession> get recentWorkouts => _recentWorkouts;
  WorkoutSession? get todayWorkout => _todayWorkout;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get totalCompletedWorkouts => _totalCompletedWorkouts;

  Future<void> loadHomeData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Load all workouts
      final allSessions = await _sessionRepository.getAll();
      print('HomeViewModel: Loaded ${allSessions.length} sessions');

      // Sort by start_time ascending to find the first upcoming workout
      allSessions.sort((a, b) => a.startTime.compareTo(b.startTime));

      for (var session in allSessions) {
        print(
          '  - Session: id=${session.id}, title=${session.title}, startTime=${session.startTime}',
        );
      }

      final now = DateTime.now();

      // Find the first upcoming incomplete workout session (including today)
      if (allSessions.isNotEmpty) {
        try {
          _todayWorkout = allSessions.firstWhere((session) {
            // Must be incomplete
            if (session.endTime != null) return false;

            // Check if it's today
            final isToday =
                session.startTime.year == now.year &&
                session.startTime.month == now.month &&
                session.startTime.day == now.day;

            // Check if it's in the future
            final isFuture = session.startTime.isAfter(now);

            return isToday || isFuture;
          });
          print(
            'HomeViewModel: Found upcoming workout: ${_todayWorkout?.title} on ${_todayWorkout?.startTime}',
          );
        } catch (e) {
          // No upcoming workout, try to find the first incomplete workout from the past
          try {
            _todayWorkout = allSessions.firstWhere(
              (session) => session.endTime == null,
            );
            print(
              'HomeViewModel: Found incomplete workout from past: ${_todayWorkout?.title}',
            );
          } catch (e2) {
            // No incomplete workouts at all
            print('HomeViewModel: No incomplete workouts found');
            _todayWorkout = null;
          }
        }
      } else {
        _todayWorkout = null;
      }

      // Load recent workouts (exclude today's workout if found, and only show completed workouts)
      final completedWorkouts =
          allSessions
              .where(
                (session) =>
                    session.id !=
                        _todayWorkout?.id && // Exclude today's workout
                    session.endTime != null,
              ) // Only show completed workouts
              .toList()
            ..sort(
              (a, b) => b.startTime.compareTo(a.startTime),
            ); // Sort descending (newest first)

      // Store total count
      _totalCompletedWorkouts = completedWorkouts.length;

      // Take only the first 5 for display
      _recentWorkouts = completedWorkouts.take(5).toList();

      print(
        'HomeViewModel: ${_recentWorkouts.length} recent workouts (excluding today)',
      );

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
