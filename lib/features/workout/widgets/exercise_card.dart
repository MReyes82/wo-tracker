import 'package:flutter/material.dart';
import '../../../core/themes/app_colors.dart';
import '../view_models/workout_detail_view_model.dart';
import 'exercise_set_item.dart';

class ExerciseCard extends StatelessWidget {
  final ExerciseWithSets exerciseData;
  final bool isEditable;
  final Function(int) onAddSet;
  final Function(int) onDeleteSet;
  final Function(dynamic) onSetUpdated;

  const ExerciseCard({
    Key? key,
    required this.exerciseData,
    required this.isEditable,
    required this.onAddSet,
    required this.onDeleteSet,
    required this.onSetUpdated,
  }) : super(key: key);

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
    // Icon based on muscle group
    switch (muscleGroup?.toLowerCase()) {
      case 'chest':
        return Icons.sports_gymnastics;
      case 'back':
        return Icons.accessibility_new;
      case 'legs':
        return Icons.directions_run;
      case 'shoulders':
        return Icons.sports_martial_arts;
      case 'arms':
        return Icons.sports_kabaddi;
      case 'core':
        return Icons.self_improvement;
      default:
        return Icons.fitness_center;
    }
  }

  @override
  Widget build(BuildContext context) {
    final muscleColor = _getMuscleGroupColor(exerciseData.muscleGroupName);
    final muscleIcon = _getMuscleGroupIcon(exerciseData.muscleGroupName);

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
                // Muscle group icon
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
                const SizedBox(width: 12),

                // Exercise info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exerciseData.exercise.exerciseName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        exerciseData.equipmentName ?? 'Unknown equipment',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Options menu
                if (isEditable)
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    color: AppColors.textSecondary,
                    onPressed: () {
                      // TODO: Show options menu
                    },
                  ),
              ],
            ),
          ),

          // Notes section (if exists)
          if (exerciseData.exercise.notes != null && exerciseData.exercise.notes!.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.05),
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
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      exerciseData.exercise.notes!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
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
                ...exerciseData.sets.map((set) => ExerciseSetItem(
                  set: set,
                  isEditable: isEditable,
                  onSetUpdated: onSetUpdated,
                )),

                // Empty state
                if (exerciseData.sets.isEmpty)
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
                if (isEditable) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => onAddSet(exerciseData.exercise.id!),
                          icon: const Icon(Icons.add),
                          label: const Text('Add Set'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      if (exerciseData.sets.isNotEmpty) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => onDeleteSet(exerciseData.exercise.id!),
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
}

