import 'package:alerta_criminal/theme/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ColorScheme kColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: Colors.white,
  primary: Colors.black87,
  onPrimary: Colors.white,
  primaryContainer: Colors.white,
  onPrimaryContainer: Colors.black,
  surface: Colors.white,
  onSurface: Colors.black,
  secondary: Colors.blueAccent,
  onSecondary: Colors.white,
  secondaryContainer: CustomColors().offWhite,
  onSecondaryContainer: Colors.black,
  error: Colors.redAccent,
  onError: Colors.white,
);

final ColorScheme dColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: CustomColors().black70,
  primary: Colors.white,
  onPrimary: CustomColors().black70,
  primaryContainer: CustomColors().black70,
  onPrimaryContainer: Colors.white,
  surface: CustomColors().black70,
  onSurface: Colors.white,
  secondary: Colors.lightBlueAccent,
  onSecondary: Colors.white,
  secondaryContainer: CustomColors().black60,
  onSecondaryContainer: Colors.white,
  error: Colors.redAccent,
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
    textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme),
    scaffoldBackgroundColor: dColorScheme.primaryContainer,
    appBarTheme: AppBarTheme().copyWith(backgroundColor: dColorScheme.primaryContainer),
    bottomNavigationBarTheme: BottomNavigationBarThemeData().copyWith(
      backgroundColor: dColorScheme.primaryContainer,
    ));

ThemeData lightTheme = ThemeData().copyWith(
    colorScheme: kColorScheme,
    textTheme: GoogleFonts.latoTextTheme(ThemeData.light().textTheme),
    scaffoldBackgroundColor: kColorScheme.primaryContainer,
    appBarTheme: AppBarTheme().copyWith(backgroundColor: kColorScheme.primaryContainer),
    bottomNavigationBarTheme: BottomNavigationBarThemeData().copyWith(
      backgroundColor: kColorScheme.primaryContainer,
    ));
