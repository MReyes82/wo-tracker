import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/themes/app_colors.dart';
import '../repositories/exercise_type_repository.dart';
import '../repositories/equipment_type_repository.dart';
import '../repositories/muscle_group_repository.dart';
import '../repositories/exercise_repository.dart';
import '../models/exercise_type.dart';
import '../models/equipment_type.dart';
import '../models/muscle_group.dart';
import '../models/exercise.dart';

class NewExerciseScreen extends StatefulWidget {
  const NewExerciseScreen({Key? key}) : super(key: key);

  @override
  State<NewExerciseScreen> createState() => _NewExerciseScreenState();
}

class _NewExerciseScreenState extends State<NewExerciseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _exerciseNameController = TextEditingController();
  final _defaultWeightController = TextEditingController();

  // Repositories
  final _exerciseTypeRepository = ExerciseTypeRepository();
  final _equipmentTypeRepository = EquipmentTypeRepository();
  final _muscleGroupRepository = MuscleGroupRepository();
  final _exerciseRepository = ExerciseRepository();

  // Form state
  String? _exerciseName;
  int? _selectedExerciseTypeId;
  int? _selectedEquipmentTypeId;
  int? _selectedMuscleGroupId;
  double? _defaultWeight;
  bool _isUsingMetric = true;

  // Catalog data
  List<ExerciseType> _exerciseTypes = [];
  List<EquipmentType> _equipmentTypes = [];
  List<MuscleGroup> _muscleGroups = [];

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadCatalogs();
  }

  @override
  void dispose() {
    _exerciseNameController.dispose();
    _defaultWeightController.dispose();
    super.dispose();
  }

  Future<void> _loadCatalogs() async {
    try {
      final exerciseTypes = await _exerciseTypeRepository.getAll();
      final equipmentTypes = await _equipmentTypeRepository.getAll();
      final muscleGroups = await _muscleGroupRepository.getAll();

      setState(() {
        _exerciseTypes = exerciseTypes;
        _equipmentTypes = equipmentTypes;
        _muscleGroups = muscleGroups;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading catalogs: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveExercise() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedMuscleGroupId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a muscle group'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final exercise = Exercise(
        name: _exerciseName!,
        exerciseTypeId: _selectedExerciseTypeId!,
        equipmentTypeId: _selectedEquipmentTypeId!,
        muscleGroupId: _selectedMuscleGroupId!,
        defaultWorkingWeight: _defaultWeight,
        isUsingMetric: _isUsingMetric,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _exerciseRepository.create(exercise);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Exercise created successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error saving exercise: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating exercise: $e'),
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
          'New Exercise',
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

                      // Exercise Name Field (Always visible)
                      _buildSectionTitle('Exercise Name'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _exerciseNameController,
                        decoration: InputDecoration(
                          hintText: 'Enter exercise name',
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
                            return 'Please enter an exercise name';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _exerciseName = value.trim().isNotEmpty ? value.trim() : null;
                          });
                        },
                      ),

                      // Exercise Type Dropdown (Appears after name is filled)
                      if (_exerciseName != null) ...[
                        const SizedBox(height: 24),
                        _buildSectionTitle('Exercise Type'),
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
                          hint: const Text('Select exercise type'),
                          items: _exerciseTypes.map((type) {
                            return DropdownMenuItem<int>(
                              value: type.id!,
                              child: Text(type.name),
                            );
                          }).toList(),
                          validator: (value) {
                            if (value == null) {
                              return 'Please select an exercise type';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _selectedExerciseTypeId = value;
                            });
                          },
                        ),
                      ],

                      // Equipment Type Dropdown (Appears after exercise type is selected)
                      if (_selectedExerciseTypeId != null) ...[
                        const SizedBox(height: 24),
                        _buildSectionTitle('Equipment Type'),
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
                          hint: const Text('Select equipment type'),
                          items: _equipmentTypes.map((type) {
                            return DropdownMenuItem<int>(
                              value: type.id!,
                              child: Text(type.name),
                            );
                          }).toList(),
                          validator: (value) {
                            if (value == null) {
                              return 'Please select an equipment type';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _selectedEquipmentTypeId = value;
                            });
                          },
                        ),
                      ],

                      // Muscle Group Dropdown (Appears after equipment type is selected)
                      if (_selectedEquipmentTypeId != null) ...[
                        const SizedBox(height: 24),
                        _buildSectionTitle('Muscle Group'),
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
                          hint: const Text('Select muscle group'),
                          items: _muscleGroups.map((group) {
                            return DropdownMenuItem<int>(
                              value: group.id!,
                              child: Text(group.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedMuscleGroupId = value;
                            });
                          },
                        ),
                      ],

                      // Default Weight Field (Appears after muscle group is selected)
                      if (_selectedMuscleGroupId != null) ...[
                        const SizedBox(height: 24),
                        _buildSectionTitle('Default Working Weight (Optional)'),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _defaultWeightController,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                                ],
                                decoration: InputDecoration(
                                  hintText: 'Enter weight',
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
                                onChanged: (value) {
                                  setState(() {
                                    _defaultWeight = double.tryParse(value);
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Radio<bool>(
                                      value: true,
                                      groupValue: _isUsingMetric,
                                      activeColor: AppColors.primary,
                                      onChanged: (value) {
                                        setState(() {
                                          _isUsingMetric = value!;
                                        });
                                      },
                                    ),
                                    const Text('kg'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Radio<bool>(
                                      value: false,
                                      groupValue: _isUsingMetric,
                                      activeColor: AppColors.primary,
                                      onChanged: (value) {
                                        setState(() {
                                          _isUsingMetric = value!;
                                        });
                                      },
                                    ),
                                    const Text('lbs'),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Save Button
                        ElevatedButton(
                          onPressed: _isSaving ? null : _saveExercise,
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
                                  'Save Exercise',
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

