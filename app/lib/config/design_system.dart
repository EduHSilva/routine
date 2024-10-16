import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF4A90E2);
  static const Color primaryVariant = Color(0xFF50E3C2);
  static const Color secondary = Color(0xFF03DAC6);
  static const Color secondaryVariant = Color(0xFF018786);
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

  static const Gradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryVariant],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTheme {
  static final RoundedRectangleBorder _roundedShape =
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(15));

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background, 
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent, 
      elevation: 0, 
      toolbarTextStyle: TextStyle(
        color: AppColors.onSecondary
      ),
      iconTheme: IconThemeData(
        color: AppColors.onSecondary, 
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      primaryContainer: AppColors.primaryVariant,
      secondary: AppColors.secondary,
      secondaryContainer: AppColors.secondaryVariant,
      surface: AppColors.surface,
      error: AppColors.error,
      onPrimary: AppColors.onPrimary,
      onSecondary: AppColors.onSecondary,
      onSurface: AppColors.onSurface,
      onError: AppColors.onError,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStateProperty.all(_roundedShape),
        elevation: WidgetStateProperty.all(4),
        padding: WidgetStateProperty .all(
            const EdgeInsets.symmetric(vertical: 12, horizontal: 20)),
        backgroundColor: WidgetStateProperty .resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppColors.primaryVariant;
          }
          return AppColors.primary;
        }),
        foregroundColor: WidgetStateProperty.all(AppColors.onPrimary),
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
        color: AppColors.onBackground,
      ),
      bodyLarge: TextStyle(fontSize: 16.0, color: AppColors.onBackground),
      bodyMedium: TextStyle(fontSize: 14.0, color: AppColors.onSurface),
    ),
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
      secondary: AppColors.secondary,
      secondaryContainer: AppColors.secondaryVariant,
      surface: AppColors.surface,
      error: AppColors.error,
      onPrimary: AppColors.onPrimary,
      onSecondary: AppColors.onSecondary,
      onSurface: AppColors.onSurface,
      onError: AppColors.onError,
    ),
  );
}
