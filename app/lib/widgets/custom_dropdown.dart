import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DropdownItem<T> {
  final String label; // O que será mostrado no dropdown
  late final T value; // O valor associado (pode ser enum, string, int, etc.)

  DropdownItem({required this.label, required this.value});
}

class CustomDropdown<T> extends StatelessWidget {
  final String labelText;
  final DropdownItem<T>? selectedItem;
  final List<DropdownItem<T>> items;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;

  const CustomDropdown({
    super.key,
    required this.labelText,
    required this.items,
    this.selectedItem,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: selectedItem?.value,
      decoration: InputDecoration(
        labelText: labelText.tr(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
      ),
      items: items.map((DropdownItem<T> item) {
        return DropdownMenuItem<T>(
          value: item.value,
          child: Text(item.label.tr()),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) => validator != null ? validator!(value) : null,
    );
  }
}
