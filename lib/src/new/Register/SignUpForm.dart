import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Login/LoginPage.dart';

class SignUpForm extends StatelessWidget {
  final BuildContext context;
  
  SignUpForm({
    required this.context, 
    required void Function(dynamic email)? onSubmit 
    });

  TextEditingController usuario = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController celular = TextEditingController();
  TextEditingController contrasena = TextEditingController();
  final firebaseFirestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;

  registroUsuario() async{
    try {
      if (usuario.text.trim().isEmpty ||
          email.text.trim().isEmpty ||
          celular.text.trim().isEmpty ||
          contrasena.text.trim().isEmpty) {
        mostrarSnackBar('Por favor, complete todos los campos');
        return;
      }

      final encodedPassword = base64.encode(utf8.encode(contrasena.text));

      if (contrasena.text.trim().length < 6) {
        mostrarSnackBar('La contraseña debe tener al menos 6 caracteres');
        return;
      }

      //valida usuario
      final querySnapshot = await firebaseFirestore
          .collection('Usuario')
          .where('Usuario', isEqualTo: usuario.text.trim())
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Si el usuario ya existe, muestra un mensaje de error y devuelve la función
        mostrarSnackBar('Este usuario ya está registrado');
        return;
      }

      //valida email
      final querySnapshott = await FirebaseFirestore.instance
          .collection('Usuario')
          .where('Email', isEqualTo: email.text)
          .get();

      if (querySnapshott.docs.isNotEmpty) {
        mostrarSnackBar('El correo electrónico ya está registrado');
        return;
      }

      // Crea el usuario autenticado en Firebase Authentication
      final userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email.text,
        password: contrasena.text,
      );

      // Obtiene el ID del usuario creado
      final userId = userCredential.user?.uid;

      if (userId != null) {
        // Guarda los datos adicionales del usuario en Cloud Firestore
        await firebaseFirestore.collection('Usuario').doc(userId).set({
          "Usuario": usuario.text,
          "Email": email.text,
          "Celular": celular.text,
          "Contraseña": encodedPassword
        });

      await userCredential.user!.sendEmailVerification();

      showDialog(
        context: context, 
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Registro exitoso'),
            content: Text('Se ha enviado un correo electrónico de verificacion. Por favor, verifica tu dirección de correo electronico para completar el registro.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                }, 
                child: Text('Aceptar'),
              ),
            ],
          );
        }
      ); 
      }
    } catch (e) {
      print('Error al registrar el usuario: $e');
    }
  } 

  void mostrarSnackBar(String mensaje) {
    final snackBar = SnackBar(content: Text(mensaje));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30.0 -10),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: usuario,
              decoration: const InputDecoration(
                label: Text('Usuario'),
                prefixIcon: Icon(
                  Icons.person_outline_rounded,
                  color: Color(0xFFAAC8A7),
                ),
              ),
            ),
            const SizedBox(height: 30.0 -20),
            TextFormField(
              controller: email,
              decoration: const InputDecoration(
                label: Text('Correo electronico'),
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: Color(0xFFAAC8A7),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 30.0 -20),
            TextFormField(
              controller: celular,
              decoration: const InputDecoration(
                label: Text('Celular'),
                prefixIcon: Icon(
                  Icons.numbers,
                  color: Color(0xFFAAC8A7),
                ),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 30.0 -20),
            TextFormField(
              controller: contrasena,
              decoration: const InputDecoration(
                label: Text('Contraseña'),
                prefixIcon: Icon(
                  Icons.fingerprint,
                  color: Color(0xFFAAC8A7),
                ),
              ),
            ),
            const SizedBox(height: 30.0 -10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  registroUsuario();
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFAAC8A7), // Establecer el color del botón aquí
                ),
                child: Text('Registrarse'.toUpperCase()),
              ),
            )
          ],
        )
      ),
    );
  }
}