import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:red_social/src/new/Login/LoginPage.dart';

import '../Register/signUp.dart';

class SplashScreen extends StatefulWidget {
  static String id = 'splash_screen';

  @override
  splashWelcome createState() => splashWelcome();
}

class splashWelcome extends State<SplashScreen> {

  @override
  Widget build(BuildContext context){
    var mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height;
    var brightness = mediaQuery.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    Color textColor = isDarkMode ? Colors.white : Color(0xFF272727);

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF272727) : Colors.white,
      body: 
      Container(
        padding: EdgeInsets.all(30.0), // bordes
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,  //alineacion uniforme y equilibrado
          children: [
            Image.asset('images/logo.png', height: height * 0.5),
            Text('Bienvenidos a Pandda', 
              style: GoogleFonts.poppins(fontSize: 24.0, fontWeight: FontWeight.w600, color: Color(0xFF272727)), textAlign: TextAlign.center),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage(context: context)),
                      );
                    }, 
                    style: OutlinedButton.styleFrom( 
                      shape: RoundedRectangleBorder(), 
                      foregroundColor: Color(0xff4245ff), 
                      side: BorderSide(color: Color(0xff4245ff)),
                      padding: EdgeInsets.symmetric(vertical: 15.0)
                    ),
                  child: Text('Login'.toUpperCase())
                  ),
                ),
                const SizedBox( width: 10.0,), // espacio entre los botones
                Expanded(
                  child: ElevatedButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Register(context: context)),
                      );
                    }, 
                    style: OutlinedButton.styleFrom( 
                      shape: RoundedRectangleBorder(), 
                      foregroundColor: Colors.white, 
                      backgroundColor: Color(0xff4245ff),
                      side: BorderSide(color: Color(0xff4245ff)),
                      padding: EdgeInsets.symmetric(vertical: 15.0)
                    ), //linea del boton 
                    child: Text('Signup'.toUpperCase())
                  )
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}