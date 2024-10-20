import 'dart:ffi';

import '../response.dart';

class Workout {
  final int id;
  final String? createAt;
  final String? updateAt;
  final String name;
  final List<Exercise> exercises;

  Workout(
      {required this.id,
      this.createAt,
      this.updateAt,
      required this.name,
      required this.exercises});

  factory Workout.fromJson(Map<String, dynamic> json) {
    var exercisesFromJson = json['exercises'] as List;
    List<Exercise> exerciseList = exercisesFromJson.map((exercise) => Exercise.fromJson(exercise)).toList();
    return Workout(
        createAt: json['createAt'],
        id: json['id'],
        name: json['name'],
        updateAt: json['updateAt'],
        exercises: exerciseList);
  }
}

class Exercise {
  final int id;
  final String name;
  final String? bodyPart;
  final String instructions;
  final int load;
  final int series;
  final int repetitions;
  final int restSeconds;

  Exercise({
    required this.id,
    required this.name,
    this.bodyPart,
    required this.instructions,
    required this.load,
    required this.restSeconds,
    required this.series,
    required this.repetitions,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'],
      bodyPart: json['body_part'],
      instructions: json['instructions'],
      load: json['load'],
      restSeconds: json['rest_seconds'],
      series: json['series'],
      repetitions: json['repetitions'],
    );
  }
}

class WorkoutResponse extends DefaultResponse {
  Workout? workout;

  WorkoutResponse({
    this.workout,
    required super.message,
  });

  factory WorkoutResponse.fromJson(Map<String, dynamic> json) {
    return WorkoutResponse(
      workout: Workout?.fromJson(json['data']),
      message: json['message'],
    );
  }
}
