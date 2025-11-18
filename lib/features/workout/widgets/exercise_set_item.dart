import 'package:flutter/material.dart';
import '../../../core/themes/app_colors.dart';
import '../models/workout_set.dart';

class ExerciseSetItem extends StatefulWidget {
  final WorkoutSet set;
  final bool isEditable;
  final bool isUsingMetric;
  final Function(WorkoutSet) onSetUpdated;
  final Function(int, int)? onUpdateDefaultWeight; // (workoutExerciseId, setId)

  const ExerciseSetItem({
    Key? key,
    required this.set,
    required this.isEditable,
    this.isUsingMetric = true,
    required this.onSetUpdated,
    this.onUpdateDefaultWeight,
  }) : super(key: key);

  @override
  State<ExerciseSetItem> createState() => _ExerciseSetItemState();
}

class _ExerciseSetItemState extends State<ExerciseSetItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: widget.set.completed ? AppColors.primary : AppColors.divider,
          width: widget.set.completed ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          // Set number
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: widget.set.completed
                  ? AppColors.primary
                  : AppColors.cardBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                '${widget.set.setNumber}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: widget.set.completed
                      ? Colors.white
                      : AppColors.textPrimary,
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
                widget.isEditable
                    ? TextFormField(
                        initialValue: widget.set.reps?.toString() ?? '',
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 16),
                        decoration: const InputDecoration(
                          hintText: '0',
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          final reps = int.tryParse(value);
                          widget.onSetUpdated(
                            WorkoutSet(
                              id: widget.set.id,
                              workoutExerciseId: widget.set.workoutExerciseId,
                              setNumber: widget.set.setNumber,
                              reps: reps,
                              weight: widget.set.weight,
                              effortLevel: widget.set.effortLevel,
                              effortLevelSpecifier:
                                  widget.set.effortLevelSpecifier,
                              completed: widget.set.completed,
                              completedAt: widget.set.completedAt,
                              notes: widget.set.notes,
                            ),
                          );
                        },
                      )
                    : Text(
                        widget.set.reps?.toString() ?? '-',
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
                Text(
                  'Weight (${widget.isUsingMetric ? 'kg' : 'lbs'})',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                widget.isEditable
                    ? TextFormField(
                        key: ValueKey(
                          'weight-${widget.set.id}-${widget.set.weight}',
                        ), // Force rebuild when weight changes
                        initialValue: widget.set.weight?.toString() ?? '',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        style: const TextStyle(fontSize: 16),
                        decoration: const InputDecoration(
                          hintText: '0.0',
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          final weight = double.tryParse(value);
                          widget.onSetUpdated(
                            WorkoutSet(
                              id: widget.set.id,
                              workoutExerciseId: widget.set.workoutExerciseId,
                              setNumber: widget.set.setNumber,
                              reps: widget.set.reps,
                              weight: weight,
                              effortLevel: widget.set.effortLevel,
                              effortLevelSpecifier:
                                  widget.set.effortLevelSpecifier,
                              completed: widget.set.completed,
                              completedAt: widget.set.completedAt,
                              notes: widget.set.notes,
                            ),
                          );
                        },
                      )
                    : Text(
                        widget.set.weight?.toString() ?? '-',
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
          if (widget.isEditable)
            Checkbox(
              value: widget.set.completed,
              activeColor: AppColors.primary,
              onChanged: (value) {
                widget.onSetUpdated(
                  WorkoutSet(
                    id: widget.set.id,
                    workoutExerciseId: widget.set.workoutExerciseId,
                    setNumber: widget.set.setNumber,
                    reps: widget.set.reps,
                    weight: widget.set.weight,
                    effortLevel: widget.set.effortLevel,
                    effortLevelSpecifier: widget.set.effortLevelSpecifier,
                    completed: value ?? false,
                    completedAt: value == true ? DateTime.now() : null,
                    notes: widget.set.notes,
                  ),
                );
              },
            )
          else if (widget.set.completed)
            const Icon(Icons.check_circle, color: AppColors.success, size: 24),

          // Options menu button
          IconButton(
            icon: const Icon(Icons.more_vert),
            iconSize: 20,
            color: AppColors.textSecondary,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {
              _showSetOptionsMenu(context);
            },
          ),
        ],
      ),
    );
  }

  void _showSetOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.note_add, color: AppColors.primary),
                title: Text(
                  widget.isEditable ? 'Add Set Notes' : 'See Set Notes',
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showSetNotesDialog(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.fitness_center,
                  color: AppColors.primary,
                ),
                title: Text(
                  widget.isEditable ? 'Add Effort Level' : 'See Effort Level',
                ),
                onTap: () {
                  Navigator.pop(context);
                  if (widget.isEditable) {
                    _showEffortLevelDialog(context);
                  } else {
                    _showViewEffortLevelDialog(context);
                  }
                },
              ),
              if (widget.isEditable && widget.onUpdateDefaultWeight != null)
                ListTile(
                  leading: const Icon(Icons.update, color: AppColors.primary),
                  title: const Text('Update Exercise Default Weight'),
                  onTap: () {
                    Navigator.pop(context);
                    _showUpdateDefaultWeightDialog(context);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _showSetNotesDialog(BuildContext context) {
    if (!widget.isEditable &&
        (widget.set.notes == null || widget.set.notes!.isEmpty)) {
      // Viewing past session with no notes
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Set Notes'),
            content: const Text('No notes for this set.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
      return;
    }

    if (!widget.isEditable) {
      // Viewing past session - show notes
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Set Notes'),
            content: Text(
              widget.set.notes!,
              style: const TextStyle(fontSize: 14),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Editable - add/edit notes
    final TextEditingController notesController = TextEditingController(
      text: widget.set.notes ?? '',
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Set Notes'),
          content: TextField(
            controller: notesController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Add notes about this set...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                widget.onSetUpdated(
                  WorkoutSet(
                    id: widget.set.id,
                    workoutExerciseId: widget.set.workoutExerciseId,
                    setNumber: widget.set.setNumber,
                    reps: widget.set.reps,
                    weight: widget.set.weight,
                    effortLevel: widget.set.effortLevel,
                    effortLevelSpecifier: widget.set.effortLevelSpecifier,
                    completed: widget.set.completed,
                    completedAt: widget.set.completedAt,
                    notes: notesController.text,
                  ),
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Set notes saved!'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showEffortLevelDialog(BuildContext context) {
    String effortUnit = 'RPE'; // RPE or RIR
    int effortValue = widget.set.effortLevel ?? 7;
    String effortSpecifier = widget.set.effortLevelSpecifier ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Effort Level'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Effort Unit:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: const Text('RPE'),
                          value: 'RPE',
                          groupValue: effortUnit,
                          onChanged: (value) {
                            setState(() {
                              effortUnit = value!;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: const Text('RIR'),
                          value: 'RIR',
                          groupValue: effortUnit,
                          onChanged: (value) {
                            setState(() {
                              effortUnit = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Effort Value:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: effortValue.toDouble(),
                          min: 0,
                          max: 10,
                          divisions: 10,
                          label: effortValue.toString(),
                          onChanged: (value) {
                            setState(() {
                              effortValue = value.toInt();
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        child: Text(
                          effortValue.toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Closeness Specifier (optional):',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ChoiceChip(
                        label: const Text('<'),
                        selected: effortSpecifier == '<',
                        onSelected: (selected) {
                          setState(() {
                            effortSpecifier = selected ? '<' : '';
                          });
                        },
                      ),
                      ChoiceChip(
                        label: const Text('~'),
                        selected: effortSpecifier == '~',
                        onSelected: (selected) {
                          setState(() {
                            effortSpecifier = selected ? '~' : '';
                          });
                        },
                      ),
                      ChoiceChip(
                        label: const Text('>'),
                        selected: effortSpecifier == '>',
                        onSelected: (selected) {
                          setState(() {
                            effortSpecifier = selected ? '>' : '';
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Effort: ${effortSpecifier.isEmpty ? '' : effortSpecifier}$effortValue $effortUnit',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    widget.onSetUpdated(
                      WorkoutSet(
                        id: widget.set.id,
                        workoutExerciseId: widget.set.workoutExerciseId,
                        setNumber: widget.set.setNumber,
                        reps: widget.set.reps,
                        weight: widget.set.weight,
                        effortLevel: effortValue,
                        effortLevelSpecifier: effortSpecifier.isEmpty
                            ? effortUnit
                            : '$effortSpecifier$effortUnit',
                        completed: widget.set.completed,
                        completedAt: widget.set.completedAt,
                        notes: widget.set.notes,
                      ),
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Effort level saved!'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showViewEffortLevelDialog(BuildContext context) {
    if (widget.set.effortLevel == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Effort Level'),
            content: const Text('No effort level recorded for this set.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Parse the effort level specifier
    String displayText = '';
    if (widget.set.effortLevelSpecifier != null &&
        widget.set.effortLevelSpecifier!.isNotEmpty) {
      displayText = widget.set.effortLevelSpecifier!;
      // Check if it already includes the number
      if (!displayText.contains(widget.set.effortLevel.toString())) {
        // Insert the number before the unit (RPE/RIR)
        if (displayText.contains('RPE')) {
          displayText = displayText.replaceAll(
            'RPE',
            '${widget.set.effortLevel} RPE',
          );
        } else if (displayText.contains('RIR')) {
          displayText = displayText.replaceAll(
            'RIR',
            '${widget.set.effortLevel} RIR',
          );
        } else {
          displayText = '${widget.set.effortLevel} $displayText';
        }
      }
    } else {
      displayText = widget.set.effortLevel.toString();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Effort Level'),
          content: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.fitness_center,
                  size: 48,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 12),
                Text(
                  displayText,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showUpdateDefaultWeightDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Default Weight'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Mark this set\'s weight to update the exercise default weight when the workout is completed.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current Weight:',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.set.weight ?? 0} ${widget.isUsingMetric ? 'kg' : 'lbs'}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (widget.onUpdateDefaultWeight != null) {
                  widget.onUpdateDefaultWeight!(
                    widget.set.workoutExerciseId,
                    widget.set.id!,
                  );
                }
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Will update default weight on workout completion!',
                    ),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              child: const Text('Mark for Update'),
            ),
          ],
        );
      },
    );
  }
}
