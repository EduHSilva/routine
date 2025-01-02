import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:path_provider/path_provider.dart';

import '../config/app_config.dart';
import '../config/design_system.dart';
import '../views/user/splash_view.dart';

class CustomDrawer extends StatelessWidget {
  final String currentRoute;

  const CustomDrawer({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          FutureBuilder<File?>(
            future: _getProfileImage(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const DrawerHeader(
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                  ),
                  child: CircularProgressIndicator(),
                );
              }

              final imageFile = snapshot.data;
              return DrawerHeader(
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: imageFile != null
                          ? FileImage(imageFile)
                          : const AssetImage('assets/images/profile.png') as ImageProvider,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        '${'welcome'.tr()} ${AppConfig.user!.name}',
                        style: const TextStyle(
                          color: AppColors.onPrimary,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
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
          // _createDrawerItem(
          //   context,
          //   icon: Icons.wallet_giftcard_outlined,
          //   text: 'shop',
          //   route: '/shop',
          // ),
          const Divider(),
          _createDrawerItem(
            context,
            icon: Icons.category_outlined,
            text: 'categories',
            route: '/categories',
          ),
          _createDrawerItem(
            context,
            icon: Icons.person_outlined,
            text: 'profile',
            route: '/profile',
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
      // ignore: deprecated_member_use
      selectedTileColor: AppColors.primaryVariant.withOpacity(0.1),
    );
  }

  Future<File?> _getProfileImage() async {
    try {
      if (AppConfig.user?.photo != null && AppConfig.user!.photo!.isNotEmpty) {
        final bytes = base64Decode(AppConfig.user!.photo!);
        final tempDir = await getTemporaryDirectory();
        final imagePath = '${tempDir.path}/profile_image.png';
        return await File(imagePath).writeAsBytes(bytes);
      }
    } catch (e) {
      debugPrint('Error on init profile image: $e');
    }
    return null;
  }
}
