import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../config/design_system.dart';
import 'custom_button.dart';

class CustomModalDelete extends StatefulWidget {
  final String title;
  final Function() onConfirm;

  const CustomModalDelete({
    super.key,
    required this.title,
    required this.onConfirm,
  });

  @override
  CustomModalDeleteState createState() => CustomModalDeleteState();
}

class CustomModalDeleteState extends State<CustomModalDelete> {
  List<TextEditingController> controllers = [];
  Color selectedColor = Colors.green;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        widget.title.tr(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      contentPadding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  text: 'cancel',
                  isOutlined: true,
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: CustomButton(
                  onPressed: () {
                    widget.onConfirm();
                    Navigator.of(context).pop();
                  },
                  text: 'confirm',
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
