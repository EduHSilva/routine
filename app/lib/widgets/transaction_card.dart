import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../views/finances/new_financial_rule_view.dart';

class TransactionCard extends StatelessWidget {
  final String title;
  final bool income;
  final double value;
  final String startDate;
  final String endDate;
  final int id;

  const TransactionCard({
    super.key,
    required this.title,
    required this.id,
    required this.income,
    required this.value,
    required this.startDate,
    required this.endDate,
  });

  String _formatDate(String date) {
    try {
      final DateTime parsedDate = DateTime.parse(date);
      return DateFormat('dd/MM/yyyy').format(parsedDate);
    } catch (e) {
      return 'Invalid date';
    }
  }

  Color _getBackgroundColor(BuildContext context) {
    return income ? Colors.green : Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NewFinancialRuleView(id: id)),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        leading: CircleAvatar(
          backgroundColor: _getBackgroundColor(context),
          child: Icon(
            income ? Icons.arrow_upward : Icons.arrow_downward,
            color: Colors.white,
          ),
        ),
        title: Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "${_formatDate(startDate)} - ${_formatDate(endDate)}",
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
        trailing: Text(
          'R\$ ${value.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: income ? Colors.green : Colors.red,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
