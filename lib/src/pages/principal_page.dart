import 'package:flutter/material.dart';
import 'package:red_social/src/pages/perfil/custom.card.dart';
import 'package:red_social/src/pages/perfil/custom_bottom_bar.dart';

import 'Perfil/tarjeta_perfil.dart';

class PrincipalPage extends StatelessWidget {
  const PrincipalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            TarjetaPerfil(defaultImagePath: 'images/panda.jpeg',),
            SizedBox(height: 10),
            CustomCard(),
            CustomCard(),
            CustomCard(),  
          ],
        ),
      ),
      bottomNavigationBar: CustomBottonBar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff4245ff),
        onPressed: () {},
        child: Icon(
          Icons.add,
          size: 34,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
