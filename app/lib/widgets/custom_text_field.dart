import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../config/design_system.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final IconData? prefixIcon;
  final bool isPassword;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool readOnly;
  final bool enable;
  final Future<void> Function()? onTap;

  const CustomTextField({
    super.key,
    required this.labelText,
    this.prefixIcon,
    this.isPassword = false,
    required this.controller,
    this.validator,
    this.readOnly = false,
    this.onTap,
    this.enable = true
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      readOnly: readOnly,
      enabled: enable,
      onTap: readOnly && onTap != null
          ? () async => await onTap!()
          : null,
      decoration: InputDecoration(
        labelText: labelText.tr(),
        labelStyle: const TextStyle(
          color: AppColors.onSurface,
        ),
        filled: true,
        fillColor: AppColors.surface,
        prefixIcon: prefixIcon != null
            ? Icon(
          prefixIcon,
          color: AppColors.secondary,
        )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primary,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.onSurface,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 2.0,
          ),
        ),
      ),
      validator: validator,
      style: const TextStyle(
        fontSize: 16,
        color: AppColors.onBackground,
      ),
    );
  }
}
