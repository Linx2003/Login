import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PerfilWidget extends StatefulWidget {
  @override
  _PerfilWidgetState createState() => _PerfilWidgetState();
}

class _PerfilWidgetState extends State<PerfilWidget> {
  String? userName; // Variable para almacenar el nombre del usuario

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  // Método para obtener el nombre del usuario a partir del correo electrónico
  void fetchUserName() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Usuario')
          .where('Email', isEqualTo: currentUser.email)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          userName = snapshot.docs[0]['Usuario'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Obtén el usuario actual
    User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: size.height * 0.6,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(top: 1, bottom: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        'Mi perfil',
                        style: GoogleFonts.josefinSans(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 158, 235, 187),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Acción al presionar el círculo de la imagen
                        // Puedes agregar aquí la lógica para abrir la galería del celular
                      },
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: size.width * 0.4,
                            height: size.width * 0.4,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFAAC8A7), // Cambia el color del círculo según tus necesidades
                            ),
                            child: Icon(
                              Icons.person,
                              size: size.width * 0.2,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(255, 255, 255, 255),
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
                        text: userName ?? 'Usuario', // Obtén el correo electrónico del usuario o muestra 'example@gmail.com' como valor predeterminado
                        style: GoogleFonts.josefinSans(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: '\n' + (currentUser?.email ?? 'example@gmail.com'), // Obtén el nombre del usuario o muestra 'Usuario' como valor predeterminado
                            style: GoogleFonts.josefinSans(
                              fontSize: 20,
                              color: Colors.black38,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
