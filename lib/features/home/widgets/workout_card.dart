import 'package:flutter/material.dart';
import 'package:wo_tracker/generated/l10n/app_localizations.dart';
import '../../../core/themes/app_colors.dart';
import '../../workout/models/workout_session.dart';
import 'package:intl/intl.dart';

class WorkoutCard extends StatelessWidget {
  final WorkoutSession workout;
  final VoidCallback onDetailsPressed;
  const WorkoutCard({
    Key? key,
    required this.workout,
    required this.onDetailsPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workout.title ?? 'Workout',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  workout.startTime != null
                      ? DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(workout.startTime!)
                      : (workout.endTime != null
                          ? DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(workout.endTime!)
                          : l10n.notStarted),
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onDetailsPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(l10n.details),
          ),
        ],
      ),
    );
  }
}
