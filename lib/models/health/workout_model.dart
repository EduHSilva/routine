import '../../config/app_config.dart';
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
    List<Exercise> exerciseList = exercisesFromJson
        .map((exercise) => Exercise.fromJson(exercise))
        .toList();
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
  late int? load;
  late int? series;
  late int? repetitions;
  final int? restSeconds;
  final String? imageUrl;
  late String? notes;
  final String? target;

  Exercise({
    required this.id,
    required this.name,
    this.bodyPart,
    required this.instructions,
    this.load,
    this.restSeconds,
    this.series,
    this.repetitions,
    this.imageUrl,
    this.notes,
    this.target
  });

  Map<String, dynamic> toJson() {
    return {
      'exercise_id': id,
      'repetitions': repetitions,
      'series': series,
      'load': load,
      'rest_seconds': restSeconds,
      'notes': notes,
    };
  }

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
        imageUrl: json['image_url'],
        notes: json['notes'],
        target: json['target']);
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

class CreateWorkoutRequest {
  final String name;
  final List<Exercise> exercises;
  final int userID = AppConfig.user!.id;

  CreateWorkoutRequest({required this.name, required this.exercises});
}

class UpdateWorkoutRequest {
  final String name;
  final List<Exercise> exercises;

  UpdateWorkoutRequest({required this.name, required this.exercises});
}
