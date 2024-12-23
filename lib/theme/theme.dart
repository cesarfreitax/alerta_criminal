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
  seedColor: Colors.white,
  primary: Colors.white,
  onPrimary: Colors.black,
  primaryContainer: CustomColors().black70,
  onPrimaryContainer: Colors.white,
  surface: CustomColors().black80,
  onSurface: Colors.white,
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
  textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme),
  scaffoldBackgroundColor: dColorScheme.primaryContainer
);

ThemeData lightTheme = ThemeData().copyWith(
  colorScheme: kColorScheme,
  textTheme: GoogleFonts.latoTextTheme(ThemeData.light().textTheme),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme().copyWith(
    backgroundColor: Colors.white
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData().copyWith(
    backgroundColor: Colors.white,
  )
);
