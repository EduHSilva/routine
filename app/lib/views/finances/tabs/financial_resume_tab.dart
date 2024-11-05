import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class FinancialResumeTab extends StatefulWidget {
  const FinancialResumeTab({super.key});

  @override
  FinancialResumeTabState createState() => FinancialResumeTabState();
}

class FinancialResumeTabState extends State<FinancialResumeTab> {
  DateTime selectedDate = DateTime.now();

  double currentBalance = 1500.00;
  double totalIncome = 2000.00;
  double totalExpenses = 500.00;

  List<Map<String, dynamic>> transactions = [
    {'date': '01/11/2024', 'description': 'Aluguel', 'amount': -1200.00},
    {'date': '03/11/2024', 'description': 'Salário', 'amount': 3000.00},
    {'date': '05/11/2024', 'description': 'Supermercado', 'amount': -300.00},
  ];

  void _changeMonth(int offset) {
    setState(() {
      selectedDate = DateTime(
        selectedDate.year,
        selectedDate.month + offset,
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat.yMMMM('pt_BR').format(selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: Text('Resumo Financeiro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_right),
                  onPressed: () => _changeMonth(1),
                ),
              ],
            ),
            SizedBox(height: 16.0),

            Card(
              color: Colors.grey[100],
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Resumo do Mês',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Saldo Atual:', style: TextStyle(fontSize: 16)),
                        Text('R\$ $currentBalance', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Entradas:', style: TextStyle(fontSize: 16)),
                        Text('R\$ $totalIncome', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Saídas:', style: TextStyle(fontSize: 16)),
                        Text('R\$ $totalExpenses', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),

            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return ListTile(
                    leading: Icon(
                      transaction['amount'] > 0 ? Icons.arrow_downward : Icons.arrow_upward,
                      color: transaction['amount'] > 0 ? Colors.green : Colors.red,
                    ),
                    title: Text(transaction['description']),
                    subtitle: Text(transaction['date']),
                    trailing: Text(
                      'R\$ ${transaction['amount']}',
                      style: TextStyle(
                        color: transaction['amount'] > 0 ? Colors.green : Colors.red,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar para a tela de registro de nova transação
        },
        tooltip: 'Registrar Nova Transação',
        child: Icon(Icons.add),
      ),
    );
  }
}
