import 'package:flutter/material.dart';
import 'package:wo_tracker/generated/l10n/app_localizations.dart';
import '../../../core/themes/app_colors.dart';
import '../repositories/workout_type_repository.dart';
import '../repositories/workout_template_repository.dart';
import '../repositories/template_exercise_repository.dart';
import '../../exercise/repositories/exercise_repository.dart';
import '../models/workout_type.dart';
import '../models/workout_template.dart';
import '../models/template_exercise.dart';
import '../../exercise/models/exercise.dart';

class NewWorkoutScreen extends StatefulWidget {
  const NewWorkoutScreen({Key? key}) : super(key: key);

  @override
  State<NewWorkoutScreen> createState() => _NewWorkoutScreenState();
}

class _NewWorkoutScreenState extends State<NewWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _workoutNameController = TextEditingController();

  // Repositories
  final _workoutTypeRepository = WorkoutTypeRepository();
  final _workoutTemplateRepository = WorkoutTemplateRepository();
  final _templateExerciseRepository = TemplateExerciseRepository();
  final _exerciseRepository = ExerciseRepository();

  // Form state
  String? _workoutName;
  int? _selectedWorkoutTypeId;
  int _numberOfExercises = 1;
  List<_ExerciseSelection> _exerciseSelections = [];

  // Catalog data
  List<WorkoutType> _workoutTypes = [];
  List<Exercise> _exercises = [];

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadCatalogs();
    // Initialize with default exercise count (1)
    _updateExerciseCount(_numberOfExercises);
  }

  @override
  void dispose() {
    _workoutNameController.dispose();
    super.dispose();
  }

  Future<void> _loadCatalogs() async {
    try {
      final workoutTypes = await _workoutTypeRepository.getAll();
      final exercises = await _exerciseRepository.getAll();

      setState(() {
        _workoutTypes = workoutTypes;
        _exercises = exercises;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading catalogs: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateExerciseCount(int count) {
    setState(() {
      _numberOfExercises = count;
      
      // Adjust the exercise selections list
      if (_exerciseSelections.length < count) {
        // Add new selections
        while (_exerciseSelections.length < count) {
          _exerciseSelections.add(_ExerciseSelection());
        }
      } else if (_exerciseSelections.length > count) {
        // Remove excess selections
        _exerciseSelections = _exerciseSelections.sublist(0, count);
      }
    });
  }

  String _getOrdinal(int number) {
    if (number % 100 >= 11 && number % 100 <= 13) {
      return '${number}th';
    }
    switch (number % 10) {
      case 1:
        return '${number}st';
      case 2:
        return '${number}nd';
      case 3:
        return '${number}rd';
      default:
        return '${number}th';
    }
  }

  Future<void> _saveWorkout() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate all exercises are selected
    for (int i = 0; i < _exerciseSelections.length; i++) {
      if (_exerciseSelections[i].exerciseId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.pleaseSelectTheOrdinalExercise(_getOrdinal(i + 1))),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
      if (_exerciseSelections[i].plannedSets < 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.pleaseSelectSetsForTheOrdinalExercise(_getOrdinal(i + 1))),
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
      // Create workout template
      final template = WorkoutTemplate(
        name: _workoutName!,
        typeId: _selectedWorkoutTypeId!,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final templateId = await _workoutTemplateRepository.create(template);

      // Create template exercises
      for (int i = 0; i < _exerciseSelections.length; i++) {
        final selection = _exerciseSelections[i];
        final templateExercise = TemplateExercise(
          templateId: templateId,
          exerciseId: selection.exerciseId!,
          position: i,
          plannedSets: selection.plannedSets,
          useDefaultWeight: selection.useDefaultWeight,
        );
        await _templateExerciseRepository.create(templateExercise);
      }

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.workoutSaved),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error saving workout: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.errorCreatingWorkout(e.toString())),
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
        title: Text(
          AppLocalizations.of(context)!.newWorkout,
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

                      // Workout Name Field (Always visible)
                      _buildSectionTitle(AppLocalizations.of(context)!.workoutName),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _workoutNameController,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.enterWorkoutName,
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
                          final l10n = AppLocalizations.of(context)!;
                          if (value == null || value.trim().isEmpty) {
                            return l10n.pleaseEnter(l10n.workoutName);
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _workoutName = value.trim().isNotEmpty ? value.trim() : null;
                          });
                        },
                      ),

                      // Workout Type Dropdown (Appears after name is filled)
                      if (_workoutName != null) ...[
                        const SizedBox(height: 24),
                        _buildSectionTitle(AppLocalizations.of(context)!.workoutType),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int>(
                          decoration: InputDecoration(
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
                          hint: Text(AppLocalizations.of(context)!.selectWorkoutType),
                          items: _workoutTypes.map((type) {
                            return DropdownMenuItem<int>(
                              value: type.id!,
                              child: Text(type.name),
                            );
                          }).toList(),
                          validator: (value) {
                            final l10n = AppLocalizations.of(context)!;
                            if (value == null) {
                              return l10n.pleaseSelect(l10n.workoutType);
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _selectedWorkoutTypeId = value;
                            });
                          },
                        ),
                      ],

                      // Number of Exercises Slider (Appears after workout type is selected)
                      if (_selectedWorkoutTypeId != null) ...[
                        const SizedBox(height: 24),
                        _buildSectionTitle(AppLocalizations.of(context)!.numberOfExercises),
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
                                    '${AppLocalizations.of(context)!.exercises}: $_numberOfExercises',
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
                                      _numberOfExercises.toString(),
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
                                value: _numberOfExercises.toDouble(),
                                min: 1,
                                max: 10,
                                divisions: 9,
                                activeColor: AppColors.primary,
                                label: _numberOfExercises.toString(),
                                onChanged: (value) {
                                  _updateExerciseCount(value.toInt());
                                },
                              ),
                              Text(
                                AppLocalizations.of(context)!.numberOfExercisesToPerform,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      // Exercise Selection List (Appears after number of exercises is set)
                      if (_exerciseSelections.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        _buildSectionTitle(AppLocalizations.of(context)!.selectExercises),
                        const SizedBox(height: 16),
                        
                        ...List.generate(_exerciseSelections.length, (index) {
                          return _buildExerciseSelector(index);
                        }),

                        const SizedBox(height: 32),

                        // Save Button
                        ElevatedButton(
                          onPressed: _isSaving ? null : _saveWorkout,
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
                              : Text(
                                  AppLocalizations.of(context)!.saveWorkout,
                                  style: const TextStyle(
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

  Widget _buildExerciseSelector(int index) {
    final selection = _exerciseSelections[index];
    final selectedExercise = selection.exerciseId != null
        ? _exercises.firstWhere((e) => e.id == selection.exerciseId)
        : null;

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
            AppLocalizations.of(context)!.selectTheOrdinalExercise(_getOrdinal(index + 1)),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          
          // Exercise Dropdown
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
              hint: Text(AppLocalizations.of(context)!.chooseExercise),
              items: _exercises.map((exercise) {
                return DropdownMenuItem<int>(
                  value: exercise.id!,
                  child: Text(exercise.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _exerciseSelections[index].exerciseId = value;
                });
              },
            ),
          ),

          // Sets and Default Weight options (Appears after exercise is selected)
          if (selection.exerciseId != null) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                // Sets Picker
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.sets,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.borderColor),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              color: AppColors.primary,
                              onPressed: selection.plannedSets > 1
                                  ? () {
                                      setState(() {
                                        _exerciseSelections[index].plannedSets--;
                                      });
                                    }
                                  : null,
                            ),
                            Text(
                              '${selection.plannedSets}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              color: AppColors.primary,
                              onPressed: () {
                                setState(() {
                                  _exerciseSelections[index].plannedSets++;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                
                // Use Default Weight Checkbox
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.defaultWeight,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.borderColor),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                selectedExercise?.defaultWorkingWeight != null
                                    ? '${selectedExercise!.defaultWorkingWeight} ${selectedExercise.isUsingMetric ? 'kg' : 'lbs'}'
                                    : AppLocalizations.of(context)!.notSet,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: selectedExercise?.defaultWorkingWeight != null
                                      ? AppColors.textPrimary
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ),
                            Checkbox(
                              value: selection.useDefaultWeight,
                              activeColor: AppColors.primary,
                              onChanged: selectedExercise?.defaultWorkingWeight != null
                                  ? (value) {
                                      setState(() {
                                        _exerciseSelections[index].useDefaultWeight = value ?? false;
                                      });
                                    }
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
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

class _ExerciseSelection {
  int? exerciseId;
  int plannedSets;
  bool useDefaultWeight;

  _ExerciseSelection({
    this.exerciseId,
    this.plannedSets = 3,
    this.useDefaultWeight = false,
  });
}

