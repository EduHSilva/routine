import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:routine/models/finances/finances_model.dart';

import '../config/app_config.dart';


class FinancesService {
  Future<MonthData?> fetchMonthData(String month, int year) async {
    http.Client client = await AppConfig.getHttpClient();
    final response =
    await client.get(Uri.parse('${AppConfig.apiUrl}finances?month=$month&year=$year'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);


      if (data['data'] != null) {
        return MonthData.fromJson(data['data']);
      }

      return null;
    } else {
      throw Exception('Failed to load finances rules');
    }
  }

  Future<List<Transaction>> fetchFinancesRules() async {
    http.Client client = await AppConfig.getHttpClient();
    final response =
        await client.get(Uri.parse('${AppConfig.apiUrl}finances/rules'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      List<Transaction> transactions = [];

      if (data['data'] != null) {
        transactions =
            List<Transaction>.from(data['data'].map((t) => Transaction.fromJson(t)));
      }

      return transactions;
    } else {
      throw Exception('Failed to load finances rules');
    }
  }

  Future<TransactionResponse?> addRule(CreateTransactionRuleRequest createRequest) async {
    final String apiUrl = '${AppConfig.apiUrl}finances/rule';
    http.Client client = await AppConfig.getHttpClient();

    try {
      final response = await client.post(
        Uri.parse(apiUrl),
        body: jsonEncode(<String, dynamic>{
          "category_id": createRequest.categoryID,
          "end_date": formatDate(createRequest.endDate),
          "start_date": formatDate(createRequest.startDate),
          "frequency": createRequest.frequency,
          "value": createRequest.value,
          "income": createRequest.income,
          "title": createRequest.title,
          "user_id": createRequest.userID
        }),
      );


      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        return TransactionResponse.fromJson(jsonResponse);
      } else {
        return TransactionResponse(message: jsonResponse['message']);
      }
    } catch (e) {
      AppConfig.getLogger().e(e);
      return null;
    }
  }

  Future<TransactionResponse> getTransactionRule(int id) async {
    http.Client client = await AppConfig.getHttpClient();
    final response =
        await client.get(Uri.parse('${AppConfig.apiUrl}finances/rule?id=$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      TransactionResponse? transactionResponse = TransactionResponse.fromJson(jsonResponse);

      return transactionResponse;
    } else {
      throw Exception('Failed to load transaction rule');
    }
  }

  Future<TransactionResponse?> editTransactionRule(int id, UpdateTransactionRuleRequest request) async {
    final String apiUrl = '${AppConfig.apiUrl}finances/rule';
    http.Client client = await AppConfig.getHttpClient();

    try {
      final response = await client.put(Uri.parse("$apiUrl?id=$id"),
          body: jsonEncode(<String, dynamic>{
            'title': request.title,
            'value': request.value,
            'category_id': request.categoryID,
          }));

      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        return TransactionResponse.fromJson(jsonResponse);
      } else {
        return TransactionResponse(message: jsonResponse['message']);
      }
    } catch (e) {
      AppConfig.getLogger().e(e);
      return null;
    }
  }

  Future<TransactionResponse?> deleteTransactionRule(int id) async {
    final String apiUrl = '${AppConfig.apiUrl}finances/rule';
    http.Client client = await AppConfig.getHttpClient();

    try {
      final response = await client.delete(Uri.parse("$apiUrl?id=$id"));

      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        return TransactionResponse.fromJson(jsonResponse);
      } else {
        return TransactionResponse(message: jsonResponse['message']);
      }
    } catch (e) {
      AppConfig.getLogger().e(e);
      return null;
    }
  }

  String formatDate(String date) {
    return DateTime.parse(date).toUtc().toIso8601String();
  }

  Future<TransactionResponse?> changeTransactionStatus(int id) async {
    final String apiUrl = '${AppConfig.apiUrl}finances';
    http.Client client = await AppConfig.getHttpClient();

    try {
      final response = await client.put(Uri.parse("$apiUrl?id=$id"));

      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        return TransactionResponse.fromJson(jsonResponse);
      } else {
        return TransactionResponse(message: jsonResponse['message']);
      }
    } catch (e) {
      AppConfig.getLogger().e(e);
      return null;
    }
  }
}
