import 'package:routine/models/health/workout_model.dart';
import 'package:routine/view_models/workout_viewmodel.dart';
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
        _selectedExercises = response.workout!.exercises;
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
        return ExerciseModal(
          onSelected: (selectedExercises) {
            setState(() {
              _selectedExercises = selectedExercises;
            });
          },
          selectedExercises: _selectedExercises,
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
        title: widget.id == null
            ? Text('newWorkout'.tr())
            : Text('editWorkout'.tr()),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  controller: _nameController,
                  labelText: 'name',
                  validator: requiredFieldValidator,
                ),
                const SizedBox(height: 16),
                CustomButton(
                  onPressed: () => _openExerciseModal(context),
                  text: 'addExercise',
                  isOutlined: true,
                ),
                const SizedBox(height: 16),
                _selectedExercises.isEmpty
                    ? Center(child: Text('noData'.tr()))
                    : ReorderableListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        onReorder: (oldIndex, newIndex) {
                          setState(() {
                            if (newIndex > oldIndex) {
                              newIndex -= 1;
                            }
                            final exercise =
                                _selectedExercises.removeAt(oldIndex);
                            _selectedExercises.insert(newIndex, exercise);
                          });
                        },
                        children:
                            _selectedExercises.asMap().entries.map((entry) {
                          Exercise exercise = entry.value;

                          return Padding(
                            key: ValueKey(exercise),
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        exercise.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
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
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextField(
                                        initialValue: exercise.load?.toString(),
                                        labelText: 'kg',
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          exercise.load =
                                              int.tryParse(value) ?? 0;
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: CustomTextField(
                                        initialValue:
                                            exercise.series?.toString(),
                                        labelText: 'sets',
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          exercise.series =
                                              int.tryParse(value) ?? 0;
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: CustomTextField(
                                        initialValue:
                                            exercise.repetitions?.toString(),
                                        labelText: 'reps',
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          exercise.repetitions =
                                              int.tryParse(value) ?? 0;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                CustomTextField(
                                  initialValue: exercise.notes,
                                  labelText: 'notes',
                                  onChanged: (value) {
                                    exercise.notes = value;
                                  },
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          );
                        }).toList(),
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
      ),
    );
  }
}
