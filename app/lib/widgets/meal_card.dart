import 'package:flutter/material.dart';

import '../config/design_system.dart';

class MealCard extends StatelessWidget {
  final int id;
  final String name;
  final String hour;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  const MealCard({
    super.key,
    required this.id,
    required this.name,
    required this.hour,
    required this.onTap,
    required this.onEdit,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        onTap: onTap,
        leading: const Icon(Icons.restaurant_menu),
        title: Text(name),
        subtitle: Text(hour),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              color: AppColors.primary,
              onPressed: onEdit,
              tooltip: 'Edit Meal',
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onRemove,
              color: AppColors.error,
              tooltip: 'Remove Meal',
            ),
            const Icon(Icons.arrow_forward),
          ],
        ),
      ),
    );
  }
}
