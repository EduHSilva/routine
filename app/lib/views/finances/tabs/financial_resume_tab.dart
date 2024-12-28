import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:routine/config/helper.dart';
import 'package:routine/view_models/finances_viewmodel.dart';
import 'package:routine/widgets/custom_modal_delete.dart';
import 'package:routine/models/finances/finances_model.dart';

import '../modals/transaction_modal.dart';

class FinancialResumeTab extends StatefulWidget {
  const FinancialResumeTab({super.key});

  @override
  State<FinancialResumeTab> createState() => _FinancialResumeTabState();
}

class _FinancialResumeTabState extends State<FinancialResumeTab> {
  int _currentIndex = 0;
  final FinancesViewmodel _financesViewModel = FinancesViewmodel();
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    String formattedMonth = selectedDate.month.toString().padLeft(2, '0');
    await _financesViewModel.fetchMonthData(formattedMonth, selectedDate.year);
  }

  void _changeMonth(int offset) {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month + offset);
    });
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      DashboardScreen(
        financesViewModel: _financesViewModel,
        selectedDate: selectedDate,
        onChangeMonth: _changeMonth,
      ),
      TransactionsScreen(
        financesViewModel: _financesViewModel,
        selectedDate: selectedDate,
        onRefresh: _fetchData,
      ),
    ];

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'dashboard'.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'transactions'.tr(),
          ),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  final FinancesViewmodel financesViewModel;
  final DateTime selectedDate;
  final void Function(int offset) onChangeMonth;

  const DashboardScreen({
    required this.financesViewModel,
    required this.selectedDate,
    required this.onChangeMonth,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat.yMMMM('pt_BR').format(selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: Text(formattedDate),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_left),
          onPressed: () => onChangeMonth(-1),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_right),
            onPressed: () => onChangeMonth(1),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: financesViewModel.monthData,
        builder: (context, monthData, _) {
          if (monthData == null) {
            return Center(child: Text("noData".tr()));
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 2,
              children: [
                _buildSummaryCard(
                    'prevTotal'.tr(), monthData.prevTotal, Colors.blueGrey),
                _buildSummaryCard('currentBalance'.tr(),
                    monthData.currentBalance, Colors.blue),
                _buildSummaryCard(
                    'prevIncomes'.tr(), monthData.prevIncomes, Colors.teal),
                _buildSummaryCard(
                    'incomes'.tr(), monthData.totalIncomes, Colors.green),
                _buildSummaryCard(
                    'prevExpenses'.tr(), monthData.prevExpenses, Colors.purple),
                _buildSummaryCard(
                    'expenses'.tr(), monthData.totalExpenses, Colors.red),
                _buildSummaryCard(
                    'savings'.tr(), monthData.saving, Colors.lightGreen),
                _buildSummaryCard('box'.tr(),
                    monthData.currentBalance - monthData.saving, Colors.orange),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(String title, double value, Color color) {
    final formattedValue = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    ).format(value);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              formattedValue,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionsScreen extends StatelessWidget {
  final FinancesViewmodel financesViewModel;
  final DateTime selectedDate;
  final VoidCallback onRefresh;

  const TransactionsScreen({
    required this.financesViewModel,
    required this.selectedDate,
    required this.onRefresh,
    super.key,
  });

  _deleteTransaction(BuildContext context, Transaction transaction) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomModalDelete(
          title: "confirmDelete",
          onConfirm: () {
            financesViewModel
                .deleteTransaction(transaction.ruleID)
                .then((response) {
              _handleResponse(response);
            });
          },
        );
      },
    );
  }

  _handleResponse(TransactionResponse? response) {
    if (response?.transaction != null) {
      onRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('transactions'.tr()),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: financesViewModel.monthData,
        builder: (context, monthData, _) {
          if (monthData == null || monthData.transactions.isEmpty) {
            return Center(
              child: Text(
                "noData".tr(),
                style: TextStyle(fontSize: 18),
              ),
            );
          }
          return ListView.builder(
            itemCount: monthData.transactions.length,
            itemBuilder: (context, index) {
              final transaction = monthData.transactions[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  leading: Icon(
                    transaction.confirmed ?? false
                        ? Icons.check_circle
                        : Icons.circle_outlined,
                    color: transaction.confirmed ?? false
                        ? Colors.green
                        : Colors.grey,
                    size: 20,
                  ),
                  title: Text(
                    transaction.title,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontStyle: transaction.saving != null
                            ? FontStyle.italic
                            : FontStyle.normal),
                  ),
                  subtitle: Text(
                    formatDate(transaction.date),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        transaction.income
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        color: transaction.income ? Colors.green : Colors.red,
                        size: 20,
                      ),
                      SizedBox(width: 6),
                      Text(
                        NumberFormat.currency(
                          locale: 'pt_BR',
                          symbol: 'R\$',
                          decimalDigits: 2,
                        ).format(transaction.value),
                        style: TextStyle(
                          color: transaction.income ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  onTap: () async {
                    await financesViewModel
                        .changeTransactionStatus(transaction);
                    onRefresh();
                  },
                  onLongPress: () async {
                    if (!transaction.confirmed) {
                      await _deleteTransaction(context, transaction);
                    }
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => AddTransactionModal(
              onSave: () => onRefresh(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
