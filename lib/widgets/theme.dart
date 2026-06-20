import 'package:flutter/material.dart';

class AppColors {
  // Light Theme Colors
  static const Color lightPrimary = Color(0xFF0F766E);
  static const Color lightOnPrimary = Colors.white;
  static const Color lightBackground = Color(0xFFFAFAF9);
  static const Color lightOnBackground = Color(0xFF1C1917);
  static const Color lightSecondaryBackground = Color(0xFFF5F5F4);
  static const Color lightSurface = Colors.white;
  static const Color lightOnSurface = Color(0xFF1C1917);
  static const Color lightPrimaryText = Color(0xFF1C1917);
  static const Color lightSecondaryText = Color(0xFF57534E);
  static const Color lightHint = Color(0xFFA8A29E);
  static const Color lightOutline = Color(0xFFD6D3D1);
  static const Color lightDivider = Color(0xFFE7E5E4);
  static const Color lightSuccess = Color(0xFF16A34A);
  static const Color lightError = Color(0xFFDC2626);
  static const Color lightWarning = Color(0xFFCA8A04);
  static const Color lightInfo = Color(0xFF2563EB);

  // Dark Theme Colors
  static const Color darkPrimary = Color(0xFF5EEAD4);
  static const Color darkOnPrimary = Colors.black;
  static const Color darkBackground = Color(0xFF000000);
  static const Color darkOnBackground = Color(0xFFFAFAF9);
  static const Color darkSecondaryBackground = Color(0xFF0C0C0C);
  static const Color darkSurface = Color(0xFF18181B);
  static const Color darkOnSurface = Color(0xFFFAFAF9);
  static const Color darkPrimaryText = Color(0xFFFAFAF9);
  static const Color darkSecondaryText = Color(0xFFA8A29E);
  static const Color darkHint = Color(0xFF52525B);
  static const Color darkOutline = Color(0xFF3F3F46);
  static const Color darkDivider = Color(0xFF27272A);
  static const Color darkSuccess = Color(0xFF22C55E);
  static const Color darkError = Color(0xFFF87171);
  static const Color darkWarning = Color(0xFFEAB308);
  static const Color darkInfo = Color(0xFF60A5FA);

  // Map of category color hexes to Flutter Color objects
  static Color getColorFromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.lightPrimary,
      scaffoldBackgroundColor: AppColors.lightBackground,
      cardColor: AppColors.lightSurface,
      dividerColor: AppColors.lightDivider,
      hintColor: AppColors.lightHint,
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightPrimary,
        onPrimary: AppColors.lightOnPrimary,
        background: AppColors.lightBackground,
        onBackground: AppColors.lightOnBackground,
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightOnSurface,
        error: AppColors.lightError,
        outline: AppColors.lightOutline,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: 'Inter', fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.lightPrimaryText),
        titleLarge: TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.lightPrimaryText),
        titleMedium: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.lightPrimaryText),
        bodyLarge: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.normal, color: AppColors.lightPrimaryText),
        bodyMedium: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.normal, color: AppColors.lightSecondaryText),
        labelSmall: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.lightHint),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.lightPrimaryText),
        titleTextStyle: TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.lightPrimaryText),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        selectedItemColor: AppColors.lightPrimary,
        unselectedItemColor: AppColors.lightSecondaryText,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: AppColors.lightOnPrimary,
        shape: CircleBorder(),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.lightDivider, width: 1),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.darkPrimary,
      scaffoldBackgroundColor: AppColors.darkBackground,
      cardColor: AppColors.darkSurface,
      dividerColor: AppColors.darkDivider,
      hintColor: AppColors.darkHint,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkPrimary,
        onPrimary: AppColors.darkOnPrimary,
        background: AppColors.darkBackground,
        onBackground: AppColors.darkOnBackground,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkOnSurface,
        error: AppColors.darkError,
        outline: AppColors.darkOutline,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: 'Inter', fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.darkPrimaryText),
        titleLarge: TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.darkPrimaryText),
        titleMedium: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.darkPrimaryText),
        bodyLarge: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.normal, color: AppColors.darkPrimaryText),
        bodyMedium: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.normal, color: AppColors.darkSecondaryText),
        labelSmall: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.darkHint),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.darkPrimaryText),
        titleTextStyle: TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.darkPrimaryText),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: AppColors.darkPrimary,
        unselectedItemColor: AppColors.darkSecondaryText,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: AppColors.darkOnPrimary,
        shape: CircleBorder(),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.darkOutline, width: 1),
        ),
      ),
    );
  }
}
