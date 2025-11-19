import 'package:flutter/material.dart';
import '../../../core/themes/app_colors.dart';
import '../repositories/mesocycle_repository.dart';
import '../repositories/mesocycle_workout_repository.dart';
import '../../workout/repositories/workout_template_repository.dart';
import '../../workout/repositories/workout_session_repository.dart';
import '../../workout/repositories/template_exercise_repository.dart';
import '../../workout/repositories/workout_exercise_repository.dart';
import '../../workout/repositories/workout_set_repository.dart';
import '../../exercise/repositories/exercise_repository.dart';
import '../models/mesocycle.dart';
import '../models/mesocycle_workout.dart';
import '../../workout/models/workout_template.dart';
import '../../workout/models/workout_session.dart';
import '../../workout/models/workout_exercise.dart';
import '../../workout/models/workout_set.dart';

class EditMesocycleScreen extends StatefulWidget {
  final int mesocycleId;

  const EditMesocycleScreen({
    Key? key,
    required this.mesocycleId,
  }) : super(key: key);

  @override
  State<EditMesocycleScreen> createState() => _EditMesocycleScreenState();
}

class _EditMesocycleScreenState extends State<EditMesocycleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mesocycleNameController = TextEditingController();

  // Repositories
  final _mesocycleRepository = MesocycleRepository();
  final _mesocycleWorkoutRepository = MesocycleWorkoutRepository();
  final _workoutTemplateRepository = WorkoutTemplateRepository();
  final _workoutSessionRepository = WorkoutSessionRepository();
  final _templateExerciseRepository = TemplateExerciseRepository();
  final _workoutExerciseRepository = WorkoutExerciseRepository();
  final _workoutSetRepository = WorkoutSetRepository();
  final _exerciseRepository = ExerciseRepository();

  // Form state
  Mesocycle? _mesocycle;
  String? _mesocycleName;
  int _trainingWeeks = 1;
  int _sessionsPerWeek = 1;
  List<_WorkoutSelection> _workoutSelections = [];

  // Catalog data
  List<WorkoutTemplate> _workoutTemplates = [];

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _mesocycleNameController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      // Load catalogs
      final workoutTemplates = await _workoutTemplateRepository.getAll();

      // Load mesocycle data
      final mesocycle = await _mesocycleRepository.getById(widget.mesocycleId);

      if (mesocycle != null) {
        _mesocycleNameController.text = mesocycle.name;

        // Load mesocycle workouts
        final mesocycleWorkouts = await _mesocycleWorkoutRepository.getByMesocycle(mesocycle.id!);

        // Convert to workout selections
        final selections = <_WorkoutSelection>[];
        for (var mw in mesocycleWorkouts) {
          selections.add(_WorkoutSelection(
            dayOfWeek: mw.dayOfWeek,
            workoutTemplateId: mw.workoutTemplateId,
            mesocycleWorkoutId: mw.id,
          ));
        }

        setState(() {
          _mesocycle = mesocycle;
          _workoutTemplates = workoutTemplates;
          _mesocycleName = mesocycle.name;
          _trainingWeeks = mesocycle.weeksQuantity;
          _sessionsPerWeek = selections.length;
          _workoutSelections = selections;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading mesocycle: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _updateSessionsPerWeek(int count) {
    setState(() {
      _sessionsPerWeek = count;
      
      // Adjust the workout selections list
      if (_workoutSelections.length < count) {
        // Add new selections
        while (_workoutSelections.length < count) {
          final dayIndex = _workoutSelections.length;
          _workoutSelections.add(_WorkoutSelection(dayOfWeek: dayIndex + 1));
        }
      } else if (_workoutSelections.length > count) {
        // Remove excess selections
        _workoutSelections = _workoutSelections.sublist(0, count);
      }
    });
  }

  Future<void> _updateMesocycle() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate all workouts are selected
    for (int i = 0; i < _workoutSelections.length; i++) {
      if (_workoutSelections[i].workoutTemplateId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select a workout for Session ${i + 1}'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Calculate start and end dates
      final startDate = _mesocycle!.startDate;
      final endDate = startDate.add(Duration(days: _trainingWeeks * 7));

      // Update mesocycle
      final updatedMesocycle = Mesocycle(
        id: widget.mesocycleId,
        name: _mesocycleName!,
        startDate: startDate,
        endDate: endDate,
        weeksQuantity: _trainingWeeks,
        sessionsPerWeek: _sessionsPerWeek,
        createdAt: _mesocycle!.createdAt,
        updatedAt: DateTime.now(),
      );

      await _mesocycleRepository.update(updatedMesocycle);

      // Delete old mesocycle workout assignments
      await _mesocycleWorkoutRepository.deleteByMesocycle(widget.mesocycleId);

      // Create new mesocycle workout assignments
      for (int i = 0; i < _workoutSelections.length; i++) {
        final selection = _workoutSelections[i];
        final mesocycleWorkout = MesocycleWorkout(
          mesocycleId: widget.mesocycleId,
          workoutTemplateId: selection.workoutTemplateId!,
          dayOfWeek: selection.dayOfWeek,
        );
        await _mesocycleWorkoutRepository.create(mesocycleWorkout);
      }

      // Get all existing workout sessions for this mesocycle
      final existingSessions = await _workoutSessionRepository.getSessionsByMesocycle(widget.mesocycleId);

      // Separate completed and incomplete sessions
      final completedSessions = existingSessions.where((s) => s.endTime != null).toList();
      final incompleteSessions = existingSessions.where((s) => s.endTime == null).toList();

      // Delete only incomplete workout sessions
      for (var session in incompleteSessions) {
        if (session.id != null) {
          // Delete associated workout exercises and sets
          final workoutExercises = await _workoutExerciseRepository.getBySession(session.id!);
          for (var workoutExercise in workoutExercises) {
            if (workoutExercise.id != null) {
              // Delete sets for this exercise
              final sets = await _workoutSetRepository.getByWorkoutExercise(workoutExercise.id!);
              for (var set in sets) {
                if (set.id != null) {
                  await _workoutSetRepository.delete(set.id!);
                }
              }
              // Delete the exercise
              await _workoutExerciseRepository.delete(workoutExercise.id!);
            }
          }
          // Delete the session
          await _workoutSessionRepository.delete(session.id!);
        }
      }

      // Calculate how many sessions have been completed
      final completedSessionsCount = completedSessions.length;
      final totalSessionsNeeded = _trainingWeeks * _sessionsPerWeek;

      // Only generate sessions for the remaining slots
      if (completedSessionsCount < totalSessionsNeeded) {
        // Calculate which week and session to start from
        int sessionsToGenerate = totalSessionsNeeded - completedSessionsCount;

        // Start generating from where we left off
        int currentSessionIndex = completedSessionsCount;

        while (sessionsToGenerate > 0 && currentSessionIndex < totalSessionsNeeded) {
          final week = currentSessionIndex ~/ _sessionsPerWeek;
          final sessionInWeek = currentSessionIndex % _sessionsPerWeek;

          final selection = _workoutSelections[sessionInWeek];
          final template = await _workoutTemplateRepository.getById(selection.workoutTemplateId!);

          if (template != null) {
            // Calculate the date for this session
            final sessionDate = startDate.add(Duration(days: week * 7 + sessionInWeek));

            final session = WorkoutSession(
              templateId: template.id,
              title: template.name,
              startTime: sessionDate,
              mesocycleId: widget.mesocycleId,
              createdAt: DateTime.now(),
            );

            final sessionId = await _workoutSessionRepository.create(session);

            // Copy exercises from template to session
            final templateExercises = await _templateExerciseRepository.getByTemplate(template.id!);

            for (final templateExercise in templateExercises) {
              // Get exercise details
              final exercise = await _exerciseRepository.getById(templateExercise.exerciseId);

              if (exercise != null) {
                final workoutExercise = WorkoutExercise(
                  sessionId: sessionId,
                  templateExerciseId: templateExercise.id,
                  exerciseId: exercise.id,
                  exerciseName: exercise.name,
                  plannedSets: templateExercise.plannedSets,
                  position: templateExercise.position,
                );

                final workoutExerciseId = await _workoutExerciseRepository.create(workoutExercise);

                // Create workout sets based on planned sets
                for (int setNum = 1; setNum <= templateExercise.plannedSets; setNum++) {
                  final workoutSet = WorkoutSet(
                    workoutExerciseId: workoutExerciseId,
                    setNumber: setNum,
                    // Only pre-fill weight if useDefaultWeight is true
                    weight: templateExercise.useDefaultWeight ? exercise.defaultWorkingWeight : null,
                    completed: false,
                  );

                  await _workoutSetRepository.create(workoutSet);
                }
              }
            }
          }

          currentSessionIndex++;
          sessionsToGenerate--;
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mesocycle updated successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context, true); // Return true to indicate success
      }
    } catch (e) {
      print('Error updating mesocycle: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating mesocycle: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Edit Mesocycle',
          style: TextStyle(
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
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 8),

                      // Mesocycle Name Field
                      _buildSectionTitle('Mesocycle Name'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _mesocycleNameController,
                        decoration: InputDecoration(
                          hintText: 'Enter mesocycle name',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppColors.borderColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppColors.borderColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppColors.primary, width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a mesocycle name';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _mesocycleName = value.trim().isNotEmpty ? value.trim() : null;
                          });
                        },
                      ),

                      const SizedBox(height: 24),

                      // Training Weeks Slider
                      _buildSectionTitle('Training Weeks'),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.borderColor),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Weeks: $_trainingWeeks',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
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
                                    _trainingWeeks.toString(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Slider(
                              value: _trainingWeeks.toDouble(),
                              min: 1,
                              max: 12,
                              divisions: 11,
                              activeColor: AppColors.primary,
                              label: _trainingWeeks.toString(),
                              onChanged: (value) {
                                setState(() {
                                  _trainingWeeks = value.toInt();
                                });
                              },
                            ),
                            const Text(
                              'Duration of the mesocycle in weeks',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Sessions Per Week Slider
                      _buildSectionTitle('Sessions Per Week'),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.borderColor),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Sessions: $_sessionsPerWeek',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
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
                                    _sessionsPerWeek.toString(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Slider(
                              value: _sessionsPerWeek.toDouble(),
                              min: 1,
                              max: 7,
                              divisions: 6,
                              activeColor: AppColors.primary,
                              label: _sessionsPerWeek.toString(),
                              onChanged: (value) {
                                _updateSessionsPerWeek(value.toInt());
                              },
                            ),
                            const Text(
                              'Number of workout sessions per week',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Workout Selection List
                      _buildSectionTitle('Workout Schedule'),
                      const SizedBox(height: 16),
                      
                      ...List.generate(_workoutSelections.length, (index) {
                        return _buildWorkoutSelector(index);
                      }),

                      const SizedBox(height: 32),

                      // Update Button
                      ElevatedButton(
                        onPressed: _isSaving ? null : _updateMesocycle,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isSaving
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Update Mesocycle',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildWorkoutSelector(int index) {
    final selection = _workoutSelections[index];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Session ${index + 1}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          // Workout Dropdown
          DropdownButtonFormField<int>(
            value: selection.workoutTemplateId,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.background,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
            hint: const Text('Choose workout'),
            items: _workoutTemplates.map((workout) {
              return DropdownMenuItem<int>(
                value: workout.id!,
                child: Text(workout.name),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _workoutSelections[index].workoutTemplateId = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _WorkoutSelection {
  int dayOfWeek;
  int? workoutTemplateId;
  int? mesocycleWorkoutId;

  _WorkoutSelection({
    required this.dayOfWeek,
    this.workoutTemplateId,
    this.mesocycleWorkoutId,
  });
}

