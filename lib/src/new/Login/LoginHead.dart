import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginHead extends StatelessWidget {
  const LoginHead({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(
        image: AssetImage('images/logo.png'), height: size.height * 0.2,
        ),
        Text('Bienvenidos a Pandda', 
        style: GoogleFonts.poppins(fontSize: 24.0, fontWeight: FontWeight.w600, color: Color(0xFF272727)), textAlign: TextAlign.center),
      ],
    );
  }
}