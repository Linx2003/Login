import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../HomePage/news.dart';
import 'FormSignUp.dart';
import '../Login/LoginPage.dart';
import 'SignUpForm.dart';

class Register extends StatefulWidget {
  Register({Key? key, required this.context}) : super(key: key);

  final BuildContext context;

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  String generateRandomPassword() {
  const int passwordLength = 8; // Longitud deseada de la contraseña
  const String allowedChars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()_-+=';

  Random random = Random();
  String password = '';

  for (int i = 0; i < passwordLength; i++) {
    int randomIndex = random.nextInt(allowedChars.length);
    password += allowedChars[randomIndex];
  }

  return password;
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        final String userId = googleUser.id;
        final String userEmail = googleUser.email ?? '';
        final String userName = googleUser.displayName ?? '';
        final String userPhotoUrl = googleUser.photoUrl ?? '';

        // Generar una contraseña aleatoria
        final String password = generateRandomPassword();

        // Guardar los datos del usuario en Firebase Firestore
        await FirebaseFirestore.instance.collection('Usuario').doc(userId).set({
          'celular': '',
          'email': userEmail,
          'usuario': userName,
          'contrasena': password,
        });

        // Crear una cuenta de usuario en Firebase Authentication con el correo electrónico y la contraseña
        final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: userEmail,
          password: password,
        );

        // Una vez registrado correctamente, puedes redirigir al usuario a la siguiente pantalla.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NewsApp(), // Reemplaza "HomeScreen" con el nombre de tu pantalla principal
          ),
        );
      } else {
        // El usuario canceló la autenticación
      }
    } catch (e) {
      // Ocurrió un error durante la autenticación con Google
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormSignUp(
                image: 'images/logo.png',
                title: 'Bienvenido a Pandda',
              ),
              SignUpForm(
                context: widget.context,
                onSubmit: (email) {},
              ),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  },
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '¿Ya tienes una cuenta? ',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        TextSpan(
                          text: 'Ingresar'.toUpperCase(),
                          style: TextStyle(
                            color: Color(0xFFAAC8A7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
