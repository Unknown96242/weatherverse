import 'package:flutter/material.dart';

class AppColors {
  // ── Accents dark mode (inchangés) ──
  static const neonBlue   = Color(0xFF00D4FF);
  static const neonGreen  = Color(0xFF39FF14);
  static const neonPurple = Color(0xFF8B5CF6);

  // ── Accents light mode (versions sombres des mêmes couleurs) ──
  // Le neon bleu devient un bleu profond lisible sur fond clair
  static const lightBlue   = Color(0xFF0077A8);  // #00D4FF assombri de 50%
  static const lightGreen  = Color(0xFF1A7A00);  // #39FF14 assombri = vert forêt
  static const lightPurple = Color(0xFF5B21B6);  // #8B5CF6 assombri = violet profond

  // ── Dark palette ──
  static const darkNavy   = Color(0xFF0A0E27);
  static const darkPurple = Color(0xFF1A0533);

  // ── Light palette ──
  // Fonds légèrement plus saturés pour mieux contraster
  static const lightSky      = Color(0xFFD6EEF8);  // était trop blanc
  static const lightLavender = Color(0xFFE4D4F4);  // était trop blanc

  // ── Glass dark ──
  static Color glassDark  = Colors.white.withOpacity(0.07);
  static Color borderDark = Colors.white.withOpacity(0.13);

  // ── Glass light — fond plus opaque pour lisibilité ──
  static Color glassLight  = Colors.white.withOpacity(0.75);  // était 0.55
  static Color borderLight = const Color(0xFF5B21B6).withOpacity(0.25);  // violet profond

  // ── Texte light mode ──
  // À utiliser à la place de neonBlue dans les textes/icônes en light mode
  static const textOnLight     = Color(0xFF0A0E27);  // quasi noir
  static const accentOnLight   = Color(0xFF0077A8);  // bleu profond
  static const subTextOnLight  = Color(0xFF4A4A6A);  // gris bleuté
}