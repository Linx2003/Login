import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../perfilUsuario.dart/profile.dart';
import 'customBar.dart';
import 'newsSection.dart';
import 'postScreen.dart';

class NewsApp extends StatelessWidget {
  static const String id = 'news_app';

  NewsApp({Key? key}) : super(key: key);

  int activeIndex = 0; // Índice del icono activo (0 para Inicio, 1 para Perfil)

  final CollectionReference postsRef = FirebaseFirestore.instance.collection('Publicaciones');

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            NewsSection(postsRef: postsRef),
          ],
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
                      if (activeIndex != 0) {
                        activeIndex = 0; // Establece el índice del icono activo como 0 (Inicio)
                        // Realiza cualquier acción adicional que desees al seleccionar el icono
                      }
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.home,
                          color: activeIndex == 0 ? Color(0xFF8EBE8A) : Color(0xFFF6FFDE), // Cambia el color del ícono si está activo
                        ),
                        Text(
                          "Inicio",
                          style: TextStyle(
                            color: activeIndex == 0 ? Color(0xFF8EBE8A) : Color(0xFFF6FFDE), // Cambia el color del texto si está activo
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
                      perfilUsuario();
                      if (activeIndex != 0) {
                        activeIndex = 1; // Establece el índice del icono activo como 0 (Inicio)
                        // Realiza cualquier acción adicional que desees al seleccionar el icono
                      }
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.person_2_rounded,
                          color: activeIndex == 1 ? Color(0xFF8EBE8A) : Color(0xFFF6FFDE), // Cambia el color del ícono si está activo
                        ),
                        Text(
                          "Perfil",
                            style: TextStyle(
                            color: activeIndex == 1 ? Color(0xFF8EBE8A) : Color(0xFFF6FFDE), // Cambia el color del texto si está activo
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ),
      ),
    );
  }
}