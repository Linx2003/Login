import 'package:flutter/material.dart';
import 'package:red_social/src/new/HomePage/news.dart';
import '../HomePage/postScreen.dart';
import 'tarjeta_perfil.dart';

class perfilUsuario extends StatefulWidget {
  static const String id = 'perfil_usuario';

  @override
  _PerfilUsuarioState createState() => _PerfilUsuarioState();
}

class _PerfilUsuarioState extends State<perfilUsuario> {
  int activeIndex = 0; // Índice del icono activo (0 para Inicio, 1 para Perfil)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PerfilWidget(),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NewsApp()), // Navega a la pantalla de perfil
                    );
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
