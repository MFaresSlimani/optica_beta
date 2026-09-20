import 'package:flutter/material.dart';

abstract class AppColors {
  // Brand Palette
  static const Color primary = Color(0xFF0B2C33);
  static const Color primaryLight = Color(0xFF133F4A);
  static const Color primaryDark = Color(0xFF06181C);

  static const Color accent = Color(0xFFB78D75);
  static const Color accentLight = Color(0xFFD4B19E);
  static const Color accentDark = Color(0xFF8F6550);

  // Backgrounds & Gradients
  static const Color backgroundDark = Color(0xFF0B2C33);
  static const Color surfaceDark = Color(0xFF0F363F);
  static const Color surfaceCard = Color(0x1AFFFFFF);
  static const Color surfaceCardBorder = Color(0x33B78D75);

  // Inputs
  static const Color inputFill = Color(0x12FFFFFF);
  static const Color inputBorder = Color(0x2EB78D75);
  static const Color inputFocusedBorder = Color(0xFFB78D75);

  // Text & Accents
  static const Color textLight = Colors.white;
  static const Color textMuted = Color(0xB3FFFFFF);
  static const Color textSubtle = Color(0x80FFFFFF);
  static const Color textHint = Color(0x66FFFFFF);

  // Status
  static const Color error = Color(0xFFE57373);
  static const Color success = Color(0xFF81C784);
}
