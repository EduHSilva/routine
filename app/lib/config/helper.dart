import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../models/response.dart';

void showSnackBar(BuildContext context, String message,
    {bool isError = false}) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: isError ? Colors.red : Colors.green,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showErrorBar(BuildContext context, DefaultResponse? response) {
  if (response?.message != null && response?.message.trim() != "") {
    showSnackBar(context, response!.message, isError: true);
  } else {
    showSnackBar(context, 'error'.tr(), isError: true);
  }
}

String? requiredFieldValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'requiredField'.tr(); // Tradução para 'campo obrigatório'
  }
  return null;
}

Color hexaToColor(String? hexColor) {
  if (hexColor == null) return Colors.transparent;
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF$hexColor";
  }
  try {
    return Color(int.parse(hexColor, radix: 16));
  } catch(e) {
    return Colors.transparent;
  }
}

String colorToHexa(Color color) {
  return '#${color.value.toRadixString(16).substring(2, 8).toUpperCase()}';
}

String formatDate(String? date) {
  if (date == null) return "";
  DateTime dateTime = DateTime.parse(date).toUtc();
  return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
}

String getDayOfWeek(String? date) {
  if (date == null) return "";
  DateTime dateTime = DateTime.parse(date).toUtc();
  int day = dateTime.weekday;
  switch (day) {
    case 1:
      return 'monday';
    case 2:
      return 'tuesday';
    case 3:
      return 'wednesday';
    case 4:
      return 'thursday';
    case 5:
      return 'friday';
    case 6:
      return 'saturday';
    default:
      return 'sunday';
  }
}
