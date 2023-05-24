import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../HomePage/news.dart';
import '../Register/signUp.dart';

class LoginFooter extends StatelessWidget {
  final BuildContext context;
  LoginFooter({Key? key, required this.context}) : super (key: key);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      return userCredential;
    } on PlatformException catch (e) {
      print('Error signing in with Google: ${e.message}');
    return null;
    }catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }

  Future<void> saveUserToFirestore(User user) async {
    try {
      final CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');

      final userData = {
        'id': user.uid,
        'usuario': user.displayName,
        'celular': '',
        'contraseña': '',
        'email': user.email,
      };

      await usersCollection.doc(user.uid).set(userData);
    } catch (e) {
      print('Error saving user to Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("O"),
          const SizedBox(height: 30.0 - 20),
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
                children: const [
                  TextSpan(
                    text: ' Registrate',
                    style: TextStyle(color: Color(0xFFAAC8A7)),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
