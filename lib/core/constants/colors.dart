import 'package:flutter/material.dart';

class KColors {
  static const Color light = Colors.white;
  static Color dark = primary.shade900;
  static Color primaryBackground = Colors.white;

  static const MaterialColor primary = MaterialColor(
    _primary,
    <int, Color>{
      50: Color(0xFFDDE1EF),
      100: Color(0xFFA2AACE),
      200: Color(0xFF59679D),
      300: Color(0xFF35437C),
      400: Color(0xFF26346C),
      500: Color(_primary),
      600: Color(0xFF0F1737),
      700: Color(0xFF0A1025),
      800: Color(0xFF050812),
      900: Color(0xFF030409),
    },
  );
  static const int _primary = 0xFF1A275C;
}
