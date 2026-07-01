import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../config/design_system.dart';
import '../../config/helper.dart';
import '../../models/health/workout_model.dart';
import '../../widgets/custom_appbar.dart';
import '../../view_models/workout_viewmodel.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import 'health_view.dart';
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
      appBar: CustomAppBar(
        title: widget.id == null ? 'newWorkout' : 'editWorkout',
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
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'exercises'.tr(),
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: () => _openExerciseModal(context),
                      icon: const Icon(Icons.add),
                      label: Text('addExercise'.tr()),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _selectedExercises.isEmpty
                    ? _WorkoutEmptyState(message: 'noData'.tr())
                    : ReorderableListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        onReorderItem: (oldIndex, newIndex) {
                          setState(() {
                            final exercise =
                                _selectedExercises.removeAt(oldIndex);
                            _selectedExercises.insert(newIndex, exercise);
                          });
                        },
                        children:
                            _selectedExercises.asMap().entries.map((entry) {
                          Exercise exercise = entry.value;

                          return Container(
                            key: ValueKey(exercise),
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceVariant,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '${entry.key + 1}',
                                        style: const TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        exercise.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w800,
                                            ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline),
                                      color: AppColors.error,
                                      onPressed: () =>
                                          _removeExercise(exercise),
                                      tooltip: 'delete'.tr(),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                LayoutBuilder(
                                  builder: (context, constraints) {
                                    final fieldWidth =
                                        (constraints.maxWidth - 16) / 3;
                                    final compact = constraints.maxWidth < 360;
                                    return Wrap(
                                      spacing: 8,
                                      runSpacing: 10,
                                      children: [
                                        SizedBox(
                                          width: compact
                                              ? constraints.maxWidth
                                              : fieldWidth,
                                          child: CustomTextField(
                                            initialValue:
                                                exercise.load?.toString(),
                                            labelText: 'kg',
                                            keyboardType: TextInputType.number,
                                            onChanged: (value) {
                                              exercise.load =
                                                  int.tryParse(value) ?? 0;
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: compact
                                              ? constraints.maxWidth
                                              : fieldWidth,
                                          child: CustomTextField(
                                            initialValue:
                                                exercise.series?.toString(),
                                            labelText: 'series',
                                            keyboardType: TextInputType.number,
                                            onChanged: (value) {
                                              exercise.series =
                                                  int.tryParse(value) ?? 0;
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: compact
                                              ? constraints.maxWidth
                                              : fieldWidth,
                                          child: CustomTextField(
                                            initialValue: exercise.repetitions
                                                ?.toString(),
                                            labelText: 'repetitions',
                                            keyboardType: TextInputType.number,
                                            onChanged: (value) {
                                              exercise.repetitions =
                                                  int.tryParse(value) ?? 0;
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                const SizedBox(height: 10),
                                CustomTextField(
                                  initialValue: exercise.notes,
                                  labelText: 'notes',
                                  onChanged: (value) {
                                    exercise.notes = value;
                                  },
                                ),
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

class _WorkoutEmptyState extends StatelessWidget {
  final String message;

  const _WorkoutEmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(Icons.fitness_center_outlined, color: AppColors.muted),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}
