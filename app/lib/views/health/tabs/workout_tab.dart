import 'package:app/models/health/workout_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../config/design_system.dart';
import '../../../config/helper.dart';
import '../../../viewmodels/workout_viewmodel.dart';
import '../../../widgets/custom_modal_delete.dart';
import '../new_workout_view.dart';

class WorkoutTab extends StatefulWidget {
  const WorkoutTab({super.key});

  @override
  WorkoutTabState createState() => WorkoutTabState();
}

class WorkoutTabState extends State<WorkoutTab> {
  final WorkoutViewModel _workoutViewModel = WorkoutViewModel();
  final Map<int, bool> _expandedWorkout = {};

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
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NewWorkoutView(),
                        ),
                      );
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
                        List<Exercise> exercises = workout.exercises;

                        _expandedWorkout.putIfAbsent(workout.id, () => false);

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _expandedWorkout[workout.id] =
                                        !_expandedWorkout[workout.id]!;
                                  });
                                },
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Nome do treino
                                        Expanded(
                                          child: Text(
                                            workout.name,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),

                                        // Ícone de edição
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            color: AppColors.primary,

                                            size: 24, //
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    NewWorkoutView(
                                                        id: workout.id),
                                              ),
                                            );
                                          },
                                        ),

                                        const SizedBox(width: 8),

                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: AppColors.error,
                                            size: 24,
                                          ),
                                          onPressed: () {
                                            _deleteWorkoutDialog(workout);
                                          },
                                        ),

                                        const SizedBox(width: 8),
                                        Icon(
                                          _expandedWorkout[workout.id]!
                                              ? Icons.expand_less
                                              : Icons.expand_more,
                                          size: 28,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    )),
                              ),
                              if (_expandedWorkout[workout.id]!)
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: exercises.length,
                                  itemBuilder: (context, exerciseIndex) {
                                    var exercise = exercises[exerciseIndex];

                                    return Card(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ListTile(
                                              title: Text(
                                                exercise.name.tr(),
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                          '${exercise.bodyPart?.toLowerCase()}'
                                                              .tr()),
                                                      Text(
                                                          '${exercise.series}x${exercise.repetitions}'),
                                                    ],
                                                  ),
                                                  Text('${exercise.load} kg'),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                            ],
                          ),
                        );
                      },
                    ),
            );
          },
        );
      },
    );
  }
}
