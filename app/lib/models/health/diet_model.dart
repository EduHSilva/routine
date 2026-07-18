import '../../config/app_config.dart';
import '../response.dart';

class Meal {
  final int id;
  final String? createAt;
  final String? updateAt;
  final String name;
  final String hour;
  final List<MealFood>? foods;

  Meal(
      {required this.id,
      this.createAt,
      this.updateAt,
      required this.name,
      required this.hour,
      this.foods});

  factory Meal.fromJson(Map<String, dynamic> json) {
    List<MealFood> foodsList = [];
    if (json['foods'] != null) {
      var foodsFromJson = json['foods'] as List;
      foodsList =
          foodsFromJson.map((exercise) => MealFood.fromJson(exercise)).toList();
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

class MealFood {
  int foodId;
  int quantity;
  String? observation;
  final String? foodName;

  MealFood({
    required this.foodId,
    required this.quantity,
    this.observation,
    this.foodName,
  });

  factory MealFood.fromJson(Map<String, dynamic> json) {
    final food = json['food'];
    final foodData = food is Map<String, dynamic> ? food : null;
    return MealFood(
      foodId: json['food_id'] ?? foodData?['id'] ?? 0,
      quantity: int.tryParse(json['quantity']?.toString() ?? '') ?? 1,
      observation: (json['obs'] ?? json['observation'])?.toString(),
      foodName: (foodData?['name'] ?? json['name'])?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'food_id': foodId,
        'quantity': quantity,
        'obs': observation ?? '',
      };
}

class Food {
  final int id;
  final String name;

  Food({required this.id, required this.name});

  Map<String, dynamic> toJson() {
    return {
      'food_id': id,
      'name': name,
    };
  }

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'],
      name: json['name'],
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
  final List<MealFood> foods;
  final String userID = AppConfig.user!.id;

  CreateMealRequest(
      {required this.name, required this.hour, required this.foods});

  Map<String, dynamic> toJson() => {
        'name': name,
        'hour': hour,
        'user_id': userID,
        'foods': foods.map((food) => food.toJson()).toList(),
      };
}

class UpdateMealRequest {
  final String name;
  final List<MealFood> foods;
  final String hour;

  UpdateMealRequest(
      {required this.name, required this.hour, required this.foods});

  Map<String, dynamic> toJson() => {
        'name': name,
        'hour': hour,
        'foods': foods.map((food) => food.toJson()).toList(),
      };
}
