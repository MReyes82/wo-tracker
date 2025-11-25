import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wo_tracker/generated/l10n/app_localizations.dart';
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
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.pleaseSelect(l10n.muscleGroups)),
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
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.exerciseSaved),
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
            content: Text(AppLocalizations.of(context)!.errorCreatingExercise(e.toString())),
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
          AppLocalizations.of(context)!.newExercise,
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

                      // Exercise Name Field (Always visible)
                      _buildSectionTitle(AppLocalizations.of(context)!.exerciseName),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _exerciseNameController,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.enterExerciseName,
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
                            return l10n.pleaseEnter(l10n.exerciseName);
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
                        _buildSectionTitle(AppLocalizations.of(context)!.exerciseType),
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
                          hint: Text(AppLocalizations.of(context)!.selectExerciseType),
                          items: _exerciseTypes.map((type) {
                            return DropdownMenuItem<int>(
                              value: type.id!,
                              child: Text(type.name),
                            );
                          }).toList(),
                          validator: (value) {
                            final l10n = AppLocalizations.of(context)!;
                            if (value == null) {
                              return l10n.pleaseSelect(l10n.exerciseType);
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
                        _buildSectionTitle(AppLocalizations.of(context)!.equipment),
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
                          hint: Text(AppLocalizations.of(context)!.selectEquipmentType),
                          items: _equipmentTypes.map((type) {
                            return DropdownMenuItem<int>(
                              value: type.id!,
                              child: Text(type.name),
                            );
                          }).toList(),
                          validator: (value) {
                            final l10n = AppLocalizations.of(context)!;
                            if (value == null) {
                              return l10n.pleaseSelect(l10n.equipment);
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
                        _buildSectionTitle(AppLocalizations.of(context)!.muscleGroups),
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
                          hint: Text(AppLocalizations.of(context)!.selectMuscleGroup),
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
                        _buildSectionTitle(AppLocalizations.of(context)!.defaultWorkingWeightOptional),
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
                                  hintText: AppLocalizations.of(context)!.enterWeight,
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
                              : Text(
                                  AppLocalizations.of(context)!.saveExercise,
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

