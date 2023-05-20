import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'custom_elevated_button.dart';
import 'indicadores_perfil.dart';

class TarjetaPerfil extends StatefulWidget {
  final String defaultImagePath;

  const TarjetaPerfil({Key? key, required this.defaultImagePath})
      : super(key: key);

  @override
  _TarjetaPerfilState createState() => _TarjetaPerfilState();
}

class _TarjetaPerfilState extends State<TarjetaPerfil> {
  late String selectedImagePath;

  @override
  void initState() {
    super.initState();
    selectedImagePath = widget.defaultImagePath;
  }

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
                color: Color.fromARGB(255, 158, 235, 187),
              ),
            ),
            GestureDetector(
              onTap: () async {
                final picker = ImagePicker();
                final pickedFile =
                    // ignore: deprecated_member_use
                    await picker.getImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setState(() {
                    selectedImagePath = pickedFile.path; // Actualiza la ruta de la imagen seleccionada
                    }
                  );
                }
              },
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Image.asset(
                    selectedImagePath,
                    width: size.width * 0.4,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.edit,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                  ),
                ],
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
          ],
        ),
      ),
    );
  }
}
