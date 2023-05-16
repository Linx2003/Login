import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Indicadores extends StatelessWidget {
  const Indicadores({super.key, required this.number, required this.text});

  final String number, text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          number,
          style: GoogleFonts.josefinSans(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color(0xff4245ff),
          ),
        ),
        Text(
          text,
          style: GoogleFonts.josefinSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black38,
          ),
        ),
      ],
    );
  }
}
