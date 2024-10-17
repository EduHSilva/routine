import 'package:flutter/material.dart';

import '../config/design_system.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final TabBar? bottom;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.bottom
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(color: AppColors.onPrimary),
      ),
      actions: actions,
      bottom: bottom,
      iconTheme: const IconThemeData(color: AppColors.onPrimary),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(bottom == null ? kToolbarHeight : kToolbarHeight + bottom!.preferredSize.height);
}
