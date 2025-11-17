import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/themes/app_colors.dart';
import '../view_models/home_view_model.dart';
import '../widgets/today_workout_card.dart';
import '../widgets/workout_card.dart';
import '../../workout/views/workout_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().loadHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Workouts',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          if (viewModel.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${viewModel.error}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => viewModel.loadHomeData(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () => viewModel.refresh(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Today's Workout Section
                  TodayWorkoutCard(
                    workout: viewModel.todayWorkout,
                    onTap: () {
                      if (viewModel.todayWorkout != null) {
                        _navigateToWorkoutDetails(
                          viewModel.todayWorkout!.id,
                          isEditable: true,
                        );
                      } else {
                        // Navigate to add workout screen
                        // TODO: Implement navigation to add workout
                      }
                    },
                  ),
                  const SizedBox(height: 24),

                  // Recent Workouts Section
                  _buildRecentWorkoutsSection(viewModel),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecentWorkoutsSection(HomeViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Workouts',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          if (viewModel.recentWorkouts.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(
                      Icons.history,
                      size: 48,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'No recent workouts',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...viewModel.recentWorkouts.map(
              (workout) => WorkoutCard(
                workout: workout,
                onDetailsPressed: () => _navigateToWorkoutDetails(workout.id),
              ),
            ),
          if (viewModel.recentWorkouts.isNotEmpty) ...[
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () {
                  // Navigate to history screen
                  // TODO: Implement navigation to history
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'More',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _navigateToWorkoutDetails(int? workoutId, {bool isEditable = false}) async {
    if (workoutId == null) return;

    // Navigate to workout detail screen
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutDetailScreen(
          sessionId: workoutId,
          isEditable: isEditable,
        ),
      ),
    );

    // Refresh home data when returning from workout detail
    if (mounted) {
      context.read<HomeViewModel>().loadHomeData();
    }
  }
}

