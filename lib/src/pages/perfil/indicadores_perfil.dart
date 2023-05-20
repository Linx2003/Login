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
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 158, 235, 187),
          ),
        ),
        Text(
          text,
          style: GoogleFonts.josefinSans(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(96, 20, 78, 38),
          ),
        ),
      ],
    );
  }
}
