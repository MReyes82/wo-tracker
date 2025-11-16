import 'package:flutter/material.dart';
import '../../../core/themes/app_colors.dart';
import '../repositories/mesocycle_repository.dart';
import '../repositories/mesocycle_workout_repository.dart';
import '../../workout/repositories/workout_template_repository.dart';
import '../models/mesocycle.dart';
import '../models/mesocycle_workout.dart';
import '../../workout/models/workout_template.dart';

class NewMesocycleScreen extends StatefulWidget {
  const NewMesocycleScreen({Key? key}) : super(key: key);

  @override
  State<NewMesocycleScreen> createState() => _NewMesocycleScreenState();
}

class _NewMesocycleScreenState extends State<NewMesocycleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mesocycleNameController = TextEditingController();

  // Repositories
  final _mesocycleRepository = MesocycleRepository();
  final _mesocycleWorkoutRepository = MesocycleWorkoutRepository();
  final _workoutTemplateRepository = WorkoutTemplateRepository();

  // Form state
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
    _loadCatalogs();
    // Initialize with default session (1)
    _updateSessionsPerWeek(_sessionsPerWeek);
  }

  @override
  void dispose() {
    _mesocycleNameController.dispose();
    super.dispose();
  }

  Future<void> _loadCatalogs() async {
    try {
      final workoutTemplates = await _workoutTemplateRepository.getAll();

      setState(() {
        _workoutTemplates = workoutTemplates;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading workout templates: $e');
      setState(() {
        _isLoading = false;
      });
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

  Future<void> _saveMesocycle() async {
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
      final startDate = DateTime.now();
      final endDate = startDate.add(Duration(days: _trainingWeeks * 7));

      // Create mesocycle
      final mesocycle = Mesocycle(
        name: _mesocycleName!,
        startDate: startDate,
        endDate: endDate,
        weeksQuantity: _trainingWeeks,
        sessionsPerWeek: _sessionsPerWeek,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final mesocycleId = await _mesocycleRepository.create(mesocycle);

      // Create mesocycle workout assignments
      for (int i = 0; i < _workoutSelections.length; i++) {
        final selection = _workoutSelections[i];
        final mesocycleWorkout = MesocycleWorkout(
          mesocycleId: mesocycleId,
          workoutTemplateId: selection.workoutTemplateId!,
          dayOfWeek: selection.dayOfWeek,
        );
        await _mesocycleWorkoutRepository.create(mesocycleWorkout);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mesocycle created successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error saving mesocycle: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating mesocycle: $e'),
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
          'New Mesocycle',
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

                      // Mesocycle Name Field (Always visible)
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

                      // Training Weeks Picker (Appears after name is filled)
                      if (_mesocycleName != null) ...[
                        const SizedBox(height: 24),
                        _buildSectionTitle('Amount of Training Weeks'),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.borderColor),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Weeks:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline),
                                    color: AppColors.primary,
                                    onPressed: _trainingWeeks > 1
                                        ? () {
                                            setState(() {
                                              _trainingWeeks--;
                                            });
                                          }
                                        : null,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      _trainingWeeks.toString(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    color: AppColors.primary,
                                    onPressed: () {
                                      setState(() {
                                        _trainingWeeks++;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],

                      // Sessions Per Week Slider (Appears after training weeks is set)
                      if (_trainingWeeks >= 1) ...[
                        const SizedBox(height: 24),
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
                      ],

                      // Workout Split Selection (Appears after sessions per week is set)
                      if (_workoutSelections.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        _buildSectionTitle('Select Split (Sessions of the Week)'),
                        const SizedBox(height: 16),
                        
                        ...List.generate(_workoutSelections.length, (index) {
                          return _buildWorkoutSelector(index);
                        }),

                        const SizedBox(height: 32),

                        // Save Button
                        ElevatedButton(
                          onPressed: _isSaving ? null : _saveMesocycle,
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
                                  'Save Mesocycle',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ],

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildWorkoutSelector(int index) {
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
          Text(
            'Session ${index + 1}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          
          // Workout Template Dropdown
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: DropdownButtonFormField<int>(
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
              hint: const Text('Choose workout template'),
              items: _workoutTemplates.map((template) {
                return DropdownMenuItem<int>(
                  value: template.id!,
                  child: Text(template.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _workoutSelections[index].workoutTemplateId = value;
                });
              },
            ),
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
  int? workoutTemplateId;
  int dayOfWeek;

  _WorkoutSelection({
    this.workoutTemplateId,
    required this.dayOfWeek,
  });
}

