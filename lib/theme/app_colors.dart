import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  // Accent – always the same
  static const neonBlue   = Color(0xFF00D4FF);
  static const neonGreen  = Color(0xFF39FF14);
  static const neonPurple = Color(0xFF8B5CF6);

  // Dark palette
  static const darkNavy   = Color(0xFF0A0E27);
  static const darkPurple = Color(0xFF1A0533);

  // Light palette
  static const lightSky   = Color(0xFFE8F4FD);
  static const lightLavender = Color(0xFFF0E6FF);

  // Glass
  static Color glassDark  = Colors.white.withOpacity(0.07);
  static Color glassLight = Colors.white.withOpacity(0.55);
  static Color borderDark = Colors.white.withOpacity(0.13);
  static Color borderLight = const Color(0xFF8B5CF6).withOpacity(0.2);
}