import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Themes {
  static TextStyle _fontStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return GoogleFonts.abel(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      textStyle: TextStyle(
        fontFamilyFallback: [
          GoogleFonts.notoSansTifinagh().fontFamily ?? 'Noto Sans Tifinagh',
        ],
      ),
    );
  }

  final darkTheme = ThemeData.dark().copyWith(
    primaryColor: const Color(0xFF0B2C33),
    hintColor: const Color(0xFFB78D75),
    scaffoldBackgroundColor: const Color(0xFF0B2C33),
    listTileTheme: ListTileThemeData(
      titleTextStyle: _fontStyle(
        color: Colors.white,
        fontSize: 18.0,
      ),
    ),
    textTheme: TextTheme(
      displayLarge: _fontStyle(
        fontSize: 36.0,
      ),
      titleSmall: _fontStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18.0,
      ),
      bodyMedium: _fontStyle(
        fontSize: 18.0,
      ),
    ),

    cardColor: const Color(0xFF0B2C33),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF0B2C33),
      centerTitle: true,
      foregroundColor: const Color(0xFFB78D75),
      titleTextStyle: _fontStyle(
        color: const Color(0xFFB78D75),
        fontSize: 24.0,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      elevation: 0,
      backgroundColor: Color(0xFF0B2C33),
      surfaceTintColor: Color(0xFF0B2C33),
    ),
  );

  final lightTheme = ThemeData.light().copyWith(
    hintColor: const Color(0xFF0B2C33),
    primaryColor: const Color(0xFFB78D75),
    textTheme: TextTheme(
      displayLarge: _fontStyle(
        fontSize: 36.0,
        color: const Color(0xFF0B2C33),
      ),
      titleSmall: _fontStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20.0,
        color: const Color(0xFF0B2C33),
      ),
      bodyMedium: _fontStyle(
        fontSize: 18.0,
        color: const Color(0xFF0B2C33),
      ),
    ),
    cardColor: Colors.white,
    listTileTheme: ListTileThemeData(
      titleTextStyle: _fontStyle(
        color: const Color(0xFF0B2C33),
        fontSize: 18.0,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF0B2C33),
      centerTitle: true,
      foregroundColor: const Color(0xFFB78D75),
      titleTextStyle: _fontStyle(
        color: const Color(0xFFB78D75),
        fontSize: 24.0,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      elevation: 0,
      backgroundColor: Color(0xFF0B2C33),
    ),
  );
}
