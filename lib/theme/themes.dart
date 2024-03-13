import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Themes{
  final lightTheme = ThemeData.light().copyWith(
    primaryColor: const Color(0xFF0B2C33),
    hintColor: const Color(0xFFB78D75),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.ubuntu(
        fontSize: 36.0,
        fontStyle: FontStyle.italic,
      ),
      titleLarge: GoogleFonts.ubuntu(
        fontSize: 24.0,
        fontStyle: FontStyle.italic,
      ),
      bodyMedium: GoogleFonts.ubuntu(
        fontSize: 18.0,
        fontStyle: FontStyle.italic,
      ),
    ),
    appBarTheme: AppBarTheme(
      color: const Color(0xFF0B2C33),
      centerTitle: true,
      foregroundColor: const Color(0xFFB78D75),
      titleTextStyle: GoogleFonts.ubuntu(
        fontSize: 24.0,
        fontStyle: FontStyle.italic,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      elevation: 0,
      backgroundColor: Color(0xFF0B2C33),
    ),
  );
  final darkTheme = ThemeData.dark().copyWith(
    hintColor: const Color(0xFF0B2C33),
    primaryColor: Colors.white,
    textTheme: TextTheme(
      displayLarge: GoogleFonts.ubuntu(
        fontSize: 36.0,
        fontStyle: FontStyle.italic,
      ),
      titleLarge: GoogleFonts.ubuntu(
        fontSize: 24.0,
        fontStyle: FontStyle.italic,
      ),
      bodyMedium: GoogleFonts.ubuntu(
        fontSize: 18.0,
        fontStyle: FontStyle.italic,
      ),
    ),
    appBarTheme: AppBarTheme(
      color: Colors.white,
      centerTitle: true,
      foregroundColor: const Color(0xFF0B2C33),
      titleTextStyle: GoogleFonts.ubuntu(
        fontSize: 24.0,
        fontStyle: FontStyle.italic,
      ),
    ),
  );
}