import 'package:flutter/material.dart';

class AppTheme {
  // Colores principales
  static const Color primary = Color(0xFF2563EB);
  static const Color background = Color(0xFFF0F4F8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color border = Color(0xFFE2E8F0);

  static ThemeData get lightTheme {
    return ThemeData(
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontFamily: 'Inter'),
        bodyMedium: TextStyle(fontFamily: 'Inter'),
        displayLarge: TextStyle(fontFamily: 'Inter'),
        labelLarge: TextStyle(fontFamily: 'Inter'),
      ),
      useMaterial3: true,
      fontFamily: 'Inter',
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
        surfaceContainer: background,
        surface: surface,
      ),
      scaffoldBackgroundColor: background,

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        foregroundColor: textDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textDark,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Campos de texto
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hintStyle: const TextStyle(color: textMuted, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),

      // Botones
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: surface,
          minimumSize: const Size(double.infinity, 52),
          fixedSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: border),
        ),
      ),
    );
  }
}