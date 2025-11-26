import 'package:flutter/foundation.dart';
import '../../workout/models/workout_session.dart';
import '../../workout/repositories/workout_session_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final WorkoutSessionRepository _sessionRepository = WorkoutSessionRepository();

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

      // Sort by week_number and session_order for mesocycle sessions, and by startTime for others
      allSessions.sort((a, b) {
        // Completed sessions go to the end
        if (a.endTime != null && b.endTime == null) return 1;
        if (a.endTime == null && b.endTime != null) return -1;

        // Unstarted sessions (null startTime) come first, sorted by week/order
        if (a.startTime == null && b.startTime != null) return -1;
        if (a.startTime != null && b.startTime == null) return 1;

        // Both have startTime null - sort by week_number and session_order
        if (a.startTime == null && b.startTime == null) {
          if (a.weekNumber != null && b.weekNumber != null) {
            final weekCompare = a.weekNumber!.compareTo(b.weekNumber!);
            if (weekCompare != 0) return weekCompare;
            if (a.sessionOrder != null && b.sessionOrder != null) {
              return a.sessionOrder!.compareTo(b.sessionOrder!);
            }
          }
          return 0;
        }

        // Both have startTime - sort by startTime
        return a.startTime!.compareTo(b.startTime!);
      });

      for (var session in allSessions) {
        print('  - Session: id=${session.id}, title=${session.title}, startTime=${session.startTime}, week=${session.weekNumber}, order=${session.sessionOrder}, endTime=${session.endTime}');
      }

      // Find the current workout:
      // Priority 1: First incomplete session with null startTime (not yet started)
      // Priority 2: First incomplete session with startTime (already started)
      if (allSessions.isNotEmpty) {
        try {
          _todayWorkout = allSessions.firstWhere(
            (session) => session.endTime == null, // Must be incomplete
          );
          print('HomeViewModel: Found current workout: ${_todayWorkout?.title} (startTime: ${_todayWorkout?.startTime})');
        } catch (e) {
          // No incomplete workouts at all
          print('HomeViewModel: No incomplete workouts found');
          _todayWorkout = null;
        }
      } else {
        _todayWorkout = null;
      }

      // Load recent workouts (exclude today's workout if found, and only show completed workouts)
      final completedWorkouts = allSessions
          .where((session) =>
              session.id != _todayWorkout?.id && // Exclude today's workout
              session.endTime != null) // Only show completed workouts
          .toList()
          ..sort((a, b) {
            // For completed workouts, sort by endTime if available, otherwise by startTime
            final aTime = a.endTime ?? a.startTime;
            final bTime = b.endTime ?? b.startTime;
            if (aTime == null && bTime == null) return 0;
            if (aTime == null) return 1;
            if (bTime == null) return -1;
            return bTime.compareTo(aTime); // Sort descending (newest first)
          });

      // Store total count
      _totalCompletedWorkouts = completedWorkouts.length;

      // Take only the first 5 for display
      _recentWorkouts = completedWorkouts.take(5).toList();

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

