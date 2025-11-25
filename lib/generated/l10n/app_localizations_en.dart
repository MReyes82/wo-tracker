// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'WoTracker';

  @override
  String get navHome => 'Home';

  @override
  String get navRegister => 'Register new';

  @override
  String get navHistory => 'History';

  @override
  String get navSettings => 'Settings';

  @override
  String get homeTitle => 'My Workouts';

  @override
  String get recentWorkouts => 'Recent Workouts';

  @override
  String get noRecentWorkouts => 'No recent workouts';

  @override
  String get noWorkoutScheduled => 'No workout scheduled for today';

  @override
  String get planFirstWorkout => 'Plan your first workout';

  @override
  String get startWorkout => 'Start Workout';

  @override
  String get planAWorkout => 'Plan a Workout';

  @override
  String get todaysWorkout => 'Today\'s Workout';

  @override
  String get more => 'More';

  @override
  String get details => 'Details';

  @override
  String get edit => 'Edit';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get retry => 'Retry';

  @override
  String get ok => 'OK';

  @override
  String get error => 'Error';

  @override
  String get recordsTitle => 'Records';

  @override
  String get exercises => 'Exercises';

  @override
  String get workouts => 'Workouts';

  @override
  String get mesocycles => 'Mesocycles';

  @override
  String get sessions => 'Sessions';

  @override
  String get searchByName => 'Search by name...';

  @override
  String get noExercisesFound => 'No exercises found';

  @override
  String get noExercisesMatch => 'No exercises match your search';

  @override
  String get noWorkoutsFound => 'No workouts found';

  @override
  String get noWorkoutsMatch => 'No workouts match your search';

  @override
  String get noMesocyclesFound => 'No mesocycles found';

  @override
  String get noMesocyclesMatch => 'No mesocycles match your search';

  @override
  String get noSessionsFound => 'No sessions found';

  @override
  String get noSessionsMatch => 'No sessions match your search';

  @override
  String get completed => 'Completed';

  @override
  String get noDefaultWeight => 'No default weight';

  @override
  String get registerNewTitle => 'Register New';

  @override
  String get whatToCreate => 'What would you like to create?';

  @override
  String get addExercise => 'Add Exercise';

  @override
  String get addExerciseDesc => 'Create a new exercise for your catalog';

  @override
  String get addWorkout => 'Add Workout';

  @override
  String get addWorkoutDesc => 'Build a workout with exercises';

  @override
  String get addMesocycle => 'Add Mesocycle';

  @override
  String get addMesocycleDesc => 'Plan a training cycle with multiple workouts';

  @override
  String get manageCatalogs => 'Manage Catalogs';

  @override
  String get manageCatalogsDesc =>
      'Add exercise types, equipment, muscle groups, etc.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get english => 'English';

  @override
  String get spanish => 'Spanish';

  @override
  String get noExercisesInWorkout => 'No exercises in this workout';

  @override
  String get notesSaved => 'Notes saved!';

  @override
  String get noExercisesAvailable => 'No exercises available';

  @override
  String get noMoreWorkoutsTitle => 'No More Workouts';

  @override
  String workoutCount(int count, String plural) {
    return 'You have completed $count workout$plural. Keep training to see more history!';
  }

  @override
  String get noSetsLogged => 'No sets logged yet';

  @override
  String get noNotesForSet => 'No notes for this set.';

  @override
  String get noEffortLevel => 'No effort level recorded for this set.';

  @override
  String get noWorkoutsInMesocycle => 'No workouts in this mesocycle';

  @override
  String get exerciseDetails => 'Exercise Details';

  @override
  String get defaultWorkingWeight => 'Default Working Weight';

  @override
  String get unitSystem => 'Unit System';

  @override
  String get metricKg => 'Metric (kg)';

  @override
  String get imperialLbs => 'Imperial (lbs)';

  @override
  String get notSet => 'Not set';

  @override
  String get workoutSession => 'Workout Session';

  @override
  String get weeks => 'weeks';

  @override
  String get sessionsPerWeek => 'sessions/week';

  @override
  String createdOn(String date) {
    return 'Created $date';
  }

  @override
  String get workoutDetails => 'Workout Details';

  @override
  String get workoutCompleted => 'Workout completed!';

  @override
  String get workoutNotFound => 'Workout not found';

  @override
  String get activeWorkout => 'ACTIVE WORKOUT';

  @override
  String get workoutNotes => 'Workout Notes';

  @override
  String get addWorkoutNotes => 'Add Workout Notes';

  @override
  String get addNotesPlaceholder => 'Add notes about your workout...';

  @override
  String get markStartTime => 'Mark Start Time';

  @override
  String get seeStartTime => 'See Start Time';

  @override
  String get setStartTimeNow => 'Set the workout start time to now?';

  @override
  String get markNow => 'Mark Now';

  @override
  String get startTimeMarked => 'Start time marked!';

  @override
  String get workoutStartTime => 'Workout Start Time';

  @override
  String get workoutStartedAt => 'This workout started at:';

  @override
  String get close => 'Close';

  @override
  String get changeExercise => 'Change Exercise';

  @override
  String exerciseChangedTo(String name) {
    return 'Exercise changed to $name';
  }

  @override
  String get defaultLabel => 'Default';

  @override
  String get newExercise => 'New Exercise';

  @override
  String get editExercise => 'Edit Exercise';

  @override
  String get exerciseName => 'Exercise Name';

  @override
  String get exerciseType => 'Exercise Type';

  @override
  String get equipment => 'Equipment';

  @override
  String get muscleGroups => 'Muscle Groups';

  @override
  String get saveExercise => 'Save Exercise';

  @override
  String get exerciseSaved => 'Exercise saved!';

  @override
  String get newWorkout => 'New Workout';

  @override
  String get editWorkout => 'Edit Workout';

  @override
  String get workoutName => 'Workout Name';

  @override
  String get workoutType => 'Workout Type';

  @override
  String get selectExercises => 'Select Exercises';

  @override
  String get saveWorkout => 'Save Workout';

  @override
  String get workoutSaved => 'Workout saved!';

  @override
  String get newMesocycle => 'New Mesocycle';

  @override
  String get editMesocycle => 'Edit Mesocycle';

  @override
  String get mesocycleName => 'Mesocycle Name';

  @override
  String get duration => 'Duration';

  @override
  String get startDate => 'Start Date';

  @override
  String get selectWorkouts => 'Select Workouts';

  @override
  String get saveMesocycle => 'Save Mesocycle';

  @override
  String get mesocycleSaved => 'Mesocycle saved!';

  @override
  String get required => 'Required';

  @override
  String get optional => 'Optional';

  @override
  String pleaseEnter(String field) {
    return 'Please enter $field';
  }

  @override
  String pleaseSelect(String field) {
    return 'Please select $field';
  }
}
