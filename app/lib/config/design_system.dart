import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF079CC6);
  static const Color primaryVariant = Color(0xFF00BFAF);
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFE94E77);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFF000000);
  static const Color onBackground = Color(0xFF000000);
  static const Color onSurface = Color(0xFF000000);
  static const Color onError = Color(0xFFFFFFFF);

  static const Gradient primaryGradient = LinearGradient(
    colors: [primary, primaryVariant],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTheme {
  static final RoundedRectangleBorder _roundedShape =
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(8));

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarTextStyle: TextStyle(color: AppColors.primary),
      iconTheme: IconThemeData(
        color: AppColors.primary,
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      primaryContainer: AppColors.primaryVariant,
      secondary: AppColors.primaryVariant,
      secondaryContainer: AppColors.primary,
      surface: AppColors.surface,
      error: AppColors.error,
      onPrimary: AppColors.onPrimary,
      onSecondary: AppColors.onSecondary,
      onSurface: AppColors.onSurface,
      onError: AppColors.onError,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStateProperty.all(_roundedShape),
        padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(vertical: 12, horizontal: 20)),
        foregroundColor: WidgetStateProperty.all(AppColors.primary),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStateProperty.all(_roundedShape),
        elevation: WidgetStateProperty.all(4),
        padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(vertical: 12, horizontal: 20)),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppColors.primaryVariant;
          }
          return AppColors.primary;
        }),
        foregroundColor: WidgetStateProperty.all(AppColors.onPrimary),
      ),
    ),
    textTheme: GoogleFonts.poppinsTextTheme(),
    cardTheme: CardTheme(
      shape: _roundedShape,
      elevation: 4,
      margin: const EdgeInsets.all(10),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryVariant,
      elevation: 4,
    ),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      primaryContainer: AppColors.primaryVariant,
      secondary: AppColors.primaryVariant,
      secondaryContainer: AppColors.primary,
      surface: AppColors.surface,
      error: AppColors.error,
      onPrimary: AppColors.onPrimary,
      onSecondary: AppColors.onSecondary,
      onSurface: AppColors.onSurface,
      onError: AppColors.onError,
    ),
  );
}
