import 'package:flutter/material.dart';
import 'package:wo_tracker/generated/l10n/app_localizations.dart';
import '../../../core/themes/app_colors.dart';
import '../models/exercise.dart';
import '../repositories/exercise_repository.dart';
import '../../exercise/repositories/exercise_type_repository.dart';
import '../../exercise/repositories/equipment_type_repository.dart';
import '../../exercise/repositories/muscle_group_repository.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final int exerciseId;

  const ExerciseDetailScreen({
    Key? key,
    required this.exerciseId,
  }) : super(key: key);

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  final ExerciseRepository _exerciseRepository = ExerciseRepository();
  final ExerciseTypeRepository _exerciseTypeRepository = ExerciseTypeRepository();
  final EquipmentTypeRepository _equipmentTypeRepository = EquipmentTypeRepository();
  final MuscleGroupRepository _muscleGroupRepository = MuscleGroupRepository();

  Exercise? _exercise;
  String? _exerciseType;
  String? _equipmentType;
  String? _muscleGroup;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExerciseDetails();
  }

  Future<void> _loadExerciseDetails() async {
    try {
      final exercise = await _exerciseRepository.getById(widget.exerciseId);
      
      if (exercise != null) {
        final exerciseType = await _exerciseTypeRepository.getById(exercise.exerciseTypeId);
        final equipmentType = await _equipmentTypeRepository.getById(exercise.equipmentTypeId);
        final muscleGroup = await _muscleGroupRepository.getById(exercise.muscleGroupId);

        setState(() {
          _exercise = exercise;
          _exerciseType = exerciseType?.name;
          _equipmentType = equipmentType?.name;
          _muscleGroup = muscleGroup?.name;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading exercise details: $e');
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
          _exercise?.name ?? AppLocalizations.of(context)!.exerciseDetails,
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
          : _exercise == null
              ? const Center(child: Text('Exercise not found'))
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
                              Icons.fitness_center,
                              size: 64,
                              color: AppColors.primary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _exercise!.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Details section
                      Text(
                        AppLocalizations.of(context)!.details,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),

                      _buildDetailCard(
                        icon: Icons.category,
                        label: AppLocalizations.of(context)!.exerciseType,
                        value: _exerciseType ?? 'Unknown',
                      ),
                      _buildDetailCard(
                        icon: Icons.build,
                        label: AppLocalizations.of(context)!.equipment,
                        value: _equipmentType ?? 'Unknown',
                      ),
                      _buildDetailCard(
                        icon: Icons.fitness_center,
                        label: AppLocalizations.of(context)!.muscleGroups,
                        value: _muscleGroup ?? 'Unknown',
                      ),
                      if (_exercise!.defaultWorkingWeight != null)
                        _buildDetailCard(
                          icon: Icons.monitor_weight,
                          label: AppLocalizations.of(context)!.defaultWorkingWeight,
                          value: '${_exercise!.defaultWorkingWeight} ${_exercise!.isUsingMetric ? "kg" : "lbs"}',
                        ),
                      _buildDetailCard(
                        icon: Icons.straighten,
                        label: AppLocalizations.of(context)!.unitSystemLabel,
                        value: _exercise!.isUsingMetric ? AppLocalizations.of(context)!.metricKg : AppLocalizations.of(context)!.imperialLbs,
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
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
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

