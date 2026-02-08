import 'package:flutter/material.dart';
import 'package:wo_tracker/generated/l10n/app_localizations.dart';
import '../../../core/themes/app_colors.dart';
import '../../exercise/repositories/exercise_type_repository.dart';
import '../../exercise/repositories/equipment_type_repository.dart';
import '../../exercise/repositories/muscle_group_repository.dart';
import '../../workout/repositories/workout_type_repository.dart';
import '../../exercise/models/exercise_type.dart';
import '../../exercise/models/equipment_type.dart';
import '../../exercise/models/muscle_group.dart';
import '../../workout/models/workout_type.dart';

class ManageCatalogsScreen extends StatefulWidget {
  const ManageCatalogsScreen({Key? key}) : super(key: key);

  @override
  State<ManageCatalogsScreen> createState() => _ManageCatalogsScreenState();
}

class _ManageCatalogsScreenState extends State<ManageCatalogsScreen> {
  final _exerciseTypeRepository = ExerciseTypeRepository();
  final _equipmentTypeRepository = EquipmentTypeRepository();
  final _muscleGroupRepository = MuscleGroupRepository();
  final _workoutTypeRepository = WorkoutTypeRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.manageCatalogs,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.manageYourCatalogs,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),

              // Exercise Type Card
              _CatalogCard(
              icon: Icons.category,
              iconColor: Colors.blue,
              title: AppLocalizations.of(context)!.exerciseTypes,
              description: AppLocalizations.of(context)!.exerciseTypesDesc,
              onTap: () => _showAddDialog(
                context,
                AppLocalizations.of(context)!.exerciseType,
                (name) async {
                  await _exerciseTypeRepository.create(ExerciseType(name: name));
                },
              ),
            ),
            const SizedBox(height: 12),

            // Equipment Type Card
            _CatalogCard(
              icon: Icons.fitness_center,
              iconColor: Colors.green,
              title: AppLocalizations.of(context)!.equipmentTypes,
              description: AppLocalizations.of(context)!.equipmentTypesDesc,
              onTap: () => _showAddDialog(
                context,
                AppLocalizations.of(context)!.equipment,
                (name) async {
                  await _equipmentTypeRepository.create(EquipmentType(name: name));
                },
              ),
            ),
            const SizedBox(height: 12),

            // Muscle Group Card
            _CatalogCard(
              icon: Icons.accessibility_new,
              iconColor: Colors.orange,
              title: AppLocalizations.of(context)!.muscleGroups,
              description: AppLocalizations.of(context)!.muscleGroupsDesc,
              onTap: () => _showAddDialog(
                context,
                AppLocalizations.of(context)!.muscleGroups,
                (name) async {
                  await _muscleGroupRepository.create(MuscleGroup(name: name));
                },
              ),
            ),
            const SizedBox(height: 12),

            // Workout Type Card
            _CatalogCard(
              icon: Icons.assignment,
              iconColor: Colors.purple,
              title: AppLocalizations.of(context)!.workoutTypes,
              description: AppLocalizations.of(context)!.workoutTypesDesc,
              onTap: () => _showAddDialog(
                context,
                AppLocalizations.of(context)!.workoutType,
                (name) async {
                  await _workoutTypeRepository.create(WorkoutType(name: name));
                },
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Future<void> _showAddDialog(
    BuildContext context,
    String catalogName,
    Future<void> Function(String) onSave,
  ) async {
    final nameController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.addCatalog(catalogName)),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.enterName,
                filled: true,
                fillColor: AppColors.background,
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
                  return AppLocalizations.of(context)!.pleaseEnterName;
                }
                return null;
              },
              autofocus: true,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  try {
                    await onSave(nameController.text.trim());
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppLocalizations.of(context)!.catalogAddedSuccessfully(catalogName)),
                          backgroundColor: AppColors.success,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppLocalizations.of(context)!.errorAddingCatalog(catalogName, e.toString())),
                          backgroundColor: AppColors.error,
                        ),
                      );
                    }
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: Text(AppLocalizations.of(context)!.add),
            ),
          ],
        );
      },
    );
  }
}

class _CatalogCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _CatalogCard({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            
            // Add icon
            const Icon(
              Icons.add_circle_outline,
              color: AppColors.primary,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

