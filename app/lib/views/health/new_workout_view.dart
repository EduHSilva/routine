import 'package:routine/config/design_system.dart';
import 'package:routine/models/health/workout_model.dart';
import 'package:routine/viewmodels/workout_viewmodel.dart';
import 'package:routine/views/health/health_view.dart';
import 'package:routine/widgets/custom_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../config/helper.dart';
import '../../widgets/custom_text_field.dart';
import 'modals/exercise_modal.dart';

class NewWorkoutView extends StatefulWidget {
  final int? id;

  const NewWorkoutView({super.key, this.id});

  @override
  NewWorkoutViewState createState() => NewWorkoutViewState();
}

class NewWorkoutViewState extends State<NewWorkoutView> {
  final _formKey = GlobalKey<FormState>();
  final WorkoutViewModel _workoutViewModel = WorkoutViewModel();
  final TextEditingController _nameController = TextEditingController();

  List<Exercise> _selectedExercises = [];

  @override
  initState() {
    super.initState();
    if (widget.id != null) {
      _loadWorkoutData(widget.id!);
    }
  }

  _loadWorkoutData(int id) async {
    WorkoutResponse? response = await _workoutViewModel.getWorkout(id);

    if (response?.workout != null) {
      setState(() {
        _nameController.text = response!.workout!.name;
        _selectedExercises = response.workout!.exercises ?? [];
      });
    }
  }

  _handlerResponse(WorkoutResponse? response) {
    if (response?.workout != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HealthView(),
        ),
      );
    } else {
      if (!mounted) return;
      showErrorBar(context, response);
    }
  }

  _addWorkout() async {
    if (_formKey.currentState!.validate()) {
      WorkoutResponse? response;
      if (widget.id == null) {
        response = await _workoutViewModel.addWorkout(CreateWorkoutRequest(
          name: _nameController.text,
          exercises: _selectedExercises,
        ));
      } else {
        response = await _workoutViewModel.editWorkout(
          widget.id!,
          UpdateWorkoutRequest(
            name: _nameController.text,
            exercises: _selectedExercises,
          ),
        );
      }
      _handlerResponse(response);
    }
  }

  void _openExerciseModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: ExerciseModal(
                onSelected: (selectedExercises) {
                  setState(() {
                    _selectedExercises = selectedExercises;
                  });
                },
                selectedExercises: _selectedExercises,
              ),
            );
          },
        );
      },
    );
  }

  void _removeExercise(Exercise exercise) {
    setState(() {
      _selectedExercises.remove(exercise);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.id == null ? Text('add'.tr()) : Text('edit'.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 16),
              Text(
                widget.id == null ? 'newWorkout'.tr() : 'editWorkout',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                controller: _nameController,
                labelText: 'name',
                validator: requiredFieldValidator,
              ),
              const SizedBox(height: 24),

              // Botão de adicionar exercícios
              CustomButton(
                onPressed: () => _openExerciseModal(context),
                text: 'addExercise',
                isOutlined: true,
              ),
              const SizedBox(height: 16),

              Expanded(
                child: _selectedExercises.isEmpty
                    ? Center(child: Text('noData'.tr()))
                    : ListView.builder(
                        itemCount: _selectedExercises.length,
                        itemBuilder: (context, index) {
                          var exercise = _selectedExercises[index];

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        exercise.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.remove,
                                            color: Colors.redAccent),
                                        onPressed: () =>
                                            _removeExercise(exercise),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${exercise.bodyPart?.toLowerCase()}'.tr(),
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Icon(Icons.fitness_center,
                                                color: AppColors.primary),
                                            const SizedBox(height: 4),
                                            CustomTextField(
                                              labelText: 'load'.tr(),
                                              initialValue:
                                                  exercise.load?.toString(),
                                              keyboardType:
                                                  TextInputType.number,
                                              onChanged: (value) {
                                                setState(() {
                                                  exercise.load =
                                                      int.tryParse(value) ?? 0;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Icon(Icons.repeat_one,
                                                color: AppColors.primary),
                                            const SizedBox(height: 4),
                                            CustomTextField(
                                              labelText: 'series'.tr(),
                                              initialValue: exercise.series?.toString(),
                                              keyboardType:
                                                  TextInputType.number,
                                              onChanged: (value) {
                                                setState(() {
                                                  exercise.series =
                                                      int.tryParse(value) ?? 0;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Icon(Icons.repeat,
                                                color: AppColors.primary),
                                            const SizedBox(height: 4),
                                            CustomTextField(
                                              labelText: 'repetitions'.tr(),
                                              initialValue: exercise.repetitions
                                                  ?.toString(),
                                              keyboardType:
                                                  TextInputType.number,
                                              onChanged: (value) {
                                                setState(() {
                                                  exercise.repetitions =
                                                      int.tryParse(value) ?? 0;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),

              const SizedBox(height: 16),
              CustomButton(
                onPressed: _addWorkout,
                text: 'save',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
