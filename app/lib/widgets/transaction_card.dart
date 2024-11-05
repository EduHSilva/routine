import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:routine/views/finances/new_financial_rule_view.dart';

class TransactionCard extends StatelessWidget {
  final String title;
  final bool income;
  final double value;
  final String startDate;
  final String endDate;
  final String? color;
  final int id;

  const TransactionCard({
    super.key,
    required this.title,
    required this.id,
    required this.income,
    required this.value,
    required this.startDate,
    required this.endDate,
    this.color,
  });

  String _formatDate(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    return DateFormat('dd/MM/yyyy').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      child: ListTile(
        onTap: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NewFinancialRuleView(id: id)))
        },
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        leading: CircleAvatar(
          backgroundColor: income ? Colors.green : Colors.red,
          child: Icon(
            income ? Icons.arrow_upward : Icons.arrow_downward_outlined,
            color: Colors.white,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          "${_formatDate(startDate)} - ${_formatDate(endDate)}",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'R\$ ${value.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: income ? Colors.green : Colors.red,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
