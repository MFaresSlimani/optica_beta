import 'package:flutter/material.dart';

/// Raw brand palette. Widgets never read these directly: they go through
/// `Theme.of(context).colorScheme` or the [OpticaPalette] theme extension so
/// light and dark mode stay consistent. Only `core/theme` consumes this file.
abstract final class AppColors {
  // Brand: deep teal and the copper gradient from the BN logo.
  static const Color teal950 = Color(0xFF061A1F);
  static const Color teal900 = Color(0xFF0B2C33);
  static const Color teal800 = Color(0xFF0F363F);
  static const Color teal700 = Color(0xFF14414B);
  static const Color teal600 = Color(0xFF1C5562);
  static const Color teal100 = Color(0xFFDCE8E9);
  static const Color teal50 = Color(0xFFEEF4F4);

  static const Color copper200 = Color(0xFFEBBBA0);
  static const Color copper300 = Color(0xFFD9A98F);
  static const Color copper400 = Color(0xFFC79C84);
  static const Color copper500 = Color(0xFFB78D75);
  static const Color copper600 = Color(0xFF9A6F57);
  static const Color copper700 = Color(0xFF7E5641);

  // Neutrals (warm, to sit next to copper).
  static const Color sand50 = Color(0xFFFAF8F5);
  static const Color sand100 = Color(0xFFF3EFEA);
  static const Color sand200 = Color(0xFFE7E0D8);
  static const Color ink900 = Color(0xFF14262A);
  static const Color ink600 = Color(0xFF4E5F63);
  static const Color ink400 = Color(0xFF7D8C8F);

  // Status.
  static const Color green500 = Color(0xFF2E9D6A);
  static const Color green300 = Color(0xFF7FD3A8);
  static const Color amber600 = Color(0xFFB7791F);
  static const Color amber300 = Color(0xFFF2C46D);
  static const Color red600 = Color(0xFFC8433A);
  static const Color red300 = Color(0xFFF08A82);

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // Thermal-paper ticket preview (same in light and dark mode, like paper).
  static const Color ticketPaper = Color(0xFFFFFDF9);
  static const Color ticketInk = Color(0xFF1E1E1E);

  /// Top scrim that keeps light icons legible over photos.
  static const LinearGradient photoTopScrim = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment(0, -0.2),
    colors: [Color(0x66000000), Color(0x00000000)],
  );

  /// The copper gradient of the logo, used for brand moments only.
  static const LinearGradient copperGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [copper200, copper500],
  );

  /// Deep teal gradient for hero headers.
  static const LinearGradient tealGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [teal900, teal700],
  );
}
