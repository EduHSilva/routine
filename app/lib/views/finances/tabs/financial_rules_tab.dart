import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../view_models/finances_viewmodel.dart';
import '../../../widgets/transaction_card.dart';
import '../new_financial_rule_view.dart';

class FinancialRulesTab extends StatefulWidget {
  const FinancialRulesTab({super.key});

  @override
  FinancialRulesTabState createState() => FinancialRulesTabState();
}

class FinancialRulesTabState extends State<FinancialRulesTab> {
  @override
  initState() {
    super.initState();
    _financesViewModel.fetchFinancesRules();
  }

  final FinancesViewmodel _financesViewModel = FinancesViewmodel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('rules'.tr()),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ValueListenableBuilder(
            valueListenable: _financesViewModel.isLoading,
            builder: (context, isLoading, child) {
              if (isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return ValueListenableBuilder(
                  valueListenable: _financesViewModel.rules,
                  builder: (context, rules, child) {
                    if (rules.isEmpty) {
                      return Center(child: Text('noData'.tr()));
                    } else {
                      return Scaffold(
                          body: Expanded(
                        child: ListView.builder(
                          itemCount: rules.length,
                          itemBuilder: (context, index) {
                            final transaction = rules[index];
                            return TransactionCard(
                              id: transaction.id,
                              title: transaction.title,
                              income: transaction.income,
                              value: transaction.value,
                              startDate: transaction.startDate,
                              endDate: transaction.endDate,
                            );
                          },
                        ),
                      ));
                    }
                  });
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const NewFinancialRuleView(),
          ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
