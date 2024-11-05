import '../../config/app_config.dart';
import '../response.dart';

class Transaction {
  final String category;
  final String? color;
  final String title;
  final bool income;
  final double value;
  final String startDate;
  final String endDate;
  final String frequency;
  final String? status;
  final String? createAt;
  final String? updateAt;
  final int id;

  Transaction(
      {required this.income,
      required this.value,
      required this.category,
      this.createAt,
      required this.startDate,
      required this.endDate,
      required this.frequency,
      required this.id,
      required this.title,
      this.updateAt,
      this.color,
      this.status});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      category: json['category'],
      createAt: json['createAt'],
      endDate: json['end_date'],
      startDate: json['start_date'],
      status: json['status'],
      frequency: json['frequency'],
      id: json['id'],
      title: json['title'],
      updateAt: json['updateAt'],
      color: json['color'],
      income: json['income'],
      value: json['value'] is int ? json['value'].toDouble() : double.parse(json['value']),
    );
  }
}

class CreateTransactionRuleRequest {
  final int userID = AppConfig.user!.id;
  final int categoryID;
  final String startDate;
  final String endDate;
  final String frequency;
  final bool income;
  final double value;
  final String title;

  CreateTransactionRuleRequest(
      {required this.title,
      required this.categoryID,
      required this.value,
      required this.income,
      required this.frequency,
      required this.startDate,
      required this.endDate});
}

class UpdateTransactionRuleRequest {
  final int categoryID;
  final double value;
  final String title;

  UpdateTransactionRuleRequest(
      {required this.value, required this.categoryID, required this.title});
}

class TransactionResponse extends DefaultResponse {
  Transaction? transaction;

  TransactionResponse({
    this.transaction,
    required super.message,
  });

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    return TransactionResponse(
      transaction: Transaction?.fromJson(json['data']),
      message: json['message'],
    );
  }
}
