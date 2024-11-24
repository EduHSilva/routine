
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
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
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16),
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
