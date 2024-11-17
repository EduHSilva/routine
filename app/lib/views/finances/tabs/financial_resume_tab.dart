import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:routine/config/helper.dart';

import '../../../view_models/finances_viewmodel.dart';

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
                  childAspectRatio: 1.8,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  children: [
                    _buildSummaryCard('currentBalance'.tr(), 'R\$ ${monthData.currentBalance}', Colors.blue),
                    _buildSummaryCard('prevTotal'.tr(), 'R\$ ${monthData.prevTotal}', Colors.blueGrey),
                    _buildSummaryCard('incomes'.tr(), 'R\$ ${monthData.totalIncomes}', Colors.green),
                    _buildSummaryCard('expenses'.tr(), 'R\$ ${monthData.totalExpenses}', Colors.red),
                    _buildSummaryCard('prevIncomes'.tr(), 'R\$ ${monthData.prevIncomes}', Colors.teal),
                    _buildSummaryCard('prevExpenses'.tr(), 'R\$ ${monthData.prevExpenses}', Colors.purple),
                  ],
                ),
              ),
              Divider(),
              // Transactions List
              Expanded(
                child: ListView.separated(
                  itemCount: monthData.transactions.length,
                  separatorBuilder: (context, index) => Divider(height: 1),
                  itemBuilder: (context, index) {
                    final transaction = monthData.transactions[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: ListTile(
                        leading: Checkbox(
                          value: transaction.confirmed ?? false,
                          onChanged: (value) async {
                            await _financesViewModel.changeTransactionStatus(transaction);
                            await _fetchData();
                          },
                        ),
                        title: Text(transaction.title),
                        subtitle: Text(formatDate(transaction.date)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              transaction.income ? Icons.arrow_upward : Icons.arrow_downward,
                              color: transaction.income ? Colors.green : Colors.red,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'R\$ ${transaction.value}',
                              style: TextStyle(
                                color: transaction.income ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implementar ação
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
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
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
