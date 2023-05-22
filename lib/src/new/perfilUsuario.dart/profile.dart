import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../HomePage/postScreen.dart';
import 'tarjeta_perfil.dart';

class perfilUsuario extends StatefulWidget {
  static const String id = 'perfil_usuario';

  @override
  _perfilUsuarioState createState() => _perfilUsuarioState();
}

class _perfilUsuarioState extends State<perfilUsuario> {
  int activeIndex = 0; // Índice del icono activo (0 para Inicio, 1 para Perfil)

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
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
                              color: Colors.blue, // Cambia el color del círculo según tus necesidades
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewPostScreen()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFFAAC8A7),
        elevation: 0,
      ),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 5.0,
        shape: CircularNotchedRectangle(),
        color: Color(0xFFC9DBB2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: InkWell(
                onTap: () {
                  if (activeIndex != 1) {
                    setState(() {
                      activeIndex = 1; // Establece el índice del icono activo como 0 (Inicio)
                    });
                    // Realiza cualquier acción adicional que desees al seleccionar el icono
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.home,
                      color: activeIndex == 1
                          ? Color(0xFF8EBE8A)
                          : Color(0xFFF6FFDE), // Cambia el color del ícono si está activo
                    ),
                    Text(
                      "Inicio",
                      style: TextStyle(
                        color: activeIndex == 1
                            ? Color(0xFF8EBE8A)
                            : Color(0xFFF6FFDE), // Cambia el color del texto si está activo
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0, top: 10.0, bottom: 10.0),
              child: InkWell(
                onTap: () {
                  if (activeIndex != 0) {
                    setState(() {
                      activeIndex = 0; // Establece el índice del icono activo como 1 (Perfil)
                    });
                    // Realiza cualquier acción adicional que desees al seleccionar el icono
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.person_2_rounded,
                      color: activeIndex == 0
                          ? Color(0xFF8EBE8A)
                          : Color(0xFFF6FFDE), // Cambia el color del ícono si está activo
                    ),
                    Text(
                      "Perfil",
                      style: TextStyle(
                        color: activeIndex == 0
                            ? Color(0xFF8EBE8A)
                            : Color(0xFFF6FFDE), // Cambia el color del texto si está activo
                      ),
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
