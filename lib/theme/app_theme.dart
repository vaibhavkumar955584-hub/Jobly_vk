import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // LinkedIn-inspired Palette
  static const Color joblyBlue = Color(0xFF0056B3); // A slightly different professional blue
  static const Color primary = joblyBlue;
  static const Color secondary = joblyBlue;
  static const Color background = Color(0xFFF3F2EF); // Light grey background
  static const Color surface = Color(0xFFFFFFFF);    // White cards
  static const Color textPrimary = Color(0xFF000000); // Near black
  static const Color textSecondary = Color(0x99000000); // 60% black
  static const Color border = Color(0xFFEBEBEB);
  static const Color error = Color(0xFFBA1A1A);

  static ThemeData get lightTheme {
    final base = ThemeData.light();
    return base.copyWith(
      scaffoldBackgroundColor: background,
      primaryColor: joblyBlue,
      colorScheme: ColorScheme.light(
        primary: joblyBlue,
        secondary: joblyBlue,
        surface: surface,
        onSurface: textPrimary,
        outline: border,
        error: error,
      ),
      textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
        headlineLarge: GoogleFonts.inter(
          color: textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
        headlineMedium: GoogleFonts.inter(
          color: textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
        titleLarge: GoogleFonts.inter(
          color: textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        titleMedium: GoogleFonts.inter(
          color: textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        bodyLarge: GoogleFonts.inter(
          color: textPrimary,
          fontSize: 14,
        ),
        bodyMedium: GoogleFonts.inter(
          color: textSecondary,
          fontSize: 13,
        ),
        labelLarge: GoogleFonts.inter(
          color: textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        labelMedium: GoogleFonts.inter(
          color: textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        labelSmall: GoogleFonts.inter(
          color: textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        iconTheme: const IconThemeData(color: textSecondary),
        titleTextStyle: GoogleFonts.inter(
          color: textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: textPrimary,
        unselectedLabelColor: textSecondary,
        indicatorColor: Colors.black,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: border,
        labelStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFFEDF3F8), // LinkedIn search bar color
        hintStyle: GoogleFonts.inter(color: textSecondary, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: border, width: 1),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: border,
        thickness: 1,
        space: 1,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: joblyBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme => lightTheme; // For now
}
