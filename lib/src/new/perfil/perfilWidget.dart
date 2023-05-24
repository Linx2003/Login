import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Chats/chat.dart';
import '../UserData.dart';

class ProfilePage extends StatefulWidget {

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? userId;
  String? imageUrl;
  String? userName;
  String? email;
  File? _imageFile;
  int views = 0;
  int followers = 0;
  int following = 0;


  @override
  void initState() {
    userId = FirebaseAuth.instance.currentUser?.uid;
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection('Usuario').doc(userId).get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;

        setState(() {
          userName = userData['Usuario'];
          email = userData['Email'];
          imageUrl = userData['ImagenPerfil'];
        });
      }
    } catch (e) {
      // Manejar el error en caso de que la consulta falle
      print('Error al obtener los datos del usuario: $e');
    }
  }

  Future<void> _pickImageFromGallery() async {
    final pickedImage = await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  Future<void> _uploadImageToFirebase() async {
    if (_imageFile == null) return;

    try {
      final storageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('Perfil/$userName/${DateTime.now().toString()}.jpg');

      await storageRef.putFile(_imageFile!);
      final newImageUrl = await storageRef.getDownloadURL();

      setState(() {
        imageUrl = newImageUrl;
      });

      // Actualizar el campo "ImagenPerfil" en la colección "Usuario"
      final userQuery = await FirebaseFirestore.instance
          .collection('Usuario')
          .where('Usuario', isEqualTo: userName)
          .limit(1)
          .get();

      if (userQuery.docs.isNotEmpty) {
        final userDocRef = userQuery.docs.first.reference;

        await userDocRef.update({
          'ImagenPerfil': newImageUrl,
        });
      }
    } catch (e) {
      // Manejar el error en caso de que la subida falle
      print('Error al subir la imagen: $e');
    }
  }

  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: () {
        _pickImageFromGallery().then((_) {
          fetchUserData();
          _uploadImageToFirebase();
        });
      },
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.width * 0.4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFAAC8A7),
            ),
            child: ClipOval(
              child: imageUrl != null && imageUrl!.isNotEmpty
                  ? Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                    )
                  : Icon(
                      Icons.person,
                      size: MediaQuery.of(context).size.width * 0.2,
                      color: Colors.white,
                    ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(255, 255, 255, 255),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.6,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.chat_bubble_outline_rounded),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Chat()),
                            );
                          },
                        ),
                        Text(
                          'Mi perfil',
                          style: GoogleFonts.josefinSans(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 158, 235, 187),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.power_settings_new),
                          onPressed: () {
                            // Acción cuando se presiona el icono de apagado
                            
                          },
                        ),
                      ],
                    ),
                    _buildProfileImage(),
                    Text.rich(
                      TextSpan(
                        text: '${UserData.userName ?? ''}',
                        style: GoogleFonts.josefinSans(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: '\n' + ('${UserData.email ?? ''}'),
                            style: GoogleFonts.josefinSans(
                              fontSize: 20,
                              color: Colors.black38,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              views.toString(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: GoogleFonts.josefinSans().fontFamily,
                              ),
                            ),
                            Text(
                              'Vistas',
                              style: TextStyle(
                                fontSize: 19,
                                fontFamily: GoogleFonts.josefinSans().fontFamily,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              followers.toString(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: GoogleFonts.josefinSans().fontFamily,
                              ),
                            ),
                            Text(
                              'Seguidores',
                              style: TextStyle(
                                fontSize: 19,
                                fontFamily: GoogleFonts.josefinSans().fontFamily,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              following.toString(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: GoogleFonts.josefinSans().fontFamily,
                              ),
                            ),
                            Text(
                              'Siguiendo',
                              style: TextStyle(
                                fontSize: 19,
                                fontFamily: GoogleFonts.josefinSans().fontFamily,
                              ),
                            ),
                          ],
                        ),
                      ],
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
