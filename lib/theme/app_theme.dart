import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData dark() => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkNavy,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.neonBlue,
      secondary: AppColors.neonGreen,
      tertiary: AppColors.neonPurple,
      surface: AppColors.darkNavy,
    ),
    textTheme: _textTheme(Brightness.dark),
  );

  static ThemeData light() => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightSky,
    colorScheme: const ColorScheme.light(
      primary: AppColors.neonBlue,
      secondary: AppColors.neonGreen,
      tertiary: AppColors.neonPurple,
      surface: AppColors.lightSky,
    ),
    textTheme: _textTheme(Brightness.light),
  );

  static TextTheme _textTheme(Brightness b) {
    final baseColor = b == Brightness.dark ? Colors.white : AppColors.darkNavy;
    return TextTheme(
      displayLarge: GoogleFonts.orbitron(
          color: baseColor, fontWeight: FontWeight.w900, fontSize: 32),
      titleLarge: GoogleFonts.orbitron(
          color: baseColor, fontWeight: FontWeight.w700, fontSize: 18),
      titleMedium: GoogleFonts.orbitron(
          color: baseColor, fontWeight: FontWeight.w600, fontSize: 14),
      bodyLarge: GoogleFonts.rajdhani(
          color: baseColor, fontWeight: FontWeight.w500, fontSize: 16),
      bodyMedium: GoogleFonts.rajdhani(
          color: baseColor.withOpacity(0.7), fontSize: 14),
      labelSmall: GoogleFonts.orbitron(
          color: baseColor.withOpacity(0.5),
          fontSize: 10,
          letterSpacing: 2),
    );
  }
}


