import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'FormSignUp.dart';
import '../Login/LoginPage.dart';
import 'SignUpForm.dart';

class Register extends StatelessWidget {
  Register({Key? key, required this.context}) : super (key: key);

  final BuildContext context;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;
      // El usuario se ha registrado/iniciado sesión con éxito utilizando Google
      // Puedes acceder a la información del usuario a través de 'user'
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
                title: 'Bienvenido a Pandda'
              ),
              SignUpForm(context: context),
              Column(
                children: [
                  const Text("O"),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        print('Antes de _signInWithGoogle');
                        _signInWithGoogle().then((_) {
                          print('Después de _signInWithGoogle');
                        }).catchError((error) {
                          print('Error en _signInWithGoogle: $error');
                        });
                      }, 
                      icon: const Image(image: AssetImage('images/google.png'), width: 20.0), 
                      label: const Text('Registrarse con google')),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage(context: context)),
                      );
                    }, 
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: '¿Ya tienes una cuenta?', style: Theme.of(context).textTheme.bodyText1,),
                          TextSpan(text: ' Ingresar'.toUpperCase()),
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}