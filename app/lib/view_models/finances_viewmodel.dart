import 'package:flutter/cupertino.dart';
import '../config/app_config.dart';
import '../models/finances/finances_model.dart';
import '../models/response.dart';
import '../services/finances_service.dart';

class FinancesViewmodel {
  final FinancesService _financesService = FinancesService();
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<String?> errorMessage = ValueNotifier(null);
  ValueNotifier<List<Transaction>> rules = ValueNotifier([]);
  ValueNotifier<MonthData?> monthData = ValueNotifier(null);

  Future<void> fetchMonthData(String month, int year) async {
    monthData.value = null;
    try {
      isLoading.value = true;
      MonthData? response = await _financesService.fetchMonthData(month, year);
      monthData.value = response;
    } catch (e) {
      errorMessage.value = "Error fetching month data";
      AppConfig.getLogger().e(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<TransactionResponse?> deleteRule(int id) async {
    try {
      isLoading.value = true;
      TransactionResponse? response =
          await _financesService.deleteTransactionRule(id);
      if (response?.transaction != null) {
        await fetchFinancesRules();
      } else {
        errorMessage.value = response?.message;
      }
      return response;
    } catch (e) {
      AppConfig.getLogger().e(e);
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  Future<TransactionResponse?> deleteTransaction(int? id) async {
    try {
      if (id == null) return null;
      isLoading.value = true;
      TransactionResponse? response =
          await _financesService.deleteTransactionRule(id);
      if (response?.transaction == null) {
        errorMessage.value = response?.message;
      }
      return response;
    } catch (e) {
      AppConfig.getLogger().e(e);
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  Future<void> fetchFinancesRules() async {
    rules.value = [];
    try {
      isLoading.value = true;
      List<Transaction> response = await _financesService.fetchFinancesRules();
      rules.value = response;
    } catch (e) {
      errorMessage.value = "Error fetching rules";
      AppConfig.getLogger().e(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<TransactionResponse?>? addRule(
      CreateTransactionRuleRequest req) async {
    try {
      isLoading.value = true;
      TransactionResponse? response = await _financesService.addRule(req);

      if (response?.transaction != null) {
        await fetchFinancesRules();
        return response;
      } else {
        errorMessage.value = response?.message;
      }
    } catch (e) {
      errorMessage.value = "Error on add transaction rule";
      AppConfig.getLogger().e(e);
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  Future<TransactionResponse?> getTransaction(int id) async {
    try {
      isLoading.value = true;

      TransactionResponse? response =
          await _financesService.getTransactionRule(id);

      if (response.transaction == null) {
        errorMessage.value = response.message;
      }

      return response;
    } catch (e) {
      AppConfig.getLogger().e(e);
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  Future<TransactionResponse?> editRule(
      int id, UpdateTransactionRuleRequest request) async {
    try {
      isLoading.value = true;
      TransactionResponse? response =
          await _financesService.editTransactionRule(id, request);
      if (response?.transaction != null) {
        await fetchFinancesRules();
      } else {
        errorMessage.value = errorMessage.value = response?.message;
      }
      return response;
    } catch (e) {
      AppConfig.getLogger().e(e);
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  Future<DefaultResponse?> changeTransactionStatus(Transaction t) async {
    try {
      isLoading.value = true;
      DefaultResponse? response =
          await _financesService.changeTransactionStatus(t.id);
      await fetchFinancesRules();
          return response;
    } catch (e) {
      AppConfig.getLogger().e(e);
    } finally {
      isLoading.value = false;
    }
    return null;
  }
}
