import 'package:routine/widgets/custom_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../models/health/workout_model.dart';
import '../../../view_models/workout_viewmodel.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/filter_card.dart';

class ExerciseModal extends StatefulWidget {
  final List<Exercise> selectedExercises;
  final Function(List<Exercise>) onSelected;

  const ExerciseModal({super.key,
    required this.selectedExercises,
    required this.onSelected,
  });

  @override
  State<ExerciseModal> createState() => _ExerciseModalState();
}

class _ExerciseModalState extends State<ExerciseModal> {
  final WorkoutViewModel _workoutViewModel = WorkoutViewModel();
  final TextEditingController _searchController = TextEditingController();
  String _selectedBodyPart = 'All';
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _workoutViewModel.fetchExercises();
  }

  void _setBodyPartFilter(String bodyPart) {
    setState(() {
      _selectedBodyPart = bodyPart;
    });
  }

  void _setSearchFilter(String searchText) {
    setState(() {
      _searchText = searchText.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Exercise>>(
      valueListenable: _workoutViewModel.exercises,
      builder: (context, exercises, child) {
        List<Exercise> filteredExercises = exercises
            .where((exercise) =>
        (exercise.bodyPart == _selectedBodyPart || _selectedBodyPart == 'All') &&
            exercise.name.toLowerCase().contains(_searchText))
            .toList();

        return Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 35.0, 16.0, 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: _searchController,
                labelText: 'search',
                onChanged: _setSearchFilter,
              ),
              const SizedBox(height: 16),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ...[
                      {'value': 'All', 'label': 'all'},
                      {'value': 'waist', 'label': 'core'},
                      {'value': 'upper legs', 'label': 'legs'},
                      {'value': 'chest', 'label': 'chest'},
                      {'value': 'lower arms', 'label': 'lower arms'},
                      {'value': 'lower legs', 'label': 'lower legs'},
                    ].map((filter) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: _buildFilterCard(filter['value']!, filter['label']!),
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredExercises.length,
                  itemBuilder: (context, index) {
                    var exercise = filteredExercises[index];
                    bool isSelected = widget.selectedExercises.contains(exercise);

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(exercise.name),
                        subtitle: Text('${exercise.bodyPart?.toLowerCase()}'.tr()),
                        trailing: IconButton(
                          icon: Icon(isSelected ? Icons.remove : Icons.add),
                          onPressed: () {
                            setState(() {
                              if (isSelected) {
                                widget.selectedExercises.remove(exercise);
                              } else {
                                widget.selectedExercises.add(exercise);
                              }
                            });
                            widget.onSelected(widget.selectedExercises);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),

              CustomButton(
                onPressed: () => Navigator.pop(context),
                text: 'close'
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterCard(String value, String label) {
    return FilterCard(
      value: value,
      label: label,
      isSelected: _selectedBodyPart == value,
      onTap: _setBodyPartFilter,
    );
  }
}
