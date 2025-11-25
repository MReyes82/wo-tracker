import 'package:flutter/material.dart';
import 'package:wo_tracker/generated/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../../core/themes/app_colors.dart';
import '../models/workout_template.dart';
import '../models/template_exercise.dart';
import '../repositories/workout_template_repository.dart';
import '../repositories/template_exercise_repository.dart';
import '../repositories/workout_type_repository.dart';
import '../../exercise/models/exercise.dart';
import '../../exercise/repositories/exercise_repository.dart';
import '../../exercise/repositories/muscle_group_repository.dart';
import '../../exercise/repositories/equipment_type_repository.dart';

class WorkoutTemplateDetailScreen extends StatefulWidget {
  final int templateId;

  const WorkoutTemplateDetailScreen({
    Key? key,
    required this.templateId,
  }) : super(key: key);

  @override
  State<WorkoutTemplateDetailScreen> createState() => _WorkoutTemplateDetailScreenState();
}

class _WorkoutTemplateDetailScreenState extends State<WorkoutTemplateDetailScreen> {
  final WorkoutTemplateRepository _templateRepository = WorkoutTemplateRepository();
  final TemplateExerciseRepository _templateExerciseRepository = TemplateExerciseRepository();
  final WorkoutTypeRepository _workoutTypeRepository = WorkoutTypeRepository();
  final ExerciseRepository _exerciseRepository = ExerciseRepository();
  final MuscleGroupRepository _muscleGroupRepository = MuscleGroupRepository();
  final EquipmentTypeRepository _equipmentTypeRepository = EquipmentTypeRepository();

  WorkoutTemplate? _template;
  String? _workoutType;
  List<_ExerciseDetail> _exercises = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTemplateDetails();
  }

  Future<void> _loadTemplateDetails() async {
    try {
      final template = await _templateRepository.getById(widget.templateId);

      if (template != null) {
        final workoutType = await _workoutTypeRepository.getById(template.typeId);
        final templateExercises = await _templateExerciseRepository.getByTemplate(template.id!);

        List<_ExerciseDetail> exerciseDetails = [];
        for (var templateExercise in templateExercises) {
          final exercise = await _exerciseRepository.getById(templateExercise.exerciseId);
          if (exercise != null) {
            final muscleGroup = await _muscleGroupRepository.getById(exercise.muscleGroupId);
            final equipment = await _equipmentTypeRepository.getById(exercise.equipmentTypeId);

            exerciseDetails.add(_ExerciseDetail(
              exercise: exercise,
              templateExercise: templateExercise,
              muscleGroupName: muscleGroup?.name ?? 'Unknown',
              equipmentName: equipment?.name ?? 'Unknown',
            ));
          }
        }

        setState(() {
          _template = template;
          _workoutType = workoutType?.name;
          _exercises = exerciseDetails;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading workout template details: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          _template?.name ?? 'Workout Details',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _template == null
              ? const Center(child: Text('Workout template not found'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header card
                      Container(
                        padding: const EdgeInsets.all(20),
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.view_list,
                              size: 64,
                              color: AppColors.primary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _template!.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _workoutType ?? 'Unknown Type',
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            if (_template!.createdAt != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                'Created ${DateFormat('MMM d, y').format(_template!.createdAt!)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Exercises section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Exercises',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${_exercises.length} exercises',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      if (_exercises.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'No exercises in this workout',
                              style: TextStyle(
                                color: AppColors.textSecondary.withValues(alpha: 0.7),
                              ),
                            ),
                          ),
                        )
                      else
                        ...List.generate(_exercises.length, (index) {
                          return _buildExerciseCard(_exercises[index], index + 1);
                        }),
                    ],
                  ),
                ),
    );
  }

  Widget _buildExerciseCard(_ExerciseDetail detail, int position) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    '$position',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  detail.exercise.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.fitness_center, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                detail.muscleGroupName,
                style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(width: 16),
              Icon(Icons.build, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                detail.equipmentName,
                style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.repeat, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  '${detail.templateExercise.plannedSets} sets',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (detail.templateExercise.useDefaultWeight) ...[
                  const SizedBox(width: 16),
                  const Icon(Icons.check_circle, size: 16, color: AppColors.success),
                  const SizedBox(width: 4),
                  const Text(
                    'Using default weight',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.success,
                    ),
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

class _ExerciseDetail {
  final Exercise exercise;
  final TemplateExercise templateExercise;
  final String muscleGroupName;
  final String equipmentName;

  _ExerciseDetail({
    required this.exercise,
    required this.templateExercise,
    required this.muscleGroupName,
    required this.equipmentName,
  });
}

