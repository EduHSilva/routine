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
  final bool confirmed;
  final String? createAt;
  final String? updateAt;
  final int id;
  final int? ruleID;
  final String? date;
  final bool saving;

  Transaction({required this.income,
    required this.value,
    required this.category,
    this.createAt,
    required this.startDate,
    required this.endDate,
    required this.frequency,
    required this.id,
    required this.title,
    this.updateAt,
    this.date,
    this.color,
    this.ruleID,
    required this.saving,
    this.confirmed = false});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      category: json['category'],
      createAt: json['createAt'],
      endDate: json['end_date'],
      startDate: json['start_date'],
      confirmed: json['confirmed'],
      frequency: json['frequency'],
      id: json['id'],
      title: json['title'],
      updateAt: json['updateAt'],
      color: json['color'],
      income: json['income'],
      date: json['date'],
      ruleID: json['rule_id'],
      saving: json['saving'],
      value: json['value'] is int
          ? json['value'].toDouble()
          : double.parse(json['value']),
    );
  }
}

class MonthData {
  final double totalIncomes;
  final double totalExpenses;
  final double prevExpenses;
  final double prevIncomes;
  final double prevTotal;
  final double currentBalance;
  final double saving;


  final List<Transaction> transactions;

  MonthData({required this.prevTotal,
    required this.totalExpenses,
    required this.totalIncomes,
    required this.prevExpenses,
    required this.prevIncomes,
    required this.currentBalance,
    required this.saving,
    required this.transactions});

  factory MonthData.fromJson(Map<String, dynamic> json) {
    List<Transaction> transactions = [];
    if (json['transactions'] != null) {
      var transactionsFromJson = json['transactions'] as List;
      transactions = transactionsFromJson
          .map((exercise) => Transaction.fromJson(exercise))
          .toList();
    }

    var resume = json['resume'] ?? {};
    return MonthData(
      totalExpenses: (resume['total_expenses'] ?? 0).toDouble(),
      totalIncomes: (resume['total_income'] ?? 0).toDouble(),
      prevTotal: (resume['prev_total_value'] ?? 0).toDouble(),
      prevExpenses: (resume['prev_total_expenses'] ?? 0).toDouble(),
      prevIncomes: (resume['prev_total_income'] ?? 0).toDouble(),
      currentBalance: (resume['current_balance'] ?? 0).toDouble(),
      saving: (resume['saving'] ?? 0).toDouble(),
      transactions: transactions,
    );
  }
}

class CreateTransactionRuleRequest {
  final int userID = AppConfig.user!.id;
  final int categoryID;
  final String? startDate;
  final String? endDate;
  final String frequency;
  final bool income;
  final double value;
  final String title;
  final bool saving;

  CreateTransactionRuleRequest({required this.title,
    required this.categoryID,
    required this.value,
    required this.income,
    required this.frequency,
    required this.saving,
    this.startDate,
    this.endDate});
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
