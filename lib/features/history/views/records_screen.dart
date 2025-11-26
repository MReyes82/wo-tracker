import 'package:flutter/material.dart';
import 'package:wo_tracker/generated/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/themes/app_colors.dart';
import '../view_models/records_view_model.dart';
import '../../exercise/models/exercise.dart';
import '../../workout/models/workout_template.dart';
import '../../mesocycle/models/mesocycle.dart';
import '../../workout/models/workout_session.dart';
import '../../workout/views/workout_detail_screen.dart';
import '../../workout/views/workout_detail_screen.dart';
import '../../exercise/views/exercise_detail_screen.dart';
import '../../exercise/views/edit_exercise_screen.dart';
import '../../workout/views/workout_template_detail_screen.dart';
import '../../workout/views/edit_workout_screen.dart';
import '../../mesocycle/views/mesocycle_detail_screen.dart';
import '../../mesocycle/views/edit_mesocycle_screen.dart';

enum RecordType {
  exercises,
  workouts,
  mesocycles,
  sessions,
}

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({Key? key}) : super(key: key);

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  RecordType _selectedType = RecordType.exercises;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  late RecordsViewModel _viewModel;
  bool _isFirstBuild = true;

  @override
  void initState() {
    super.initState();
    _viewModel = RecordsViewModel();
    _loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload data when screen becomes visible again (but not on first build)
    if (!_isFirstBuild) {
      _loadData();
    }
    _isFirstBuild = false;
  }

  void _loadData() {
    switch (_selectedType) {
      case RecordType.exercises:
        _viewModel.loadExercises();
        break;
      case RecordType.workouts:
        _viewModel.loadWorkouts();
        break;
      case RecordType.mesocycles:
        _viewModel.loadMesocycles();
        break;
      case RecordType.sessions:
        _viewModel.loadSessions();
        break;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            l10n.recordsTitle,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: false,
        ),
        body: Column(
          children: [
            // Record type selector and search bar
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                children: [
                  // Record type dropdown button
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<RecordType>(
                        value: _selectedType,
                        icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary),
                        isExpanded: true,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        items: RecordType.values.map((RecordType type) {
                          return DropdownMenuItem<RecordType>(
                            value: type,
                            child: Row(
                              children: [
                                Icon(_getRecordTypeIcon(type), color: AppColors.primary, size: 20),
                                const SizedBox(width: 12),
                                Text(_getRecordTypeLabel(type)),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (RecordType? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedType = newValue;
                              _searchQuery = '';
                              _searchController.clear();
                            });
                            _loadData();
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Search bar
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: l10n.searchByName,
                      prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                      });
                    },
                  ),
                ],
              ),
            ),

            // Content area
            Expanded(
              child: Consumer<RecordsViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    );
                  }

                  if (viewModel.error != null) {
                    return Center(
                      child: Text(
                        viewModel.error!,
                        style: const TextStyle(color: AppColors.error),
                      ),
                    );
                  }

                  return _buildContent(viewModel);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getRecordTypeLabel(RecordType type) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case RecordType.exercises:
        return l10n.exercises;
      case RecordType.workouts:
        return l10n.workouts;
      case RecordType.mesocycles:
        return l10n.mesocycles;
      case RecordType.sessions:
        return l10n.sessions;
    }
  }

  IconData _getRecordTypeIcon(RecordType type) {
    switch (type) {
      case RecordType.exercises:
        return Icons.fitness_center;
      case RecordType.workouts:
        return Icons.view_list;
      case RecordType.mesocycles:
        return Icons.calendar_month;
      case RecordType.sessions:
        return Icons.history;
    }
  }

  Widget _buildContent(RecordsViewModel viewModel) {
    switch (_selectedType) {
      case RecordType.exercises:
        return _buildExercisesList(viewModel);
      case RecordType.workouts:
        return _buildWorkoutsList(viewModel);
      case RecordType.mesocycles:
        return _buildMesocyclesList(viewModel);
      case RecordType.sessions:
        return _buildSessionsList(viewModel);
    }
  }

  Widget _buildExercisesList(RecordsViewModel viewModel) {
    final l10n = AppLocalizations.of(context)!;
    final exercises = viewModel.filterExercises(_searchQuery);

    if (exercises.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.fitness_center,
              size: 64,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isEmpty ? l10n.noExercisesFound : l10n.noExercisesMatch,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        final exercise = exercises[index];
        return _buildExerciseCard(exercise);
      },
    );
  }

  Widget _buildExerciseCard(Exercise exercise) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.fitness_center,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  exercise.defaultWorkingWeight != null
                      ? '${exercise.defaultWorkingWeight} ${exercise.isUsingMetric ? "kg" : "lbs"}'
                      : l10n.noDefaultWeight,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () async {
              if (exercise.id != null) {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditExerciseScreen(
                      exerciseId: exercise.id!,
                    ),
                  ),
                );
                // Reload data if edit was successful
                if (result == true) {
                  _loadData();
                }
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
            ),
            child: Text(l10n.edit),
          ),
          TextButton(
            onPressed: () {
              if (exercise.id != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExerciseDetailScreen(
                      exerciseId: exercise.id!,
                    ),
                  ),
                );
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
            ),
            child: Text(l10n.details),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutsList(RecordsViewModel viewModel) {
    final l10n = AppLocalizations.of(context)!;
    final workouts = viewModel.filterWorkouts(_searchQuery);

    if (workouts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.view_list,
              size: 64,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isEmpty ? l10n.noWorkoutsFound : l10n.noWorkoutsMatch,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: workouts.length,
      itemBuilder: (context, index) {
        final workout = workouts[index];
        return _buildWorkoutCard(workout);
      },
    );
  }

  Widget _buildWorkoutCard(WorkoutTemplate workout) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.view_list,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workout.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Created ${DateFormat('MMM d, y').format(workout.createdAt ?? DateTime.now())}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () async {
              if (workout.id != null) {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditWorkoutScreen(
                      workoutId: workout.id!,
                    ),
                  ),
                );
                // Reload data if edit was successful
                if (result == true) {
                  _loadData();
                }
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
            ),
            child: Text(l10n.edit),
          ),
          TextButton(
            onPressed: () {
              if (workout.id != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkoutTemplateDetailScreen(
                      templateId: workout.id!,
                    ),
                  ),
                );
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
            ),
            child: Text(l10n.details),
          ),
        ],
      ),
    );
  }

  Widget _buildMesocyclesList(RecordsViewModel viewModel) {
    final l10n = AppLocalizations.of(context)!;
    final mesocycles = viewModel.filterMesocycles(_searchQuery);

    if (mesocycles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_month,
              size: 64,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isEmpty ? l10n.noMesocyclesFound : l10n.noMesocyclesMatch,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: mesocycles.length,
      itemBuilder: (context, index) {
        final mesocycle = mesocycles[index];
        return _buildMesocycleCard(mesocycle);
      },
    );
  }

  Widget _buildMesocycleCard(Mesocycle mesocycle) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.calendar_month,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mesocycle.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${l10n.weeksCount(mesocycle.weeksQuantity)}, ${l10n.sessionsPerWeekCount(mesocycle.sessionsPerWeek)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () async {
              if (mesocycle.id != null) {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditMesocycleScreen(
                      mesocycleId: mesocycle.id!,
                    ),
                  ),
                );
                // Reload data if edit was successful
                if (result == true) {
                  _loadData();
                }
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
            ),
            child: Text(l10n.edit),
          ),
          TextButton(
            onPressed: () {
              if (mesocycle.id != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MesocycleDetailScreen(
                      mesocycleId: mesocycle.id!,
                    ),
                  ),
                );
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
            ),
            child: Text(l10n.details),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionsList(RecordsViewModel viewModel) {
    final l10n = AppLocalizations.of(context)!;
    final sessions = viewModel.filterSessions(_searchQuery);

    if (sessions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isEmpty ? l10n.noSessionsFound : l10n.noSessionsMatch,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        return _buildSessionCard(session);
      },
    );
  }

  Widget _buildSessionCard(WorkoutSession session) {
    final l10n = AppLocalizations.of(context)!;
    final isCompleted = session.endTime != null;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCompleted ? AppColors.success.withValues(alpha: 0.3) : AppColors.divider,
          width: isCompleted ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppColors.success.withValues(alpha: 0.1)
                  : AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isCompleted ? Icons.check_circle : Icons.pending,
              color: isCompleted ? AppColors.success : AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.title ?? l10n.workoutSession,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  session.startTime != null
                      ? DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(session.startTime!)
                      : (session.endTime != null
                          ? DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(session.endTime!)
                          : l10n.notStarted),
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (isCompleted)
                  Text(
                    l10n.completed,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.success,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              if (session.id != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkoutDetailScreen(
                      sessionId: session.id!,
                      isEditable: false, // Past sessions are read-only
                    ),
                  ),
                );
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
            ),
            child: Text(l10n.details),
          ),
        ],
      ),
    );
  }
}

