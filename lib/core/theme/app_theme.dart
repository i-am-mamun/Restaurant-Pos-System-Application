import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFFFF5722);
  static const Color primaryDark = Color(0xFFE64A19);
  static const Color primaryLight = Color(0xFFFFF3F0);
  static const Color accent = Color(0xFFFF7043);
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF8F9FA);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFEEEEEE);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFFBDBDBD);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color danger = Color(0xFFF44336);
  static const Color purple = Color(0xFF9C27B0);
  static const Color blue = Color(0xFF2196F3);
  static const Color teal = Color(0xFF009688);
  static const Color orange = Color(0xFFFF9800);
  static const Color headerBg = Color(0xFFFF5722);
  static const Color sidebarBg = Color(0xFFFFFFFF);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color vegBadge = Color(0xFF4CAF50);
  static const Color popularBadge = Color(0xFFFF5722);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        surface: AppColors.background,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppColors.borderLight),
        ),
      ),
    );
  }
}
