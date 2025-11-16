import 'package:flutter/material.dart';
import '../../../core/themes/app_colors.dart';
import '../models/workout_set.dart';

class ExerciseSetItem extends StatelessWidget {
  final WorkoutSet set;
  final bool isEditable;
  final Function(WorkoutSet) onSetUpdated;

  const ExerciseSetItem({
    Key? key,
    required this.set,
    required this.isEditable,
    required this.onSetUpdated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: set.completed ? AppColors.primary : AppColors.divider,
          width: set.completed ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          // Set number
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: set.completed ? AppColors.primary : AppColors.cardBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                '${set.setNumber}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: set.completed ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Reps input
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Reps',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                isEditable
                    ? TextFormField(
                        initialValue: set.reps?.toString() ?? '',
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 16),
                        decoration: const InputDecoration(
                          hintText: '0',
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          final reps = int.tryParse(value);
                          onSetUpdated(WorkoutSet(
                            id: set.id,
                            workoutExerciseId: set.workoutExerciseId,
                            setNumber: set.setNumber,
                            reps: reps,
                            weight: set.weight,
                            effortLevel: set.effortLevel,
                            effortLevelSpecifier: set.effortLevelSpecifier,
                            completed: set.completed,
                            completedAt: set.completedAt,
                            notes: set.notes,
                          ));
                        },
                      )
                    : Text(
                        set.reps?.toString() ?? '-',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Weight input
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Weight (kg)',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                isEditable
                    ? TextFormField(
                        initialValue: set.weight?.toString() ?? '',
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: const TextStyle(fontSize: 16),
                        decoration: const InputDecoration(
                          hintText: '0.0',
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          final weight = double.tryParse(value);
                          onSetUpdated(WorkoutSet(
                            id: set.id,
                            workoutExerciseId: set.workoutExerciseId,
                            setNumber: set.setNumber,
                            reps: set.reps,
                            weight: weight,
                            effortLevel: set.effortLevel,
                            effortLevelSpecifier: set.effortLevelSpecifier,
                            completed: set.completed,
                            completedAt: set.completedAt,
                            notes: set.notes,
                          ));
                        },
                      )
                    : Text(
                        set.weight?.toString() ?? '-',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Completed checkbox
          if (isEditable)
            Checkbox(
              value: set.completed,
              activeColor: AppColors.primary,
              onChanged: (value) {
                onSetUpdated(WorkoutSet(
                  id: set.id,
                  workoutExerciseId: set.workoutExerciseId,
                  setNumber: set.setNumber,
                  reps: set.reps,
                  weight: set.weight,
                  effortLevel: set.effortLevel,
                  effortLevelSpecifier: set.effortLevelSpecifier,
                  completed: value ?? false,
                  completedAt: value == true ? DateTime.now() : null,
                  notes: set.notes,
                ));
              },
            )
          else if (set.completed)
            const Icon(
              Icons.check_circle,
              color: AppColors.success,
              size: 24,
            ),

          // Options menu button
          IconButton(
            icon: const Icon(Icons.more_vert),
            iconSize: 20,
            color: AppColors.textSecondary,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {
              // TODO: Show options menu for the set
            },
          ),
        ],
      ),
    );
  }
}

