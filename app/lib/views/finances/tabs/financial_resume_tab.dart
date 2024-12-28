import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:routine/config/helper.dart';
import 'package:routine/models/finances/finances_model.dart';

import '../../../view_models/finances_viewmodel.dart';
import '../../../widgets/custom_modal_delete.dart';
import '../modals/transaction_modal.dart';

class FinancialResumeTab extends StatefulWidget {
  final int initialIndex;

  const FinancialResumeTab({super.key, this.initialIndex = 0});

  @override
  FinancialResumeTabState createState() => FinancialResumeTabState();
}

class FinancialResumeTabState extends State<FinancialResumeTab> {
  DateTime selectedDate = DateTime.now();
  final FinancesViewmodel _financesViewModel = FinancesViewmodel();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  _deleteTransaction(Transaction transaction) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomModalDelete(
          title: "confirmDelete",
          onConfirm: () {
            _financesViewModel
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
      _fetchData();
    } else {
      if (!mounted) return;
      showErrorBar(context, response);
    }
  }

  _fetchData() async {
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
    String formattedDate = DateFormat.yMMMM('pt_BR').format(selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: Text(formattedDate),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_left),
          onPressed: () => _changeMonth(-1),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_right),
            onPressed: () => _changeMonth(1),
          ),
        ],
      ),
      body: ValueListenableBuilder(
          valueListenable: _financesViewModel.isLoading,
          builder: (context, isLoading, child) {
            if (isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return ValueListenableBuilder(
              valueListenable: _financesViewModel.monthData,
              builder: (context, monthData, child) {
                if (monthData == null) {
                  return Center(child: Text('noData'.tr()));
                }

                return Column(
                  children: [
                    // Summary Grid
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        childAspectRatio: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        children: [
                          _buildSummaryCard('prevTotal'.tr(),
                              'R\$ ${monthData.prevTotal}', Colors.blueGrey),
                          _buildSummaryCard('currentBalance'.tr(),
                              'R\$ ${monthData.currentBalance}', Colors.blue),
                          _buildSummaryCard('prevIncomes'.tr(),
                              'R\$ ${monthData.prevIncomes}', Colors.teal),
                          _buildSummaryCard('incomes'.tr(),
                              'R\$ ${monthData.totalIncomes}', Colors.green),
                          _buildSummaryCard('prevExpenses'.tr(),
                              'R\$ ${monthData.prevExpenses}', Colors.purple),
                          _buildSummaryCard('expenses'.tr(),
                              'R\$ ${monthData.totalExpenses}', Colors.red),
                        ],
                      ),
                    ),
                    Divider(),
                    // Transactions List
                    Expanded(
                      child: ListView.separated(
                        itemCount: monthData.transactions.length,
                        separatorBuilder: (context, index) =>
                            Divider(height: 1, color: Colors.grey[300]),
                        itemBuilder: (context, index) {
                          final transaction = monthData.transactions[index];
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 12),
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
                                ),
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
                                    color: transaction.income
                                        ? Colors.green
                                        : Colors.red,
                                    size: 20,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'R\$ ${transaction.value.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: transaction.income
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () async {
                                await _financesViewModel
                                    .changeTransactionStatus(transaction);
                                await _fetchData();
                              },
                              onLongPress: () async {
                                if (!transaction.confirmed)
                                  await _deleteTransaction(transaction);
                              },
                            ),
                          );
                        },
                      ),
                    )
                  ],
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => AddTransactionModal(
              onSave: () => _fetchData(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color) {
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
              softWrap: false,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
