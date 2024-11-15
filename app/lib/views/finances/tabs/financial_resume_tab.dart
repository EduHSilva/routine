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
      selectedDate = DateTime(
        selectedDate.year,
        selectedDate.month + offset,
      );
    });
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat.yMMMM('pt_BR').format(selectedDate);
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: ValueListenableBuilder(
          valueListenable: _financesViewModel.monthData,
          builder: (context, monthData, child) {
            if (monthData == null) {
              return Center(child: Text('noData'.tr()));
            } else {
              var totalExpanses = monthData.totalExpanses;
              var totalIncomes = monthData.totalIncomes;
              var prevExpanses = monthData.prevExpanses;
              var prevIncomes = monthData.prevIncomes;
              var currentBalance = monthData.currentBalance;
              var prevTotal = monthData.total;

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_left),
                        onPressed: () => _changeMonth(-1),
                      ),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_right),
                        onPressed: () => _changeMonth(1),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSummaryCard(
                        'currentBalance'.tr(),
                        'R\$ $currentBalance',
                        Colors.blue
                      ),
                      _buildSummaryCard(
                        'incomes'.tr(),
                        'R\$ $totalIncomes',
                        Colors.green,
                      ),
                      _buildSummaryCard(
                        'expanses'.tr(),
                        'R\$ $totalExpanses',
                        Colors.red,
                      ),
                      _buildSummaryCard(
                        'prevIncomes'.tr(),
                        'R\$ $prevIncomes',
                        Colors.teal,
                      ),
                      _buildSummaryCard(
                        'prevExpanses'.tr(),
                        'R\$ $prevExpanses',
                        Colors.purple,
                      ),
                      _buildSummaryCard(
                        'prevTotal'.tr(),
                        'R\$ $prevTotal',
                        Colors.blueGrey,
                      ),

                    ],
                  )),
                  SizedBox(height: 16.0),

                  Container(
                    color: Colors.grey[200],
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: monthData.transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = monthData.transactions[index];

                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
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
                                  transaction.income
                                      ? Icons.arrow_upward
                                      : Icons.arrow_downward,
                                  color: transaction.income
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'R\$ ${transaction.value}',
                                  style: TextStyle(
                                    color: transaction.income
                                        ? Colors.green
                                        : Colors.red,
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
            }
          },
        ),
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
    return SizedBox(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  SizedBox(height: 8),
                  Text(
                    title,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(fontSize: 16, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
