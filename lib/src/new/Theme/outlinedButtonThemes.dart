import 'package:flutter/material.dart';

class OutlinedButtonThemes {
  OutlinedButtonThemes._();

  static final lightoutButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom( 
      shape: RoundedRectangleBorder(), 
      foregroundColor: Color(0xff4245ff), 
      side: BorderSide(color: Color(0xff4245ff)),
      padding: EdgeInsets.symmetric(vertical: 15.0)
    ),
  );  

  static final darkoutButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom( 
      shape: RoundedRectangleBorder(), 
      foregroundColor: Colors.white, 
      side: BorderSide(color: Colors.white),
      padding: EdgeInsets.symmetric(vertical: 15.0)
    ),
  );  

}