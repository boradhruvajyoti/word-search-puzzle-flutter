// Utils: AppTheme — light and dark ThemeData using Google Fonts
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // ── Brand colours ──────────────────────────────────────────────────────────
  static const Color primaryLight = Color(0xFF6C63FF);
  static const Color primaryDark  = Color(0xFF8B84FF);
  static const Color accentLight  = Color(0xFF00C9A7);
  static const Color accentDark   = Color(0xFF00E5BE);
  static const Color bgLight      = Color(0xFFF0F2FF);
  static const Color bgDark       = Color(0xFF0D0E1E);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark  = Color(0xFF1A1B2E);
  static const Color cardLight    = Color(0xFFFFFFFF);
  static const Color cardDark     = Color(0xFF242540);
  static const Color timerGood    = Color(0xFF06D6A0);
  static const Color timerWarn    = Color(0xFFFFBE0B);
  static const Color timerDanger  = Color(0xFFFF6B6B);

  static ThemeData get lightTheme {
    final base = ThemeData(
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: primaryLight,
        secondary: accentLight,
        surface: surfaceLight,
        error: Color(0xFFFF6B6B),
      ),
      scaffoldBackgroundColor: bgLight,
      cardColor: cardLight,
    );
    return base.copyWith(
      textTheme: GoogleFonts.outfitTextTheme(base.textTheme).apply(
        bodyColor: const Color(0xFF1A1B2E),
        displayColor: const Color(0xFF1A1B2E),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: bgLight,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF1A1B2E),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1A1B2E)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryLight,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    final base = ThemeData(
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primaryDark,
        secondary: accentDark,
        surface: surfaceDark,
        error: Color(0xFFFF6B6B),
      ),
      scaffoldBackgroundColor: bgDark,
      cardColor: cardDark,
    );
    return base.copyWith(
      textTheme: GoogleFonts.outfitTextTheme(base.textTheme).apply(
        bodyColor: const Color(0xFFE8E9FF),
        displayColor: const Color(0xFFE8E9FF),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: bgDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: const Color(0xFFE8E9FF),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFE8E9FF)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryDark,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
