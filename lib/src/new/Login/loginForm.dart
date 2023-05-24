import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../HomePage/news.dart';
import '../UserData.dart';
import '../olvidarPass/forgetPasswordBottom.dart';

class LoginForm extends StatefulWidget {
  final BuildContext context;

    LoginForm({required this.context }) {
    Intl.defaultLocale = 'es';
  }

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController user = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool showPassword = false;

  validarDatos() async{
    final decodedPassword = base64.encode(utf8.encode(password.text));
    try{
      CollectionReference ref= FirebaseFirestore.instance.collection('Usuario');
      QuerySnapshot usuario= await ref.get();

      for (var doc in usuario.docs) {
        var cursor = doc.data() as Map<String, dynamic>; // Asegurar el tipo de cursor como Map<String, dynamic>
        if (cursor != null) { // Verificar si cursor no es nulo
          if (cursor['Usuario'] == user.text.trim() || cursor['Email'] == email.text.trim()) {
            print('Usuario encontrado');
            if (cursor['Contraseña'] == decodedPassword) {
              UserData.userName = cursor['Usuario'];
              UserData.email = cursor['Email'];
              print('Acceso concedido');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewsApp()),
              );
              return;
            }
          } 
        }
      }

        // Si el usuario o contraseña no coinciden con el documento actual, se sigue buscando

    }catch(e){
    print('Error'+e.toString());
    }
  }

  void mostrarSnackBar(String mensaje) {
    final snackBar = SnackBar(content: Text(mensaje));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 30.0 -10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: user,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person_outline_outlined), //icono
                labelText: 'Usuario',
                hintText: 'ejemplo@correo.com',
                border: OutlineInputBorder()  //caja
              ),
            ),
            const SizedBox(height: 30.0 -20), // espacios
            TextFormField(
              controller: password,
              obscureText: !showPassword,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_open),
                labelText: 'Contraseña',
                hintText: 'Contraseña',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                    Future.delayed(Duration(seconds: 2), () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    });
                  },
                  icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
                ),
              ),
            ),
            const SizedBox(height: 30.0 - 20),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  ForgetPasswordBottom.buildShowModalBottomSheet(context);
                }, 
                child: Text(
                  '¿Olvidaste tu contraseña?',
                  style: TextStyle(
                    color: Color(0xFFAAC8A7),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () {
                print('Ingresando ...');
                validarDatos();
              }, 
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFAAC8A7), 
              ),
              child: Text('Ingresar'.toUpperCase(),
              )
              ),
            )
          ],
        ),
      )
    );
  }
}