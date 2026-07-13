import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class FilterCard extends StatelessWidget {
  final String value;
  final String label;
  final bool isSelected;
  final Function(String) onTap;

  const FilterCard({
    super.key,
    required this.value,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(value),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueAccent : Colors.grey[200],
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.blueAccent.withOpacity(0.4),
                blurRadius: 8.0,
                offset: Offset(0, 4),
              ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Center(
          child: Text(
            label.tr(),
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
