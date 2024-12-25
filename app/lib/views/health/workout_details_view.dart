import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:routine/widgets/html_text.dart';
import '../../../models/health/workout_model.dart';

class WorkoutDetailView extends StatelessWidget {
  final Workout workout;

  const WorkoutDetailView({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(workout.name),
      ),
      body: ListView.builder(
        itemCount: workout.exercises.length,
        itemBuilder: (context, index) {
          var exercise = workout.exercises[index];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text(
                exercise.name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${exercise.bodyPart?.toLowerCase()}'.tr()),
                      Text('${exercise.series}x${exercise.repetitions}'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('${exercise.load} kg'),
                  const SizedBox(height: 4),
                  Text(exercise.notes ?? ''),
                ],
              ),
              onTap: () {
                _showExerciseDetails(context, exercise);
              },
            ),
          );
        },
      ),
    );
  }

  void _showExerciseDetails(BuildContext context, Exercise exercise) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width * 1,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      exercise.name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 16),
                    if (exercise.imageUrl != null)
                      Image.network(exercise.imageUrl!),
                    const SizedBox(height: 16),
                    Text(
                      'instructions'.tr(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    HtmlText(html: exercise.instructions),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('close'.tr()),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }
}
