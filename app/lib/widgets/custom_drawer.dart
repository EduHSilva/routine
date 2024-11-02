import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../config/app_config.dart';
import '../config/design_system.dart';
import '../views/auth/splash_view.dart';


class CustomDrawer extends StatelessWidget {
  final String currentRoute;

  const CustomDrawer({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
            child: Text(
              'welcome'.tr() + AppConfig.user!.name,
              style: const TextStyle(
                color: AppColors.onPrimary,
                fontSize: 24,
              ),
            ),
          ),
          _createDrawerItem(
            context,
            icon: Icons.home_outlined,
            text: 'initPage',
            route: '/home',
          ),
          _createDrawerItem(
            context,
            icon: Icons.task_alt_outlined,
            text: 'tasks',
            route: '/tasks',
          ),
          _createDrawerItem(
            context,
            icon: Icons.health_and_safety_outlined,
            text: 'health',
            route: '/health',
          ),
          _createDrawerItem(
            context,
            icon: Icons.monetization_on_outlined,
            text: 'finances',
            route: '/finances',
          ),
          _createDrawerItem(
            context,
            icon: Icons.wallet_giftcard_outlined,
            text: 'shop',
            route: '/shop',
          ),
          const Divider(),
          _createDrawerItem(
            context,
            icon: Icons.settings_outlined,
            text: 'settings',
            route: '/settings',
          ),
          _createDrawerItem(
            context,
            icon: Icons.logout_outlined,
            text: 'logout',
            onTap: () {
              AppConfig.cleanStorage();
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const SplashView(),
              ));
            },
          ),
        ],
      ),
    );
  }

  Widget _createDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    String? route,
    VoidCallback? onTap,
  }) {
    final bool isActive = currentRoute == route;
    return ListTile(
      leading: Icon(
        icon,
        color: isActive ? AppColors.primary : AppColors.onBackground,
      ),
      title: Text(
        text.tr(),
        style: TextStyle(
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          color: isActive ? AppColors.primary : AppColors.onBackground,
        ),
      ),
      onTap: () {
        if (onTap != null) {
          onTap();
        } else if (route != null && currentRoute != route) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
      selected: isActive,
      selectedTileColor: AppColors.primaryVariant.withOpacity(0.1),
    );
  }
}
