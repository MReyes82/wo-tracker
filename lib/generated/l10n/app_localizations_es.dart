// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'WoTracker';

  @override
  String get navHome => 'Inicio';

  @override
  String get navRegister => 'Registrar nuevo';

  @override
  String get navHistory => 'Historial';

  @override
  String get navSettings => 'Ajustes';

  @override
  String get homeTitle => 'Mis Entrenamientos';

  @override
  String get recentWorkouts => 'Entrenamientos Recientes';

  @override
  String get noRecentWorkouts => 'No hay entrenamientos recientes';

  @override
  String get noWorkoutScheduled => 'No hay entrenamiento programado para hoy';

  @override
  String get planFirstWorkout => 'Planifica tu primer entrenamiento';

  @override
  String get startWorkout => 'Iniciar Entrenamiento';

  @override
  String get planAWorkout => 'Planificar Entrenamiento';

  @override
  String get todaysWorkout => 'Entrenamiento de Hoy';

  @override
  String get more => 'Más';

  @override
  String get details => 'Detalles';

  @override
  String get edit => 'Editar';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get retry => 'Reintentar';

  @override
  String get ok => 'OK';

  @override
  String get error => 'Error';

  @override
  String get recordsTitle => 'Registros';

  @override
  String get exercises => 'Ejercicios';

  @override
  String get workouts => 'Entrenamientos';

  @override
  String get mesocycles => 'Mesociclos';

  @override
  String get sessions => 'Sesiones';

  @override
  String get searchByName => 'Buscar por nombre...';

  @override
  String get noExercisesFound => 'No se encontraron ejercicios';

  @override
  String get noExercisesMatch =>
      'No hay ejercicios que coincidan con tu búsqueda';

  @override
  String get noWorkoutsFound => 'No se encontraron entrenamientos';

  @override
  String get noWorkoutsMatch =>
      'No hay entrenamientos que coincidan con tu búsqueda';

  @override
  String get noMesocyclesFound => 'No se encontraron mesociclos';

  @override
  String get noMesocyclesMatch =>
      'No hay mesociclos que coincidan con tu búsqueda';

  @override
  String get noSessionsFound => 'No se encontraron sesiones';

  @override
  String get noSessionsMatch => 'No hay sesiones que coincidan con tu búsqueda';

  @override
  String get completed => 'Completado';

  @override
  String get noDefaultWeight => 'Sin peso predeterminado';

  @override
  String get registerNewTitle => 'Registrar Nuevo';

  @override
  String get whatToCreate => '¿Qué te gustaría crear?';

  @override
  String get addExercise => 'Agregar Ejercicio';

  @override
  String get addExerciseDesc => 'Crea un nuevo ejercicio para tu catálogo';

  @override
  String get addWorkout => 'Agregar Entrenamiento';

  @override
  String get addWorkoutDesc => 'Construye un entrenamiento con ejercicios';

  @override
  String get addMesocycle => 'Agregar Mesociclo';

  @override
  String get addMesocycleDesc =>
      'Planifica un ciclo de entrenamiento con múltiples entrenamientos';

  @override
  String get manageCatalogs => 'Administrar Catálogos';

  @override
  String get manageCatalogsDesc =>
      'Agregar tipos de ejercicio, equipamiento, grupos musculares, etc.';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get language => 'Idioma';

  @override
  String get selectLanguage => 'Seleccionar Idioma';

  @override
  String get english => 'Inglés';

  @override
  String get spanish => 'Español';

  @override
  String get noExercisesInWorkout => 'No hay ejercicios en este entrenamiento';

  @override
  String get notesSaved => '¡Notas guardadas!';

  @override
  String get noExercisesAvailable => 'No hay ejercicios disponibles';

  @override
  String get noMoreWorkoutsTitle => 'No Hay Más Entrenamientos';

  @override
  String workoutCount(int count, String plural) {
    return 'Has completado $count entrenamiento$plural. ¡Sigue entrenando para ver más historial!';
  }

  @override
  String get noSetsLogged => 'No se han registrado series aún';

  @override
  String get noNotesForSet => 'No hay notas para esta serie.';

  @override
  String get noEffortLevel =>
      'No se registró nivel de esfuerzo para esta serie.';

  @override
  String get noWorkoutsInMesocycle => 'No hay entrenamientos en este mesociclo';

  @override
  String get exerciseDetails => 'Detalles del Ejercicio';

  @override
  String get defaultWorkingWeight => 'Peso de Trabajo Predeterminado';

  @override
  String get unitSystem => 'Sistema de Unidades';

  @override
  String get metricKg => 'Métrico (kg)';

  @override
  String get imperialLbs => 'Imperial (lbs)';

  @override
  String get notSet => 'No establecido';

  @override
  String get workoutSession => 'Sesión de Entrenamiento';

  @override
  String get weeks => 'semanas';

  @override
  String get sessionsPerWeek => 'sesiones/semana';

  @override
  String createdOn(String date) {
    return 'Creado el $date';
  }

  @override
  String get workoutDetails => 'Detalles del Entrenamiento';

  @override
  String get workoutCompleted => '¡Entrenamiento completado!';

  @override
  String get workoutNotFound => 'Entrenamiento no encontrado';

  @override
  String get activeWorkout => 'ENTRENAMIENTO ACTIVO';

  @override
  String get workoutNotes => 'Notas del Entrenamiento';

  @override
  String get addWorkoutNotes => 'Agregar Notas del Entrenamiento';

  @override
  String get addNotesPlaceholder => 'Agregar notas sobre tu entrenamiento...';

  @override
  String get markStartTime => 'Marcar Hora de Inicio';

  @override
  String get seeStartTime => 'Ver Hora de Inicio';

  @override
  String get setStartTimeNow =>
      '¿Establecer la hora de inicio del entrenamiento ahora?';

  @override
  String get markNow => 'Marcar Ahora';

  @override
  String get startTimeMarked => '¡Hora de inicio marcada!';

  @override
  String get workoutStartTime => 'Hora de Inicio del Entrenamiento';

  @override
  String get workoutStartedAt => 'Este entrenamiento comenzó a las:';

  @override
  String get close => 'Cerrar';

  @override
  String get changeExercise => 'Cambiar Ejercicio';

  @override
  String exerciseChangedTo(String name) {
    return 'Ejercicio cambiado a $name';
  }

  @override
  String get defaultLabel => 'Predeterminado';

  @override
  String get newExercise => 'Nuevo Ejercicio';

  @override
  String get editExercise => 'Editar Ejercicio';

  @override
  String get exerciseName => 'Nombre del Ejercicio';

  @override
  String get exerciseType => 'Tipo de Ejercicio';

  @override
  String get equipment => 'Equipamiento';

  @override
  String get muscleGroups => 'Grupos Musculares';

  @override
  String get saveExercise => 'Guardar Ejercicio';

  @override
  String get exerciseSaved => '¡Ejercicio guardado!';

  @override
  String get newWorkout => 'Nuevo Entrenamiento';

  @override
  String get editWorkout => 'Editar Entrenamiento';

  @override
  String get workoutName => 'Nombre del Entrenamiento';

  @override
  String get workoutType => 'Tipo de Entrenamiento';

  @override
  String get selectExercises => 'Seleccionar Ejercicios';

  @override
  String get saveWorkout => 'Guardar Entrenamiento';

  @override
  String get workoutSaved => '¡Entrenamiento guardado!';

  @override
  String get newMesocycle => 'Nuevo Mesociclo';

  @override
  String get editMesocycle => 'Editar Mesociclo';

  @override
  String get mesocycleName => 'Nombre del Mesociclo';

  @override
  String get duration => 'Duración';

  @override
  String get startDate => 'Fecha de Inicio';

  @override
  String get selectWorkouts => 'Seleccionar Entrenamientos';

  @override
  String get saveMesocycle => 'Guardar Mesociclo';

  @override
  String get mesocycleSaved => '¡Mesociclo guardado!';

  @override
  String get required => 'Requerido';

  @override
  String get optional => 'Opcional';

  @override
  String pleaseEnter(String field) {
    return 'Por favor ingrese $field';
  }

  @override
  String pleaseSelect(String field) {
    return 'Por favor seleccione $field';
  }

  @override
  String get endDate => 'Fecha de Fin';

  @override
  String session(int number) {
    return 'Sesión $number';
  }

  @override
  String get perWeek => 'Por Semana';

  @override
  String get created => 'Creado';

  @override
  String get usingDefaultWeight => 'Usando peso predeterminado';

  @override
  String get sets => 'series';

  @override
  String get mesocycleDetails => 'Detalles del Mesociclo';

  @override
  String selectWorkoutForSession(int number) {
    return 'Por favor seleccione una rutina para la Sesión $number';
  }

  @override
  String errorCreatingMesocycle(String error) {
    return 'Error al crear mesociclo: $error';
  }

  @override
  String get enterMesocycleName => 'Ingrese nombre del mesociclo';

  @override
  String get weeksLabel => 'Semanas:';

  @override
  String get sessionsPerWeekDesc =>
      'Número de sesiones de entrenamiento por semana';

  @override
  String get chooseWorkoutTemplate => 'Elija plantilla de rutina';

  @override
  String get amountOfTrainingWeeks => 'Cantidad de Semanas de Entrenamiento';

  @override
  String get selectSplit => 'Seleccionar División (Sesiones de la Semana)';

  @override
  String errorLoadingExercise(String error) {
    return 'Error al cargar ejercicio: $error';
  }

  @override
  String errorUpdatingExercise(String error) {
    return 'Error al actualizar ejercicio: $error';
  }

  @override
  String get enterExerciseName => 'Ingrese nombre del ejercicio';

  @override
  String get selectExerciseType => 'Seleccione tipo de ejercicio';

  @override
  String get selectEquipmentType => 'Seleccione tipo de equipamiento';

  @override
  String get selectMuscleGroup => 'Seleccione grupo muscular';

  @override
  String get defaultWorkingWeightOptional =>
      'Peso de Trabajo Predeterminado (Opcional)';

  @override
  String get enterWeight => 'Ingrese peso';

  @override
  String errorCreatingExercise(String error) {
    return 'Error al crear ejercicio: $error';
  }

  @override
  String errorLoadingWorkout(String error) {
    return 'Error al cargar rutina: $error';
  }

  @override
  String errorUpdatingWorkout(String error) {
    return 'Error al actualizar rutina: $error';
  }

  @override
  String errorCreatingWorkout(String error) {
    return 'Error al crear rutina: $error';
  }

  @override
  String get enterWorkoutName => 'Ingrese nombre de la rutina';

  @override
  String get selectWorkoutType => 'Seleccione tipo de rutina';

  @override
  String get numberOfExercises => 'Número de Ejercicios';

  @override
  String get numberOfExercisesToPerform => 'Número de ejercicios a realizar';

  @override
  String get chooseExercise => 'Elija ejercicio';

  @override
  String selectTheOrdinalExercise(String ordinal) {
    return 'Seleccione el $ordinal ejercicio';
  }

  @override
  String pleaseSelectTheOrdinalExercise(String ordinal) {
    return 'Por favor seleccione el $ordinal ejercicio';
  }

  @override
  String pleaseSelectSetsForTheOrdinalExercise(String ordinal) {
    return 'Por favor seleccione series para el $ordinal ejercicio';
  }

  @override
  String errorLoadingMesocycle(String error) {
    return 'Error al cargar mesociclo: $error';
  }

  @override
  String errorUpdatingMesocycle(String error) {
    return 'Error al actualizar mesociclo: $error';
  }

  @override
  String get trainingWeeks => 'Semanas de Entrenamiento';

  @override
  String get durationOfMesocycleInWeeks => 'Duración del mesociclo en semanas';

  @override
  String get workoutSchedule => 'Horario de Entrenamiento';

  @override
  String get chooseWorkout => 'Elija rutina';

  @override
  String get defaultWeight => 'Peso Predeterminado';

  @override
  String get manageYourCatalogs => 'Administre sus catálogos';

  @override
  String get exerciseTypes => 'Tipos de Ejercicio';

  @override
  String get exerciseTypesDesc => 'Compuesto, Aislamiento, etc.';

  @override
  String get equipmentTypes => 'Tipos de Equipamiento';

  @override
  String get equipmentTypesDesc => 'Barra, Mancuerna, Máquina, etc.';

  @override
  String get workoutTypes => 'Tipos de Rutina';

  @override
  String get workoutTypesDesc => 'Empuje, Jalón, Piernas, etc.';

  @override
  String get muscleGroupsDesc => 'Pecho, Espalda, Piernas, etc.';

  @override
  String addCatalog(String catalog) {
    return 'Agregar $catalog';
  }

  @override
  String get enterName => 'Ingrese nombre';

  @override
  String get pleaseEnterName => 'Por favor ingrese un nombre';

  @override
  String get add => 'Agregar';

  @override
  String catalogAddedSuccessfully(String catalog) {
    return '$catalog agregado exitosamente!';
  }

  @override
  String errorAddingCatalog(String catalog, String error) {
    return 'Error al agregar $catalog: $error';
  }

  @override
  String weeksCount(int count) {
    return '$count semanas';
  }

  @override
  String sessionsPerWeekCount(int count) {
    return '$count sesiones/semana';
  }

  @override
  String get workoutSplit => 'División de Entrenamiento';

  @override
  String get unknown => 'Desconocido';

  @override
  String get noSetsLoggedYet => 'Aún no se han registrado series';

  @override
  String get addSet => 'Agregar Serie';

  @override
  String get deleteLast => 'Eliminar Última';

  @override
  String get addExerciseNotes => 'Agregar Notas de Ejercicio';

  @override
  String get seeOriginalPlannedExercise => 'Ver Ejercicio Planeado Original';

  @override
  String get exerciseNotes => 'Notas de Ejercicio';

  @override
  String get addNotesAboutExercise => 'Agregar notas sobre este ejercicio...';

  @override
  String get exerciseNotesSaved => '¡Notas de ejercicio guardadas!';

  @override
  String get originalExercise => 'Ejercicio Original';

  @override
  String get exerciseNotSwapped =>
      'Este ejercicio no fue cambiado. Es el ejercicio planeado original.';

  @override
  String get originalPlannedExercise => 'Ejercicio Planeado Original';

  @override
  String get exerciseSwappedDuringWorkout =>
      'Este ejercicio fue cambiado durante el entrenamiento';

  @override
  String get performedExercise => 'Ejercicio Realizado:';

  @override
  String get originallyPlanned => 'Planeado Originalmente:';

  @override
  String get plannedExercise => 'Ejercicio Planeado:';

  @override
  String get exerciseChangedToSuitNeeds =>
      'Ejercicio cambiado para ajustarse mejor a las necesidades del entrenamiento';
}
