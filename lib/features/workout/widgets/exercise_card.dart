import 'package:flutter/material.dart';
import '../../../core/themes/app_colors.dart';
import '../view_models/workout_detail_view_model.dart';
import '../repositories/template_exercise_repository.dart';
import '../../exercise/repositories/exercise_repository.dart';
import 'exercise_set_item.dart';

class ExerciseCard extends StatefulWidget {
  final ExerciseWithSets exerciseData;
  final bool isEditable;
  final Function(int) onAddSet;
  final Function(int) onDeleteSet;
  final Function(dynamic) onSetUpdated;
  final Function(int, String) onExerciseNotesUpdated;
  final Function(int) onChangeExercise;
  final Function(int, int)? onUpdateDefaultWeight; // (workoutExerciseId, setId)

  const ExerciseCard({
    Key? key,
    required this.exerciseData,
    required this.isEditable,
    required this.onAddSet,
    required this.onDeleteSet,
    required this.onSetUpdated,
    required this.onExerciseNotesUpdated,
    required this.onChangeExercise,
    this.onUpdateDefaultWeight,
  }) : super(key: key);

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  bool _isNotesExpanded = false;

  Color _getMuscleGroupColor(String? muscleGroup) {
    // Color-coded based on muscle group
    switch (muscleGroup?.toLowerCase()) {
      case 'chest':
        return Colors.red;
      case 'back':
        return Colors.blue;
      case 'legs':
        return Colors.green;
      case 'shoulders':
        return Colors.orange;
      case 'arms':
        return Colors.purple;
      case 'core':
        return Colors.teal;
      default:
        return AppColors.primary;
    }
  }

  IconData _getMuscleGroupIcon(String? muscleGroup) {
    // Use the same icon for all muscle groups (arm flexing)
    return Icons.fitness_center;
  }

  @override
  Widget build(BuildContext context) {
    final muscleColor = _getMuscleGroupColor(widget.exerciseData.muscleGroupName);
    final muscleIcon = _getMuscleGroupIcon(widget.exerciseData.muscleGroupName);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exercise header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: muscleColor,
                  width: 4,
                ),
              ),
            ),
            child: Row(
              children: [
                // Muscle group icon with label
                Column(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: muscleColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        muscleIcon,
                        color: muscleColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.exerciseData.muscleGroupName ?? 'Unknown',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: muscleColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(width: 12),

                // Exercise info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.exerciseData.exercise.exerciseName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.exerciseData.equipmentName ?? 'Unknown',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Options menu
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  color: AppColors.textSecondary,
                  onPressed: () {
                    _showExerciseOptionsMenu(context);
                  },
                ),
              ],
            ),
          ),

          // Notes section (if exists)
          if (widget.exerciseData.exercise.notes != null && widget.exerciseData.exercise.notes!.isNotEmpty)
            InkWell(
              onTap: () {
                setState(() {
                  _isNotesExpanded = !_isNotesExpanded;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.yellow.withValues(alpha: 0.15),
                  border: Border(
                    top: BorderSide(color: AppColors.borderColor.withValues(alpha: 0.5)),
                    bottom: BorderSide(color: AppColors.borderColor.withValues(alpha: 0.5)),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.exerciseData.exercise.notes!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: _isNotesExpanded ? null : 2,
                        overflow: _isNotesExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                      ),
                    ),
                    if (widget.exerciseData.exercise.notes!.length > 50)
                      Icon(
                        _isNotesExpanded ? Icons.expand_less : Icons.expand_more,
                        color: Colors.orange,
                      ),
                  ],
                ),
              ),
            ),

          // Sets list
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sets',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),

                // Sets
                ...widget.exerciseData.sets.map((set) => ExerciseSetItem(
                  set: set,
                  isEditable: widget.isEditable,
                  isUsingMetric: widget.exerciseData.isUsingMetric,
                  onSetUpdated: widget.onSetUpdated,
                  onUpdateDefaultWeight: widget.onUpdateDefaultWeight,
                )),

                // Empty state
                if (widget.exerciseData.sets.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.borderColor,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'No sets logged yet',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),

                // Action buttons (only in edit mode)
                if (widget.isEditable) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => widget.onAddSet(widget.exerciseData.exercise.id!),
                          icon: const Icon(Icons.add),
                          label: const Text('Add Set'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      if (widget.exerciseData.sets.isNotEmpty) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => widget.onDeleteSet(widget.exerciseData.exercise.id!),
                            icon: const Icon(Icons.remove),
                            label: const Text('Delete Last'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.error,
                              side: const BorderSide(color: AppColors.error),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showExerciseOptionsMenu(BuildContext context) {
    final isPastSession = !widget.isEditable;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isPastSession) ...[
                ListTile(
                  leading: const Icon(Icons.note_add, color: AppColors.primary),
                  title: const Text('Add Exercise Notes'),
                  onTap: () {
                    Navigator.pop(context);
                    _showAddExerciseNotesDialog(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.swap_horiz, color: AppColors.primary),
                  title: const Text('Change Exercise'),
                  onTap: () {
                    Navigator.pop(context);
                    widget.onChangeExercise(widget.exerciseData.exercise.id!);
                  },
                ),
              ] else ...[
                // For past sessions, check if exercise was ACTUALLY swapped
                // Only show if we have both templateExerciseId AND exerciseId (means it was from template and might be swapped)
                // The swap is detected when the exercise was changed during workout
                if (widget.exerciseData.exercise.exerciseId != null &&
                    widget.exerciseData.exercise.templateExerciseId != null)
                  ListTile(
                    leading: const Icon(Icons.history, color: AppColors.primary),
                    title: const Text('See Original Planned Exercise'),
                    onTap: () {
                      Navigator.pop(context);
                      _showOriginalExerciseDialog(context);
                    },
                  ),
              ],
            ],
          ),
        );
      },
    );
  }

  void _showAddExerciseNotesDialog(BuildContext context) {
    final TextEditingController notesController = TextEditingController(
      text: widget.exerciseData.exercise.notes ?? '',
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exercise Notes'),
          content: TextField(
            controller: notesController,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Add notes about this exercise...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                widget.onExerciseNotesUpdated(
                  widget.exerciseData.exercise.id!,
                  notesController.text,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Exercise notes saved!'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showOriginalExerciseDialog(BuildContext context) async {
    // Check if exercise has the necessary data
    if (widget.exerciseData.exercise.exerciseId == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Original Exercise'),
            content: const Text(
              'This exercise was not swapped. It is the original planned exercise.',
              style: TextStyle(fontSize: 14),
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
      return;
    }

    // Fetch the original template exercise and its name
    String originalExerciseName = 'Unknown';

    try {
      final templateExerciseRepo = TemplateExerciseRepository();
      final exerciseRepo = ExerciseRepository();

      // Get the template exercise
      final templateExercise = await templateExerciseRepo.getById(
        widget.exerciseData.exercise.templateExerciseId!
      );

      if (templateExercise != null) {
        // Get the actual exercise name from catalog
        final exercise = await exerciseRepo.getById(templateExercise.exerciseId);
        if (exercise != null) {
          originalExerciseName = exercise.name;
        }
      }
    } catch (e) {
      print('Error fetching original exercise: $e');
    }

    if (!context.mounted) return;

    // Check if exercise was actually swapped (names differ)
    var wasSwapped = originalExerciseName != widget.exerciseData.exercise.exerciseName;

    // Show dialog with actual exercise name
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Original Planned Exercise'),
          content: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (wasSwapped)
                  Row(
                    children: [
                      const Icon(Icons.swap_horiz, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: const Text(
                          'This exercise was swapped during the workout',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (wasSwapped) const SizedBox(height: 16),
                if (wasSwapped) const SizedBox(height: 16),
                if (wasSwapped) ...[
                  const Text(
                    'Performed Exercise:',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.exerciseData.exercise.exerciseName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                Text(
                  wasSwapped ? 'Originally Planned:' : 'Planned Exercise:',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  originalExerciseName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (wasSwapped) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline, size: 16, color: Colors.blue),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Exercise was changed to better suit workout needs',
                            style: TextStyle(fontSize: 12, color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
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
}

