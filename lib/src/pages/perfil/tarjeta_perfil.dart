import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'custom_elevated_button.dart';
import 'indicadores_perfil.dart';

class TarjetaPerfil extends StatelessWidget {
  const TarjetaPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * 0.6,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Mi perfil',
              style: GoogleFonts.josefinSans(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            ClipOval(
              child: Image.asset(
                'images/panda.jpeg', //Imagen de perfil
                width: size.width * 0.3,
              ),
            ),
            Text.rich(
              TextSpan(
                text: 'Usuario\n',
                style: GoogleFonts.josefinSans(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: 'Correo@gmail.com',
                    style: GoogleFonts.josefinSans(
                      fontSize: 20,
                      color: Colors.black38,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Indicadores(
                  number: '250',
                  text: 'Vistas',
                ),
                Indicadores(
                  number: '500',
                  text: 'Seguidores',
                ),
                Indicadores(
                  number: '300',
                  text: 'Siguiendo',
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomElevatedButton(
                  text: 'Editar Perfil',
                  primary: Color(0xff4245ff),
                ),
                CustomElevatedButton(
                  text: 'Configuracion',
                  primary: Color(0xff4245ff),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
