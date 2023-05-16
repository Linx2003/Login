import 'package:flutter/material.dart';
import 'package:red_social/src/new/Theme/elevated_button_theme.dart';
import 'package:red_social/src/new/Theme/outlinedButtonThemes.dart';
import 'package:red_social/src/new/Theme/textThemes.dart';

class appTheme {
  appTheme._();

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    textTheme: TextThemes.lightTextTheme,
    outlinedButtonTheme: OutlinedButtonThemes.lightoutButtonTheme,
    elevatedButtonTheme: ElevatedButtonThemes.lightElevatedButtonTheme,
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    textTheme: TextThemes.darkTextTheme,
    outlinedButtonTheme: OutlinedButtonThemes.darkoutButtonTheme,
    elevatedButtonTheme: ElevatedButtonThemes.darkElevatedButtonTheme,
  );
}