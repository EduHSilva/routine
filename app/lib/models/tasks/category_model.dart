import '../../config/app_config.dart';
import '../response.dart';

class Category {
  final int id;
  final String? createAt;
  final String? deletedAt;
  final String? updateAt;
  String title;
  String color;
  bool system;
  final String type;

  Category(
      {required this.id,
      this.createAt,
      this.deletedAt,
      this.updateAt,
      required this.title,
      required this.color,
      required this.type,
      this.system = false});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      createAt: json['createAt'],
      deletedAt: json['deletedAt'],
      updateAt: json['updateAt'],
      title: json['title'],
      color: json['color'],
      system: json['system'],
      type: json['type']
    );
  }
}

class CategoryResponse extends DefaultResponse {
  Category? category;

  CategoryResponse({
    this.category,
    required super.message,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      category: Category?.fromJson(json['data']),
      message: json['message'],
    );
  }
}

class CreateCategoryRequest {
  final String title;
  final String color;
  final int userID = AppConfig.user!.id;
  final int? id;
  final String type;

  CreateCategoryRequest(
      {this.id, required this.type, required this.title, required this.color});
}
