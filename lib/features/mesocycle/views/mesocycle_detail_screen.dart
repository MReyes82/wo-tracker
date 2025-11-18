import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/themes/app_colors.dart';
import '../models/mesocycle.dart';
import '../models/mesocycle_workout.dart';
import '../repositories/mesocycle_repository.dart';
import '../repositories/mesocycle_workout_repository.dart';
import '../../workout/models/workout_template.dart';
import '../../workout/repositories/workout_template_repository.dart';

class MesocycleDetailScreen extends StatefulWidget {
  final int mesocycleId;

  const MesocycleDetailScreen({
    Key? key,
    required this.mesocycleId,
  }) : super(key: key);

  @override
  State<MesocycleDetailScreen> createState() => _MesocycleDetailScreenState();
}

class _MesocycleDetailScreenState extends State<MesocycleDetailScreen> {
  final MesocycleRepository _mesocycleRepository = MesocycleRepository();
  final MesocycleWorkoutRepository _mesocycleWorkoutRepository = MesocycleWorkoutRepository();
  final WorkoutTemplateRepository _templateRepository = WorkoutTemplateRepository();

  Mesocycle? _mesocycle;
  List<_WorkoutDetail> _workouts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMesocycleDetails();
  }

  Future<void> _loadMesocycleDetails() async {
    try {
      final mesocycle = await _mesocycleRepository.getById(widget.mesocycleId);
      
      if (mesocycle != null) {
        final mesocycleWorkouts = await _mesocycleWorkoutRepository.getByMesocycle(mesocycle.id!);

        List<_WorkoutDetail> workoutDetails = [];
        for (var mesocycleWorkout in mesocycleWorkouts) {
          final template = await _templateRepository.getById(mesocycleWorkout.workoutTemplateId);
          if (template != null) {
            workoutDetails.add(_WorkoutDetail(
              template: template,
              mesocycleWorkout: mesocycleWorkout,
            ));
          }
        }

        // Sort by day of week
        workoutDetails.sort((a, b) => a.mesocycleWorkout.dayOfWeek.compareTo(b.mesocycleWorkout.dayOfWeek));

        setState(() {
          _mesocycle = mesocycle;
          _workouts = workoutDetails;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading mesocycle details: $e');
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
          _mesocycle?.name ?? 'Mesocycle Details',
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
          : _mesocycle == null
              ? const Center(child: Text('Mesocycle not found'))
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
                              Icons.calendar_month,
                              size: 64,
                              color: AppColors.primary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _mesocycle!.name,
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

                      // Duration card
                      Container(
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
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _buildInfoTile(
                                    icon: Icons.calendar_today,
                                    label: 'Duration',
                                    value: '${_mesocycle!.weeksQuantity} weeks',
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 40,
                                  color: AppColors.divider,
                                ),
                                Expanded(
                                  child: _buildInfoTile(
                                    icon: Icons.repeat,
                                    label: 'Per Week',
                                    value: '${_mesocycle!.sessionsPerWeek} sessions',
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildInfoTile(
                                    icon: Icons.play_circle_outline,
                                    label: 'Start Date',
                                    value: DateFormat('MMM d, y').format(_mesocycle!.startDate),
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 40,
                                  color: AppColors.divider,
                                ),
                                Expanded(
                                  child: _buildInfoTile(
                                    icon: Icons.flag,
                                    label: 'End Date',
                                    value: DateFormat('MMM d, y').format(_mesocycle!.endDate),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Workout split section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Workout Split',
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
                              '${_workouts.length} workouts',
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

                      if (_workouts.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'No workouts in this mesocycle',
                              style: TextStyle(
                                color: AppColors.textSecondary.withValues(alpha: 0.7),
                              ),
                            ),
                          ),
                        )
                      else
                        ...List.generate(_workouts.length, (index) {
                          return _buildWorkoutCard(_workouts[index], index + 1);
                        }),
                    ],
                  ),
                ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, size: 24, color: AppColors.primary),
        const SizedBox(height: 8),
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
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildWorkoutCard(_WorkoutDetail detail, int position) {
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
            child: Center(
              child: Text(
                '$position',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Session $position',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  detail.template.name,
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

class _WorkoutDetail {
  final WorkoutTemplate template;
  final MesocycleWorkout mesocycleWorkout;

  _WorkoutDetail({
    required this.template,
    required this.mesocycleWorkout,
  });
}

