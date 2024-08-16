import 'package:flutter/material.dart';

final ColorScheme kColorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 51, 184, 255));

final ColorScheme dColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 51, 184, 255));

ThemeData darkTheme = ThemeData.dark().copyWith(
  colorScheme: dColorScheme,
  appBarTheme: const AppBarTheme().copyWith(
    backgroundColor: dColorScheme.primaryContainer,
    foregroundColor: dColorScheme.onPrimaryContainer,
  ),
  cardTheme: const CardTheme().copyWith(
    color: dColorScheme.secondaryContainer,
    elevation: 0.3,
    margin: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 8,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: dColorScheme.primaryContainer,
      foregroundColor: dColorScheme.onPrimaryContainer,
    ),
  ),
);

ThemeData lightTheme = ThemeData().copyWith(
  colorScheme: kColorScheme,
  appBarTheme: const AppBarTheme().copyWith(
    backgroundColor: kColorScheme.primaryContainer,
    foregroundColor: kColorScheme.onPrimaryContainer,
  ),
  cardTheme: const CardTheme().copyWith(
    color: kColorScheme.secondaryContainer,
    elevation: 0.3,
    margin: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 8,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kColorScheme.primaryContainer,
    ),
  ),
  textTheme: ThemeData().textTheme.copyWith(
        titleLarge: TextStyle(
            color: kColorScheme.onSecondaryContainer,
            fontSize: 16,
            fontWeight: FontWeight.bold),
      ),
);
