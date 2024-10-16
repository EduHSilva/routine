import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isOutlined;
  final ButtonStyle? style;
  final bool isLoading;

  const CustomButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.isOutlined = false, this.isLoading = false,

        this.style});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle defaultStyle = ButtonStyle(
      minimumSize: WidgetStateProperty.all(const Size.fromHeight(40)),
    );

    return isLoading
        ? const CircularProgressIndicator()
        : isOutlined
            ? OutlinedButton(
                onPressed: onPressed,
                style: style?.merge(defaultStyle) ?? defaultStyle,
                child: Text(
                  text.tr().toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : ElevatedButton(
                onPressed: onPressed,
                style: style?.merge(defaultStyle) ?? defaultStyle,
                child: Text(
                  text.tr().toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
  }
}
