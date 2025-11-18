import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/themes/app_colors.dart';
import '../view_models/workout_detail_view_model.dart';
import '../widgets/exercise_card.dart';
import 'package:intl/intl.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final int sessionId;
  final bool isEditable;

  const WorkoutDetailScreen({
    Key? key,
    required this.sessionId,
    this.isEditable = false,
  }) : super(key: key);

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  late WorkoutDetailViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = WorkoutDetailViewModel();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.loadWorkoutDetails(
        widget.sessionId,
        editable: widget.isEditable,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Consumer<WorkoutDetailViewModel>(
            builder: (context, viewModel, child) {
              return Text(
                viewModel.session?.title ?? 'Workout Details',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              );
            },
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            if (widget.isEditable)
              Consumer<WorkoutDetailViewModel>(
                builder: (context, viewModel, child) {
                  return IconButton(
                    icon: const Icon(Icons.check, color: AppColors.success),
                    onPressed: () async {
                      await viewModel.completeWorkout();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Workout completed!'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                  );
                },
              ),
          ],
        ),
        body: Consumer<WorkoutDetailViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (viewModel.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      viewModel.error!,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => viewModel.loadWorkoutDetails(
                        widget.sessionId,
                        editable: widget.isEditable,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (viewModel.session == null) {
              return const Center(
                child: Text(
                  'Workout not found',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              );
            }

            return Column(
              children: [
                // Workout info header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.borderColor,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              DateFormat(
                                'EEEE, MMMM d, yyyy',
                              ).format(viewModel.session!.startTime),
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.more_vert),
                            iconSize: 20,
                            color: AppColors.textSecondary,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              _showWorkoutOptionsMenu(context, viewModel);
                            },
                          ),
                        ],
                      ),
                      if (viewModel.session!.endTime != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _formatDuration(
                                viewModel.session!.endTime!.difference(
                                  viewModel.session!.startTime,
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (widget.isEditable) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'ACTIVE WORKOUT',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Workout Notes Section
                if (viewModel.session!.notes != null &&
                    viewModel.session!.notes!.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFF9C4), // Light yellow background
                      border: Border(
                        bottom: BorderSide(
                          color: AppColors.borderColor,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.note,
                              size: 16,
                              color: Color(0xFFF57F17), // Dark yellow/amber
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Workout Notes',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFF57F17),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          viewModel.session!.notes!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Exercises list
                Expanded(
                  child: viewModel.exercises.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.fitness_center,
                                size: 64,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'No exercises in this workout',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              if (widget.isEditable) ...[
                                const SizedBox(height: 24),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    // TODO: Navigate to add exercise screen
                                  },
                                  icon: const Icon(Icons.add),
                                  label: const Text('Add Exercise'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: viewModel.exercises.length,
                          itemBuilder: (context, index) {
                            final exerciseData = viewModel.exercises[index];
                            return ExerciseCard(
                              exerciseData: exerciseData,
                              isEditable: viewModel.isEditable,
                              onAddSet: (exerciseId) =>
                                  viewModel.addSet(exerciseId),
                              onDeleteSet: (exerciseId) =>
                                  viewModel.deleteLastSet(exerciseId),
                              onSetUpdated: (updatedSet) =>
                                  viewModel.updateSet(updatedSet),
                              onExerciseNotesUpdated: (exerciseId, notes) =>
                                  viewModel.updateExerciseNotes(
                                    exerciseId,
                                    notes,
                                  ),
                              onChangeExercise: (exerciseId) =>
                                  _showChangeExerciseDialog(
                                    context,
                                    viewModel,
                                    exerciseId,
                                  ),
                              onUpdateDefaultWeight: (exerciseId, setId) =>
                                  viewModel.markExerciseForDefaultWeightUpdate(
                                    exerciseId,
                                    setId,
                                  ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  void _showWorkoutOptionsMenu(
    BuildContext context,
    WorkoutDetailViewModel viewModel,
  ) {
    final isPastSession = viewModel.session?.endTime != null;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isPastSession)
                ListTile(
                  leading: const Icon(Icons.note_add, color: AppColors.primary),
                  title: const Text('Add Workout Notes'),
                  onTap: () {
                    Navigator.pop(context);
                    _showAddNotesDialog(context, viewModel);
                  },
                ),
              ListTile(
                leading: const Icon(
                  Icons.access_time,
                  color: AppColors.primary,
                ),
                title: Text(
                  isPastSession ? 'See Start Time' : 'Mark Start Time',
                ),
                onTap: () {
                  Navigator.pop(context);
                  if (isPastSession) {
                    _showSeeStartTimeDialog(context, viewModel);
                  } else {
                    _showMarkStartTimeDialog(context, viewModel);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddNotesDialog(
    BuildContext context,
    WorkoutDetailViewModel viewModel,
  ) {
    final TextEditingController notesController = TextEditingController(
      text: viewModel.session?.notes ?? '',
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Workout Notes'),
          content: TextField(
            controller: notesController,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Add notes about your workout...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await viewModel.updateNotes(notesController.text);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Notes saved!'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showMarkStartTimeDialog(
    BuildContext context,
    WorkoutDetailViewModel viewModel,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Mark Start Time'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Set the workout start time to now?',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('h:mm a').format(DateTime.now()),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await viewModel.markStartTime();
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Start time marked!'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              },
              child: const Text('Mark Now'),
            ),
          ],
        );
      },
    );
  }

  void _showSeeStartTimeDialog(
    BuildContext context,
    WorkoutDetailViewModel viewModel,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Workout Start Time'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'This workout started at:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat(
                            'EEEE, MMMM d, yyyy',
                          ).format(viewModel.session!.startTime),
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          DateFormat(
                            'h:mm a',
                          ).format(viewModel.session!.startTime),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showChangeExerciseDialog(
    BuildContext context,
    WorkoutDetailViewModel viewModel,
    int exerciseId,
  ) async {
    // Load available exercises from catalog
    await viewModel.loadAvailableExercises();

    if (!context.mounted) return;

    final availableExercises = viewModel.availableExercises;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Exercise'),
          content: SizedBox(
            width: double.maxFinite,
            child: availableExercises.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text('No exercises available'),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: availableExercises.length,
                    itemBuilder: (context, index) {
                      final exercise = availableExercises[index];
                      return ListTile(
                        leading: const Icon(
                          Icons.fitness_center,
                          color: AppColors.primary,
                        ),
                        title: Text(exercise.name),
                        subtitle: Text(
                          'Default: ${exercise.defaultWorkingWeight ?? "Not set"} ${exercise.isUsingMetric ? "kg" : "lbs"}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        onTap: () async {
                          Navigator.pop(context);
                          await viewModel.swapExercise(
                            exerciseId,
                            exercise.id!,
                          );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Exercise changed to ${exercise.name}',
                                ),
                                backgroundColor: AppColors.success,
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
