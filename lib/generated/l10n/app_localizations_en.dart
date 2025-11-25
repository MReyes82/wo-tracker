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

  @override
  String get endDate => 'End Date';

  @override
  String session(int number) {
    return 'Session $number';
  }

  @override
  String get perWeek => 'Per Week';

  @override
  String get created => 'Created';

  @override
  String get usingDefaultWeight => 'Using default weight';

  @override
  String get sets => 'sets';

  @override
  String get mesocycleDetails => 'Mesocycle Details';

  @override
  String selectWorkoutForSession(int number) {
    return 'Please select a workout for Session $number';
  }

  @override
  String errorCreatingMesocycle(String error) {
    return 'Error creating mesocycle: $error';
  }

  @override
  String get enterMesocycleName => 'Enter mesocycle name';

  @override
  String get weeksLabel => 'Weeks:';

  @override
  String get sessionsPerWeekDesc => 'Number of workout sessions per week';

  @override
  String get chooseWorkoutTemplate => 'Choose workout template';

  @override
  String get amountOfTrainingWeeks => 'Amount of Training Weeks';

  @override
  String get selectSplit => 'Select Split (Sessions of the Week)';

  @override
  String errorLoadingExercise(String error) {
    return 'Error loading exercise: $error';
  }

  @override
  String errorUpdatingExercise(String error) {
    return 'Error updating exercise: $error';
  }

  @override
  String get enterExerciseName => 'Enter exercise name';

  @override
  String get selectExerciseType => 'Select exercise type';

  @override
  String get selectEquipmentType => 'Select equipment type';

  @override
  String get selectMuscleGroup => 'Select muscle group';

  @override
  String get defaultWorkingWeightOptional =>
      'Default Working Weight (Optional)';

  @override
  String get enterWeight => 'Enter weight';

  @override
  String errorCreatingExercise(String error) {
    return 'Error creating exercise: $error';
  }

  @override
  String errorLoadingWorkout(String error) {
    return 'Error loading workout: $error';
  }

  @override
  String errorUpdatingWorkout(String error) {
    return 'Error updating workout: $error';
  }

  @override
  String errorCreatingWorkout(String error) {
    return 'Error creating workout: $error';
  }

  @override
  String get enterWorkoutName => 'Enter workout name';

  @override
  String get selectWorkoutType => 'Select workout type';

  @override
  String get numberOfExercises => 'Number of Exercises';

  @override
  String get numberOfExercisesToPerform => 'Number of exercises to perform';

  @override
  String get chooseExercise => 'Choose exercise';

  @override
  String selectTheOrdinalExercise(String ordinal) {
    return 'Select the $ordinal exercise';
  }

  @override
  String pleaseSelectTheOrdinalExercise(String ordinal) {
    return 'Please select the $ordinal exercise';
  }

  @override
  String pleaseSelectSetsForTheOrdinalExercise(String ordinal) {
    return 'Please select sets for the $ordinal exercise';
  }

  @override
  String errorLoadingMesocycle(String error) {
    return 'Error loading mesocycle: $error';
  }

  @override
  String errorUpdatingMesocycle(String error) {
    return 'Error updating mesocycle: $error';
  }

  @override
  String get trainingWeeks => 'Training Weeks';

  @override
  String get durationOfMesocycleInWeeks => 'Duration of the mesocycle in weeks';

  @override
  String get workoutSchedule => 'Workout Schedule';

  @override
  String get chooseWorkout => 'Choose workout';

  @override
  String get defaultWeight => 'Default Weight';

  @override
  String get manageYourCatalogs => 'Manage your catalogs';

  @override
  String get exerciseTypes => 'Exercise Types';

  @override
  String get exerciseTypesDesc => 'Compound, Isolation, etc.';

  @override
  String get equipmentTypes => 'Equipment Types';

  @override
  String get equipmentTypesDesc => 'Barbell, Dumbbell, Machine, etc.';

  @override
  String get workoutTypes => 'Workout Types';

  @override
  String get workoutTypesDesc => 'Push, Pull, Legs, etc.';

  @override
  String get muscleGroupsDesc => 'Chest, Back, Legs, etc.';

  @override
  String addCatalog(String catalog) {
    return 'Add $catalog';
  }

  @override
  String get enterName => 'Enter name';

  @override
  String get pleaseEnterName => 'Please enter a name';

  @override
  String get add => 'Add';

  @override
  String catalogAddedSuccessfully(String catalog) {
    return '$catalog added successfully!';
  }

  @override
  String errorAddingCatalog(String catalog, String error) {
    return 'Error adding $catalog: $error';
  }

  @override
  String weeksCount(int count) {
    return '$count weeks';
  }

  @override
  String sessionsPerWeekCount(int count) {
    return '$count sessions/week';
  }

  @override
  String get workoutSplit => 'Workout Split';

  @override
  String get unknown => 'Unknown';

  @override
  String get noSetsLoggedYet => 'No sets logged yet';

  @override
  String get addSet => 'Add Set';

  @override
  String get deleteLast => 'Delete Last';

  @override
  String get addExerciseNotes => 'Add Exercise Notes';

  @override
  String get seeOriginalPlannedExercise => 'See Original Planned Exercise';

  @override
  String get exerciseNotes => 'Exercise Notes';

  @override
  String get addNotesAboutExercise => 'Add notes about this exercise...';

  @override
  String get exerciseNotesSaved => 'Exercise notes saved!';

  @override
  String get originalExercise => 'Original Exercise';

  @override
  String get exerciseNotSwapped =>
      'This exercise was not swapped. It is the original planned exercise.';

  @override
  String get originalPlannedExercise => 'Original Planned Exercise';

  @override
  String get exerciseSwappedDuringWorkout =>
      'This exercise was swapped during the workout';

  @override
  String get performedExercise => 'Performed Exercise:';

  @override
  String get originallyPlanned => 'Originally Planned:';

  @override
  String get plannedExercise => 'Planned Exercise:';

  @override
  String get exerciseChangedToSuitNeeds =>
      'Exercise was changed to better suit workout needs';
}
