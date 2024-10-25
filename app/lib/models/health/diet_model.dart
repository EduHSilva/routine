import '../../config/app_config.dart';
import '../response.dart';

class Meal {
  final int id;
  final String? createAt;
  final String? updateAt;
  final String name;
  final List<Food> foods;

  Meal(
      {required this.id,
      this.createAt,
      this.updateAt,
      required this.name,
      required this.foods});

  factory Meal.fromJson(Map<String, dynamic> json) {
    var foodsFromJson = json['exercises'] as List;
    List<Food> foodsList = foodsFromJson
        .map((exercise) => Food.fromJson(exercise))
        .toList();
    return Meal(
        createAt: json['createAt'],
        id: json['id'],
        name: json['name'],
        updateAt: json['updateAt'],
        foods: foodsList);
  }
}

class Food {
  final int id;
  final String name;
  final String img;


  Food({
    required this.id,
    required this.name,
    required this.img,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'img': img,
    };
  }

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['tag_id'],
      name: json['food_name'],
      img: json['photo']['thumb'],
    );
  }
}

class MealResponse extends DefaultResponse {
  Meal? meal;

  MealResponse({
    this.meal,
    required super.message,
  });

  factory MealResponse.fromJson(Map<String, dynamic> json) {
    return MealResponse(
      meal: Meal?.fromJson(json['data']),
      message: json['message'],
    );
  }
}

class CreateMealRequest {
  final String name;
  final List<Food> foods;
  final int userID = AppConfig.user!.id;

  CreateMealRequest({required this.name, required this.foods});
}

class UpdateMealRequest {
  final String name;
  final List<Food> foods;

  UpdateMealRequest({required this.name, required this.foods});
}
