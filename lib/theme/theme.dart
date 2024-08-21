import 'package:alerta_criminal/theme/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ColorScheme kColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: CustomColors().black80,
  primary: CustomColors().black80,
  onPrimary: Colors.white,
  secondary: Colors.grey,
  onSecondary: Colors.black,
  error: Colors.red,
  onError: Colors.white,
  primaryContainer: Colors.white,
  onPrimaryContainer: Colors.black,
  secondaryContainer: Colors.white,
  onSecondaryContainer: Colors.black,
  surface: Colors.white,
  onSurface: Colors.black,
);

final ColorScheme dColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: Colors.white,
  surface: CustomColors().black80,
  onSurface: Colors.white,
  primary: Colors.white,
  onPrimary: Colors.black,
  primaryContainer: CustomColors().black70,
  onPrimaryContainer: Colors.white,
  secondary: CustomColors().grey,
  onSecondary: Colors.black,
  secondaryContainer: CustomColors().black60,
  onSecondaryContainer: Colors.white,
  error: Colors.red,
  onError: Colors.white,
);

ThemeData darkTheme = ThemeData.dark().copyWith(
  colorScheme: dColorScheme,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: dColorScheme.primary,
      foregroundColor: dColorScheme.onPrimary,
    ),
  ),
  textTheme: GoogleFonts.latoTextTheme(ThemeData.dark().textTheme),
);

ThemeData lightTheme = ThemeData().copyWith(
  colorScheme: kColorScheme,
  textTheme: GoogleFonts.latoTextTheme(ThemeData.light().textTheme),
);
