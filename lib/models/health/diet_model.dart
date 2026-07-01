import '../../config/app_config.dart';
import '../response.dart';

class Meal {
  final int id;
  final String? createAt;
  final String? updateAt;
  final String name;
  final String hour;
  final List<Food>? foods;

  Meal(
      {required this.id,
      this.createAt,
      this.updateAt,
      required this.name,
      required this.hour,
      this.foods});

  factory Meal.fromJson(Map<String, dynamic> json) {
    List<Food> foodsList = [];
    if(json['foods'] != null) {
      var foodsFromJson = json['foods'] as List;
      foodsList = foodsFromJson
          .map((exercise) => Food.fromJson(exercise))
          .toList();
    }
    return Meal(
        createAt: json['createAt'],
        id: json['id'],
        name: json['name'],
        hour: json['hour'],
        updateAt: json['updateAt'],
        foods: foodsList);
  }
}

class Food {
  final int id;
  final String name;
  final String img;
  late int? quantity;
  late String? observation;


  Food({
    required this.id,
    required this.name,
    required this.img,
    this.quantity = 0,
    this.observation
  });


  Map<String, dynamic> toJson() {
    return {
      'food_id': id,
      'quantity': quantity,
      'name': name,
      'observation': observation,
      'image_url': img,
    };
  }

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['tag_id'],
      name: json['food_name'],
      img: json['photo']['thumb'],
      quantity: json['quantity'],
      observation: json['observation'],
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
  final String hour;
  final List<Food> foods;
  final int userID = AppConfig.user!.id;

  CreateMealRequest({required this.name, required this.hour,  required this.foods});
}

class UpdateMealRequest {
  final String name;
  final List<Food> foods;
  final String hour;

  UpdateMealRequest({required this.name, required this.hour, required this.foods});
}
