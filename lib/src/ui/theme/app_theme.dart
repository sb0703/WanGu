import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color inkBlack = Color(0xFF1A1A1A);
  static const Color ricePaper = Color(0xFFF7F5F0);
  static const Color sealRed = Color(0xFFB73E3E);
  static const Color ancientGold = Color(0xFFC6A355);
  static const Color deepGreen = Color(0xFF2E4033);
  static const Color stoneGray = Color(0xFF757575);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: ricePaper,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: inkBlack,
        onPrimary: Colors.white,
        secondary: deepGreen,
        onSecondary: Colors.white,
        tertiary: sealRed,
        onTertiary: Colors.white,
        error: sealRed,
        onError: Colors.white,
        surface: ricePaper,
        onSurface: inkBlack,
        surfaceContainerHighest: Color(0xFFEBE8E0),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: ricePaper,
        foregroundColor: inkBlack,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: inkBlack,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Serif', // Fallback to Serif
          letterSpacing: 1.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white.withValues(alpha: 0.8),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(color: Color(0xFFE0DCD0), width: 1),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: inkBlack,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: inkBlack,
          side: const BorderSide(color: inkBlack),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFFEBE8E0),
        indicatorColor: ancientGold.withValues(alpha: 0.3),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: inkBlack,
          fontWeight: FontWeight.bold,
          fontFamily: 'Serif',
        ),
        headlineMedium: TextStyle(
          color: inkBlack,
          fontWeight: FontWeight.bold,
          fontFamily: 'Serif',
        ),
        titleLarge: TextStyle(
          color: inkBlack,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        bodyMedium: TextStyle(color: inkBlack, fontSize: 16, height: 1.5),
        bodySmall: TextStyle(color: stoneGray, fontSize: 14),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE0DCD0),
        thickness: 1,
      ),
    );
  }

  static ThemeData get darkTheme {
    const darkBg = Color(0xFF121212);
    const darkSurface = Color(0xFF1E1E1E);
    const darkText = Color(0xFFE0E0E0);
    const darkGold = Color(0xFFD4AF37);

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: darkBg,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: darkGold,
        onPrimary: Colors.black,
        secondary: Color(0xFF81C784), // Light Green
        onSecondary: Colors.black,
        tertiary: Color(0xFFE57373), // Light Red
        onTertiary: Colors.black,
        error: Color(0xFFCF6679),
        onError: Colors.black,
        surface: darkBg,
        onSurface: darkText,
        surfaceContainerHighest: darkSurface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBg,
        foregroundColor: darkText,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: darkText,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Serif',
          letterSpacing: 1.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(color: Color(0xFF333333), width: 1),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: darkGold,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkGold,
          side: const BorderSide(color: darkGold),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: darkSurface,
        indicatorColor: darkGold.withValues(alpha: 0.3),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: darkText,
          fontWeight: FontWeight.bold,
          fontFamily: 'Serif',
        ),
        headlineMedium: TextStyle(
          color: darkText,
          fontWeight: FontWeight.bold,
          fontFamily: 'Serif',
        ),
        titleLarge: TextStyle(
          color: darkText,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        bodyMedium: TextStyle(color: darkText, fontSize: 16, height: 1.5),
        bodySmall: TextStyle(color: Colors.grey, fontSize: 14),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF333333),
        thickness: 1,
      ),
    );
  }
}
