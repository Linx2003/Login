import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Register/signUp.dart';

class LoginFooter extends StatelessWidget {
  final BuildContext context;
  LoginFooter({Key? key, required this.context}) : super (key: key);

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser != null) {
      // Autenticación exitosa, se obtiene la información del usuario
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Accede a los tokens de autenticación
      String accessToken = googleAuth.accessToken ?? '';
      String idToken = googleAuth.idToken ?? '';  //puede ser nulo

      // Realiza la lógica de autenticación con los tokens obtenidos

      // Ejemplo de cómo imprimir los tokens
      print('Access Token: $accessToken');
      print('ID Token: $idToken');
    } else {
      // El usuario canceló la autenticación
      print('Autenticación cancelada por el usuario');
    }
  } catch (e) {
    // Ocurrió un error durante la autenticación con Google
    print('Error al autenticar con Google: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("O"),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: Image(image: AssetImage('images/google.png'), width: 20.0 ),
            onPressed: () {
              _signInWithGoogle();
            },
            label: Text('Ingresar con google'),
          ),
        ),
        const SizedBox(height: 30.0 -20,),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Register(context: context)),
            );
          }, 
          child: Text.rich(
            TextSpan(
              text: '¿Ya tienes una cuenta hecha?',
              style: Theme.of(context).textTheme.bodyText1,
              children: const[
                TextSpan(
                  text: ' Registrate',
                  style: TextStyle(color: Colors.blue),
                )
              ]
            )
          ),
        )
      ],
    );
  }
}

