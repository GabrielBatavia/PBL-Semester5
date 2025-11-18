// lib/theme/AppTheme.dart

import 'package:flutter/material.dart';

class AppTheme {
  // 🎨 Fresh Color Palette (nama lama tetap biar gak rusak import)
  static const Color primaryOrange = Color(0xFF6A11CB); // Purple primary
  static const Color highlightYellow = Color(0xFF2ED8C3); // Mint / accent
  static const Color warmCream = Color(0xFFF5F7FF); // Soft background
  static const Color darkBrown = Color(0xFF1F2933); // Dark navy text

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    scaffoldBackgroundColor: warmCream,

    // 🎨 Skema warna utama
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: primaryOrange,
      onPrimary: Colors.white,
      secondary: highlightYellow,
      onSecondary: darkBrown,
      error: Colors.red,
      onError: Colors.white,
      background: warmCream,
      onBackground: darkBrown,
      surface: Colors.white,
      onSurface: darkBrown,
    ),

    // 🧭 AppBar modern – flat, text tebal
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      foregroundColor: darkBrown,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: darkBrown,
      ),
      iconTheme: IconThemeData(color: darkBrown),
    ),

    // 🔘 Tombol utama (CTA)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryOrange,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 2,
      ),
    ),

    // 🔲 Tombol outline
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryOrange,
        side: const BorderSide(color: primaryOrange, width: 1.2),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),

    // 📄 Teks
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.w700,
        color: darkBrown,
      ),
      titleLarge: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w700,
        color: darkBrown,
      ),
      bodyLarge: TextStyle(
        fontSize: 15.0,
        color: darkBrown,
      ),
      bodyMedium: TextStyle(
        fontSize: 13.0,
        color: darkBrown,
      ),
      labelLarge: TextStyle(
        fontSize: 13.0,
        fontWeight: FontWeight.w600,
        color: darkBrown,
      ),
    ),

    // ✏️ Input field
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      hintStyle: const TextStyle(color: Colors.black45),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: primaryOrange, width: 1.4),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  );
}
