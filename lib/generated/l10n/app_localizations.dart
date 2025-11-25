import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'WoTracker'**
  String get appTitle;

  /// Navigation label for home tab
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// Navigation label for register tab
  ///
  /// In en, this message translates to:
  /// **'Register new'**
  String get navRegister;

  /// Navigation label for history tab
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// Navigation label for settings tab
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// Home screen title
  ///
  /// In en, this message translates to:
  /// **'My Workouts'**
  String get homeTitle;

  /// Section title for recent workouts
  ///
  /// In en, this message translates to:
  /// **'Recent Workouts'**
  String get recentWorkouts;

  /// Message shown when there are no recent workouts
  ///
  /// In en, this message translates to:
  /// **'No recent workouts'**
  String get noRecentWorkouts;

  /// Message shown when no workout is scheduled
  ///
  /// In en, this message translates to:
  /// **'No workout scheduled for today'**
  String get noWorkoutScheduled;

  /// Prompt to plan a workout
  ///
  /// In en, this message translates to:
  /// **'Plan your first workout'**
  String get planFirstWorkout;

  /// Button to start a workout
  ///
  /// In en, this message translates to:
  /// **'Start Workout'**
  String get startWorkout;

  /// Button to plan a workout
  ///
  /// In en, this message translates to:
  /// **'Plan a Workout'**
  String get planAWorkout;

  /// Label for today's workout section
  ///
  /// In en, this message translates to:
  /// **'Today\'s Workout'**
  String get todaysWorkout;

  /// Button to see more items
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// Button to view details
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// Edit button label
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Save button label
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Button to cancel action
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Button to delete an item
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Button to retry an action
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// OK button text
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Error label
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Records screen title
  ///
  /// In en, this message translates to:
  /// **'Records'**
  String get recordsTitle;

  /// Exercises label
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get exercises;

  /// Workouts label
  ///
  /// In en, this message translates to:
  /// **'Workouts'**
  String get workouts;

  /// Mesocycles label
  ///
  /// In en, this message translates to:
  /// **'Mesocycles'**
  String get mesocycles;

  /// Sessions label
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessions;

  /// Search field placeholder
  ///
  /// In en, this message translates to:
  /// **'Search by name...'**
  String get searchByName;

  /// Message when no exercises exist
  ///
  /// In en, this message translates to:
  /// **'No exercises found'**
  String get noExercisesFound;

  /// Message when search returns no exercises
  ///
  /// In en, this message translates to:
  /// **'No exercises match your search'**
  String get noExercisesMatch;

  /// Message when no workouts exist
  ///
  /// In en, this message translates to:
  /// **'No workouts found'**
  String get noWorkoutsFound;

  /// Message when search returns no workouts
  ///
  /// In en, this message translates to:
  /// **'No workouts match your search'**
  String get noWorkoutsMatch;

  /// Message when no mesocycles exist
  ///
  /// In en, this message translates to:
  /// **'No mesocycles found'**
  String get noMesocyclesFound;

  /// Message when search returns no mesocycles
  ///
  /// In en, this message translates to:
  /// **'No mesocycles match your search'**
  String get noMesocyclesMatch;

  /// Message when no sessions exist
  ///
  /// In en, this message translates to:
  /// **'No sessions found'**
  String get noSessionsFound;

  /// Message when search returns no sessions
  ///
  /// In en, this message translates to:
  /// **'No sessions match your search'**
  String get noSessionsMatch;

  /// Status label for completed items
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// Label when exercise has no default weight
  ///
  /// In en, this message translates to:
  /// **'No default weight'**
  String get noDefaultWeight;

  /// Register new screen title
  ///
  /// In en, this message translates to:
  /// **'Register New'**
  String get registerNewTitle;

  /// Prompt on register screen
  ///
  /// In en, this message translates to:
  /// **'What would you like to create?'**
  String get whatToCreate;

  /// Card title to add exercise
  ///
  /// In en, this message translates to:
  /// **'Add Exercise'**
  String get addExercise;

  /// Description for add exercise card
  ///
  /// In en, this message translates to:
  /// **'Create a new exercise for your catalog'**
  String get addExerciseDesc;

  /// Card title to add workout
  ///
  /// In en, this message translates to:
  /// **'Add Workout'**
  String get addWorkout;

  /// Description for add workout card
  ///
  /// In en, this message translates to:
  /// **'Build a workout with exercises'**
  String get addWorkoutDesc;

  /// Card title to add mesocycle
  ///
  /// In en, this message translates to:
  /// **'Add Mesocycle'**
  String get addMesocycle;

  /// Description for add mesocycle card
  ///
  /// In en, this message translates to:
  /// **'Plan a training cycle with multiple workouts'**
  String get addMesocycleDesc;

  /// Title for manage catalogs screen
  ///
  /// In en, this message translates to:
  /// **'Manage Catalogs'**
  String get manageCatalogs;

  /// Description for manage catalogs
  ///
  /// In en, this message translates to:
  /// **'Add exercise types, equipment, muscle groups, etc.'**
  String get manageCatalogsDesc;

  /// Settings screen title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Language setting label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Language selection prompt
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// English language name
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Spanish language name
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// Message when workout has no exercises
  ///
  /// In en, this message translates to:
  /// **'No exercises in this workout'**
  String get noExercisesInWorkout;

  /// Confirmation message for saved notes
  ///
  /// In en, this message translates to:
  /// **'Notes saved!'**
  String get notesSaved;

  /// Message when no exercises are available to select
  ///
  /// In en, this message translates to:
  /// **'No exercises available'**
  String get noExercisesAvailable;

  /// Dialog title when no more workouts exist
  ///
  /// In en, this message translates to:
  /// **'No More Workouts'**
  String get noMoreWorkoutsTitle;

  /// Message showing workout count
  ///
  /// In en, this message translates to:
  /// **'You have completed {count} workout{plural}. Keep training to see more history!'**
  String workoutCount(int count, String plural);

  /// Message when exercise has no sets
  ///
  /// In en, this message translates to:
  /// **'No sets logged yet'**
  String get noSetsLogged;

  /// Message when set has no notes
  ///
  /// In en, this message translates to:
  /// **'No notes for this set.'**
  String get noNotesForSet;

  /// Message when set has no effort level
  ///
  /// In en, this message translates to:
  /// **'No effort level recorded for this set.'**
  String get noEffortLevel;

  /// Message when mesocycle has no workouts
  ///
  /// In en, this message translates to:
  /// **'No workouts in this mesocycle'**
  String get noWorkoutsInMesocycle;

  /// Exercise details screen title
  ///
  /// In en, this message translates to:
  /// **'Exercise Details'**
  String get exerciseDetails;

  /// Label for default working weight
  ///
  /// In en, this message translates to:
  /// **'Default Working Weight'**
  String get defaultWorkingWeight;

  /// Label for unit system
  ///
  /// In en, this message translates to:
  /// **'Unit System'**
  String get unitSystem;

  /// Metric unit system label
  ///
  /// In en, this message translates to:
  /// **'Metric (kg)'**
  String get metricKg;

  /// Imperial unit system label
  ///
  /// In en, this message translates to:
  /// **'Imperial (lbs)'**
  String get imperialLbs;

  /// Label when value is not set
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// Default title for workout session
  ///
  /// In en, this message translates to:
  /// **'Workout Session'**
  String get workoutSession;

  /// Weeks label
  ///
  /// In en, this message translates to:
  /// **'weeks'**
  String get weeks;

  /// Sessions per week label
  ///
  /// In en, this message translates to:
  /// **'sessions/week'**
  String get sessionsPerWeek;

  /// Created date label
  ///
  /// In en, this message translates to:
  /// **'Created {date}'**
  String createdOn(String date);

  /// Workout details screen title
  ///
  /// In en, this message translates to:
  /// **'Workout Details'**
  String get workoutDetails;

  /// Message when workout is marked complete
  ///
  /// In en, this message translates to:
  /// **'Workout completed!'**
  String get workoutCompleted;

  /// Error message when workout doesn't exist
  ///
  /// In en, this message translates to:
  /// **'Workout not found'**
  String get workoutNotFound;

  /// Label for active workout session
  ///
  /// In en, this message translates to:
  /// **'ACTIVE WORKOUT'**
  String get activeWorkout;

  /// Label for workout notes section
  ///
  /// In en, this message translates to:
  /// **'Workout Notes'**
  String get workoutNotes;

  /// Button to add workout notes
  ///
  /// In en, this message translates to:
  /// **'Add Workout Notes'**
  String get addWorkoutNotes;

  /// Placeholder for notes input field
  ///
  /// In en, this message translates to:
  /// **'Add notes about your workout...'**
  String get addNotesPlaceholder;

  /// Button to mark workout start time
  ///
  /// In en, this message translates to:
  /// **'Mark Start Time'**
  String get markStartTime;

  /// Button to view workout start time
  ///
  /// In en, this message translates to:
  /// **'See Start Time'**
  String get seeStartTime;

  /// Confirmation message for marking start time
  ///
  /// In en, this message translates to:
  /// **'Set the workout start time to now?'**
  String get setStartTimeNow;

  /// Button to mark current time
  ///
  /// In en, this message translates to:
  /// **'Mark Now'**
  String get markNow;

  /// Confirmation that start time was saved
  ///
  /// In en, this message translates to:
  /// **'Start time marked!'**
  String get startTimeMarked;

  /// Dialog title for start time
  ///
  /// In en, this message translates to:
  /// **'Workout Start Time'**
  String get workoutStartTime;

  /// Label showing when workout started
  ///
  /// In en, this message translates to:
  /// **'This workout started at:'**
  String get workoutStartedAt;

  /// Close button label
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Menu option to swap exercise
  ///
  /// In en, this message translates to:
  /// **'Change Exercise'**
  String get changeExercise;

  /// Confirmation message for exercise swap
  ///
  /// In en, this message translates to:
  /// **'Exercise changed to {name}'**
  String exerciseChangedTo(String name);

  /// Label for default value
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultLabel;

  /// Title for new exercise screen
  ///
  /// In en, this message translates to:
  /// **'New Exercise'**
  String get newExercise;

  /// Title for edit exercise screen
  ///
  /// In en, this message translates to:
  /// **'Edit Exercise'**
  String get editExercise;

  /// Label for exercise name field
  ///
  /// In en, this message translates to:
  /// **'Exercise Name'**
  String get exerciseName;

  /// Label for exercise type field
  ///
  /// In en, this message translates to:
  /// **'Exercise Type'**
  String get exerciseType;

  /// Label for equipment field
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get equipment;

  /// Label for muscle groups field
  ///
  /// In en, this message translates to:
  /// **'Muscle Groups'**
  String get muscleGroups;

  /// Button to save exercise
  ///
  /// In en, this message translates to:
  /// **'Save Exercise'**
  String get saveExercise;

  /// Confirmation that exercise was saved
  ///
  /// In en, this message translates to:
  /// **'Exercise saved!'**
  String get exerciseSaved;

  /// Title for new workout screen
  ///
  /// In en, this message translates to:
  /// **'New Workout'**
  String get newWorkout;

  /// Title for edit workout screen
  ///
  /// In en, this message translates to:
  /// **'Edit Workout'**
  String get editWorkout;

  /// Label for workout name field
  ///
  /// In en, this message translates to:
  /// **'Workout Name'**
  String get workoutName;

  /// Label for workout type field
  ///
  /// In en, this message translates to:
  /// **'Workout Type'**
  String get workoutType;

  /// Button to select exercises
  ///
  /// In en, this message translates to:
  /// **'Select Exercises'**
  String get selectExercises;

  /// Button to save workout
  ///
  /// In en, this message translates to:
  /// **'Save Workout'**
  String get saveWorkout;

  /// Confirmation that workout was saved
  ///
  /// In en, this message translates to:
  /// **'Workout saved!'**
  String get workoutSaved;

  /// Title for new mesocycle screen
  ///
  /// In en, this message translates to:
  /// **'New Mesocycle'**
  String get newMesocycle;

  /// Title for edit mesocycle screen
  ///
  /// In en, this message translates to:
  /// **'Edit Mesocycle'**
  String get editMesocycle;

  /// Label for mesocycle name field
  ///
  /// In en, this message translates to:
  /// **'Mesocycle Name'**
  String get mesocycleName;

  /// Label for duration field
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// Label for start date field
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// Button to select workouts
  ///
  /// In en, this message translates to:
  /// **'Select Workouts'**
  String get selectWorkouts;

  /// Button to save mesocycle
  ///
  /// In en, this message translates to:
  /// **'Save Mesocycle'**
  String get saveMesocycle;

  /// Confirmation that mesocycle was saved
  ///
  /// In en, this message translates to:
  /// **'Mesocycle saved!'**
  String get mesocycleSaved;

  /// Label for required fields
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// Label for optional fields
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// Validation message for empty required field
  ///
  /// In en, this message translates to:
  /// **'Please enter {field}'**
  String pleaseEnter(String field);

  /// Validation message for unselected required field
  ///
  /// In en, this message translates to:
  /// **'Please select {field}'**
  String pleaseSelect(String field);

  /// Label for end date field
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// Session label with number
  ///
  /// In en, this message translates to:
  /// **'Session {number}'**
  String session(int number);

  /// Label for per week
  ///
  /// In en, this message translates to:
  /// **'Per Week'**
  String get perWeek;

  /// Created label
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// Label for using default weight
  ///
  /// In en, this message translates to:
  /// **'Using default weight'**
  String get usingDefaultWeight;

  /// Sets label
  ///
  /// In en, this message translates to:
  /// **'sets'**
  String get sets;

  /// Mesocycle details screen title
  ///
  /// In en, this message translates to:
  /// **'Mesocycle Details'**
  String get mesocycleDetails;

  /// Error message when workout is not selected for a session
  ///
  /// In en, this message translates to:
  /// **'Please select a workout for Session {number}'**
  String selectWorkoutForSession(int number);

  /// Error message for mesocycle creation failure
  ///
  /// In en, this message translates to:
  /// **'Error creating mesocycle: {error}'**
  String errorCreatingMesocycle(String error);

  /// Hint text for mesocycle name field
  ///
  /// In en, this message translates to:
  /// **'Enter mesocycle name'**
  String get enterMesocycleName;

  /// Label for weeks count
  ///
  /// In en, this message translates to:
  /// **'Weeks:'**
  String get weeksLabel;

  /// Description for sessions per week slider
  ///
  /// In en, this message translates to:
  /// **'Number of workout sessions per week'**
  String get sessionsPerWeekDesc;

  /// Hint text for workout template dropdown
  ///
  /// In en, this message translates to:
  /// **'Choose workout template'**
  String get chooseWorkoutTemplate;

  /// Section title for training weeks
  ///
  /// In en, this message translates to:
  /// **'Amount of Training Weeks'**
  String get amountOfTrainingWeeks;

  /// Section title for workout split selection
  ///
  /// In en, this message translates to:
  /// **'Select Split (Sessions of the Week)'**
  String get selectSplit;

  /// Error message for loading exercise failure
  ///
  /// In en, this message translates to:
  /// **'Error loading exercise: {error}'**
  String errorLoadingExercise(String error);

  /// Error message for updating exercise failure
  ///
  /// In en, this message translates to:
  /// **'Error updating exercise: {error}'**
  String errorUpdatingExercise(String error);

  /// Hint text for exercise name field
  ///
  /// In en, this message translates to:
  /// **'Enter exercise name'**
  String get enterExerciseName;

  /// Hint text for exercise type dropdown
  ///
  /// In en, this message translates to:
  /// **'Select exercise type'**
  String get selectExerciseType;

  /// Hint text for equipment type dropdown
  ///
  /// In en, this message translates to:
  /// **'Select equipment type'**
  String get selectEquipmentType;

  /// Hint text for muscle group dropdown
  ///
  /// In en, this message translates to:
  /// **'Select muscle group'**
  String get selectMuscleGroup;

  /// Label for default working weight field (optional)
  ///
  /// In en, this message translates to:
  /// **'Default Working Weight (Optional)'**
  String get defaultWorkingWeightOptional;

  /// Hint text for weight field
  ///
  /// In en, this message translates to:
  /// **'Enter weight'**
  String get enterWeight;

  /// Error message for creating exercise failure
  ///
  /// In en, this message translates to:
  /// **'Error creating exercise: {error}'**
  String errorCreatingExercise(String error);

  /// Error message for loading workout failure
  ///
  /// In en, this message translates to:
  /// **'Error loading workout: {error}'**
  String errorLoadingWorkout(String error);

  /// Error message for updating workout failure
  ///
  /// In en, this message translates to:
  /// **'Error updating workout: {error}'**
  String errorUpdatingWorkout(String error);

  /// Error message for creating workout failure
  ///
  /// In en, this message translates to:
  /// **'Error creating workout: {error}'**
  String errorCreatingWorkout(String error);

  /// Hint text for workout name field
  ///
  /// In en, this message translates to:
  /// **'Enter workout name'**
  String get enterWorkoutName;

  /// Hint text for workout type dropdown
  ///
  /// In en, this message translates to:
  /// **'Select workout type'**
  String get selectWorkoutType;

  /// Section title for number of exercises
  ///
  /// In en, this message translates to:
  /// **'Number of Exercises'**
  String get numberOfExercises;

  /// Description for number of exercises slider
  ///
  /// In en, this message translates to:
  /// **'Number of exercises to perform'**
  String get numberOfExercisesToPerform;

  /// Hint text for exercise dropdown
  ///
  /// In en, this message translates to:
  /// **'Choose exercise'**
  String get chooseExercise;

  /// Prompt to select exercise with ordinal number
  ///
  /// In en, this message translates to:
  /// **'Select the {ordinal} exercise'**
  String selectTheOrdinalExercise(String ordinal);

  /// Error message for unselected exercise with ordinal
  ///
  /// In en, this message translates to:
  /// **'Please select the {ordinal} exercise'**
  String pleaseSelectTheOrdinalExercise(String ordinal);

  /// Error message for unselected sets with ordinal
  ///
  /// In en, this message translates to:
  /// **'Please select sets for the {ordinal} exercise'**
  String pleaseSelectSetsForTheOrdinalExercise(String ordinal);

  /// Error message for loading mesocycle failure
  ///
  /// In en, this message translates to:
  /// **'Error loading mesocycle: {error}'**
  String errorLoadingMesocycle(String error);

  /// Error message for updating mesocycle failure
  ///
  /// In en, this message translates to:
  /// **'Error updating mesocycle: {error}'**
  String errorUpdatingMesocycle(String error);

  /// Label for training weeks
  ///
  /// In en, this message translates to:
  /// **'Training Weeks'**
  String get trainingWeeks;

  /// Description for mesocycle duration slider
  ///
  /// In en, this message translates to:
  /// **'Duration of the mesocycle in weeks'**
  String get durationOfMesocycleInWeeks;

  /// Section title for workout schedule
  ///
  /// In en, this message translates to:
  /// **'Workout Schedule'**
  String get workoutSchedule;

  /// Hint text for workout dropdown
  ///
  /// In en, this message translates to:
  /// **'Choose workout'**
  String get chooseWorkout;

  /// Label for default weight
  ///
  /// In en, this message translates to:
  /// **'Default Weight'**
  String get defaultWeight;

  /// Description for manage catalogs screen
  ///
  /// In en, this message translates to:
  /// **'Manage your catalogs'**
  String get manageYourCatalogs;

  /// Label for exercise types catalog
  ///
  /// In en, this message translates to:
  /// **'Exercise Types'**
  String get exerciseTypes;

  /// Description for exercise types
  ///
  /// In en, this message translates to:
  /// **'Compound, Isolation, etc.'**
  String get exerciseTypesDesc;

  /// Label for equipment types catalog
  ///
  /// In en, this message translates to:
  /// **'Equipment Types'**
  String get equipmentTypes;

  /// Description for equipment types
  ///
  /// In en, this message translates to:
  /// **'Barbell, Dumbbell, Machine, etc.'**
  String get equipmentTypesDesc;

  /// Label for workout types catalog
  ///
  /// In en, this message translates to:
  /// **'Workout Types'**
  String get workoutTypes;

  /// Description for workout types
  ///
  /// In en, this message translates to:
  /// **'Push, Pull, Legs, etc.'**
  String get workoutTypesDesc;

  /// Description for muscle groups
  ///
  /// In en, this message translates to:
  /// **'Chest, Back, Legs, etc.'**
  String get muscleGroupsDesc;

  /// Title for add catalog dialog
  ///
  /// In en, this message translates to:
  /// **'Add {catalog}'**
  String addCatalog(String catalog);

  /// Hint text for name field
  ///
  /// In en, this message translates to:
  /// **'Enter name'**
  String get enterName;

  /// Validation message for empty name field
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get pleaseEnterName;

  /// Add button label
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// Success message for adding catalog
  ///
  /// In en, this message translates to:
  /// **'{catalog} added successfully!'**
  String catalogAddedSuccessfully(String catalog);

  /// Error message for adding catalog failure
  ///
  /// In en, this message translates to:
  /// **'Error adding {catalog}: {error}'**
  String errorAddingCatalog(String catalog, String error);

  /// Weeks count label
  ///
  /// In en, this message translates to:
  /// **'{count} weeks'**
  String weeksCount(int count);

  /// Sessions per week count label
  ///
  /// In en, this message translates to:
  /// **'{count} sessions/week'**
  String sessionsPerWeekCount(int count);

  /// Label for workout split section
  ///
  /// In en, this message translates to:
  /// **'Workout Split'**
  String get workoutSplit;

  /// Label for unknown values
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// Empty state message for sets
  ///
  /// In en, this message translates to:
  /// **'No sets logged yet'**
  String get noSetsLoggedYet;

  /// Button to add a new set
  ///
  /// In en, this message translates to:
  /// **'Add Set'**
  String get addSet;

  /// Button to delete last set
  ///
  /// In en, this message translates to:
  /// **'Delete Last'**
  String get deleteLast;

  /// Menu option to add notes to exercise
  ///
  /// In en, this message translates to:
  /// **'Add Exercise Notes'**
  String get addExerciseNotes;

  /// Menu option to view original planned exercise
  ///
  /// In en, this message translates to:
  /// **'See Original Planned Exercise'**
  String get seeOriginalPlannedExercise;

  /// Dialog title for exercise notes
  ///
  /// In en, this message translates to:
  /// **'Exercise Notes'**
  String get exerciseNotes;

  /// Hint text for exercise notes field
  ///
  /// In en, this message translates to:
  /// **'Add notes about this exercise...'**
  String get addNotesAboutExercise;

  /// Success message for saving exercise notes
  ///
  /// In en, this message translates to:
  /// **'Exercise notes saved!'**
  String get exerciseNotesSaved;

  /// Dialog title for original exercise
  ///
  /// In en, this message translates to:
  /// **'Original Exercise'**
  String get originalExercise;

  /// Message when exercise was not changed
  ///
  /// In en, this message translates to:
  /// **'This exercise was not swapped. It is the original planned exercise.'**
  String get exerciseNotSwapped;

  /// Dialog title for original planned exercise
  ///
  /// In en, this message translates to:
  /// **'Original Planned Exercise'**
  String get originalPlannedExercise;

  /// Message when exercise was changed during workout
  ///
  /// In en, this message translates to:
  /// **'This exercise was swapped during the workout'**
  String get exerciseSwappedDuringWorkout;

  /// Label for performed exercise
  ///
  /// In en, this message translates to:
  /// **'Performed Exercise:'**
  String get performedExercise;

  /// Label for originally planned exercise
  ///
  /// In en, this message translates to:
  /// **'Originally Planned:'**
  String get originallyPlanned;

  /// Label for planned exercise
  ///
  /// In en, this message translates to:
  /// **'Planned Exercise:'**
  String get plannedExercise;

  /// Info message about exercise swap
  ///
  /// In en, this message translates to:
  /// **'Exercise was changed to better suit workout needs'**
  String get exerciseChangedToSuitNeeds;

  /// Label for reps field
  ///
  /// In en, this message translates to:
  /// **'Reps'**
  String get reps;

  /// Label for weight field with unit
  ///
  /// In en, this message translates to:
  /// **'Weight ({unit})'**
  String weightWithUnit(String unit);

  /// Menu option to add notes to set
  ///
  /// In en, this message translates to:
  /// **'Add Set Notes'**
  String get addSetNotes;

  /// Menu option to view set notes
  ///
  /// In en, this message translates to:
  /// **'See Set Notes'**
  String get seeSetNotes;

  /// Menu option to add effort level
  ///
  /// In en, this message translates to:
  /// **'Add Effort Level'**
  String get addEffortLevel;

  /// Menu option to view effort level
  ///
  /// In en, this message translates to:
  /// **'See Effort Level'**
  String get seeEffortLevel;

  /// Menu option to update default weight
  ///
  /// In en, this message translates to:
  /// **'Update Exercise Default Weight'**
  String get updateExerciseDefaultWeight;

  /// Dialog title for set notes
  ///
  /// In en, this message translates to:
  /// **'Set Notes'**
  String get setNotes;

  /// Message when set has no notes
  ///
  /// In en, this message translates to:
  /// **'No notes for this set.'**
  String get noNotesForThisSet;

  /// Hint for set notes field
  ///
  /// In en, this message translates to:
  /// **'Add notes about this set...'**
  String get addNotesAboutSet;

  /// Success message for set notes
  ///
  /// In en, this message translates to:
  /// **'Set notes saved!'**
  String get setNotesSaved;

  /// Label for effort level
  ///
  /// In en, this message translates to:
  /// **'Effort Level'**
  String get effortLevel;

  /// Label for effort unit selection
  ///
  /// In en, this message translates to:
  /// **'Effort Unit:'**
  String get effortUnit;

  /// Label for effort value slider
  ///
  /// In en, this message translates to:
  /// **'Effort Value:'**
  String get effortValue;

  /// Label for closeness specifier
  ///
  /// In en, this message translates to:
  /// **'Closeness Specifier (optional):'**
  String get closenessSpecifier;

  /// Label for effort preview
  ///
  /// In en, this message translates to:
  /// **'Effort:'**
  String get effort;

  /// Success message for effort level
  ///
  /// In en, this message translates to:
  /// **'Effort level saved!'**
  String get effortLevelSaved;

  /// Message when set has no effort level
  ///
  /// In en, this message translates to:
  /// **'No effort level recorded for this set.'**
  String get noEffortLevelRecorded;

  /// Dialog title for updating default weight
  ///
  /// In en, this message translates to:
  /// **'Update Default Weight'**
  String get updateDefaultWeight;

  /// Explanation for marking set weight
  ///
  /// In en, this message translates to:
  /// **'Mark this set\'s weight to update the exercise default weight when the workout is completed.'**
  String get markSetWeightMessage;

  /// Label for current weight display
  ///
  /// In en, this message translates to:
  /// **'Current Weight:'**
  String get currentWeight;

  /// Success message for marking weight update
  ///
  /// In en, this message translates to:
  /// **'Will update default weight on workout completion!'**
  String get willUpdateDefaultWeight;

  /// Button to mark weight for update
  ///
  /// In en, this message translates to:
  /// **'Mark for Update'**
  String get markForUpdate;

  /// Ordinal suffix for 1st, 21st, 31st, etc.
  ///
  /// In en, this message translates to:
  /// **'{number}st'**
  String ordinalSt(int number);

  /// Ordinal suffix for 2nd, 22nd, 32nd, etc.
  ///
  /// In en, this message translates to:
  /// **'{number}nd'**
  String ordinalNd(int number);

  /// Ordinal suffix for 3rd, 23rd, 33rd, etc.
  ///
  /// In en, this message translates to:
  /// **'{number}rd'**
  String ordinalRd(int number);

  /// Ordinal suffix for 4th, 5th, 10th, 11th, 12th, 13th, etc.
  ///
  /// In en, this message translates to:
  /// **'{number}th'**
  String ordinalTh(int number);

  /// Label for unit system field
  ///
  /// In en, this message translates to:
  /// **'Unit System'**
  String get unitSystemLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
