import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../config/design_system.dart';
import '../../../config/helper.dart';
import '../../../config/pdf.dart';
import '../../../models/health/workout_model.dart';
import '../../../view_models/workout_viewmodel.dart';
import '../../../widgets/custom_modal_delete.dart';
import '../new_workout_view.dart';
import '../workout_details_view.dart';

class WorkoutTab extends StatefulWidget {
  const WorkoutTab({super.key});

  @override
  WorkoutTabState createState() => WorkoutTabState();
}

class WorkoutTabState extends State<WorkoutTab> {
  final WorkoutViewModel _workoutViewModel = WorkoutViewModel();

  @override
  void initState() {
    super.initState();
    _workoutViewModel.fetchWorkouts();
  }

  _deleteWorkout(int id) async {
    WorkoutResponse? response = await _workoutViewModel.deleteWorkout(id);
    _handlerResponse(response);
  }

  _deleteWorkoutDialog(Workout workout) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomModalDelete(
          title: "confirmDelete",
          onConfirm: () {
            _deleteWorkout(workout.id);
          },
        );
      },
    );
  }

  _handlerResponse(WorkoutResponse? response) {
    if (response?.workout != null) {
      _workoutViewModel.fetchWorkouts();
    } else {
      if (!mounted) return;
      showErrorBar(context, response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _workoutViewModel.isLoading,
      builder: (context, isLoading, child) {
        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return ValueListenableBuilder<List<Workout>>(
          valueListenable: _workoutViewModel.workouts,
          builder: (context, workouts, child) {
            return Scaffold(
              appBar: AppBar(
                title: Text('workout'.tr()),
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () async {
                      await generateAndShareWorkoutPDF(
                          _workoutViewModel.workouts.value);
                    },
                  ),
                ],
              ),
              body: workouts.isEmpty
                  ? Center(child: Text('noData'.tr()))
                  : ListView.builder(
                      itemCount: workouts.length,
                      itemBuilder: (context, index) {
                        Workout workout = workouts[index];

                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(
                              workout.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              '${workout.exercises.length} ${'exercises'.tr()}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: AppColors.primary,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            NewWorkoutView(id: workout.id),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: AppColors.error,
                                  ),
                                  onPressed: () {
                                    _deleteWorkoutDialog(workout);
                                  },
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      WorkoutDetailView(workout: workout),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NewWorkoutView(),
                    ),
                  );
                },
                child: const Icon(Icons.add),
              ),
            );
          },
        );
      },
    );
  }
}
