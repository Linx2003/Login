import 'package:flutter/material.dart';

class ElevatedButtonThemes {
  ElevatedButtonThemes._();

  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: OutlinedButton.styleFrom( 
      shape: RoundedRectangleBorder(), 
      foregroundColor: Colors.white, 
      backgroundColor: Color(0xff4245ff),
      side: BorderSide(color: Color(0xff4245ff)),
      padding: EdgeInsets.symmetric(vertical: 15.0)
    ),
  );

  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: OutlinedButton.styleFrom( 
      shape: RoundedRectangleBorder(), 
      foregroundColor: Color(0xff4245ff), 
      backgroundColor: Colors.white,
      side: BorderSide(color: Color(0xff4245ff)),
      padding: EdgeInsets.symmetric(vertical: 15.0)
    ),
  );
}