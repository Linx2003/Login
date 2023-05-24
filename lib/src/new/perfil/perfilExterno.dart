import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class PerfilExterno extends StatefulWidget {
  @override
  _PerfilExternoState createState() => _PerfilExternoState();
}

class _PerfilExternoState extends State<PerfilExterno> {
  String? userName;
  File? profileImage;
  bool profileImageExists = false;
  String? imageUrl;
  int views = 0;
  int followers = 0;
  int following = 0;

  @override
  void initState() {
    super.initState();
    fetchUserName();
    checkProfileImageExists();
  }

  void fetchUserName() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Usuario')
          .where('Email', isEqualTo: currentUser.email)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          userName = snapshot.docs[0]['Usuario'];
        });

        fetchProfileImage(snapshot.docs[0].id); // Llama a fetchProfileImage con el ID del usuario
      }
    }
  }

  Future<void> openGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        profileImage = File(pickedImage.path);
      });

      if (profileImage != null) {
        User? currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          String? imageUrl = await uploadImageToFirebase(profileImage!, currentUser.uid);
          if (imageUrl != null) {
            saveProfileImageToFirestore(currentUser.uid, imageUrl);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Imagen de perfil guardada con éxito.')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error al guardar la imagen de perfil.')),
            );
          }
        }
      }
    }
  }

  Future<String?> uploadImageToFirebase(File imageFile, String userId) async {
    try {
      String fileName = 'perfil.jpg';
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('Perfil')
          .child(userId)
          .child(fileName);
      UploadTask uploadTask = storageReference.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> saveProfileImageToFirestore(String userId, String imageUrl) async {
    try {
      await FirebaseFirestore.instance
          .collection('Usuario')
          .doc(userId)
          .update({'ImagenPerfil': imageUrl});
    } catch (e) {
      print(e);
    }
  }

  Future<void> checkProfileImageExists() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String folderPath = 'Perfil/${currentUser.uid}';
      Reference folderReference = FirebaseStorage.instance.ref().child(folderPath);
      ListResult result = await folderReference.listAll();
      bool imageExists = result.items.isNotEmpty;

      setState(() {
        profileImageExists = imageExists;
      });
    }
  }

  Future<void> fetchProfileImage(String userId) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Usuario')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        dynamic userData = snapshot.data();
        String? profileImageUrl = userData != null ? userData['ImagenPerfil'] : null;
        if (profileImageUrl != null) {
          setState(() {
            imageUrl = profileImageUrl;
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: size.height * 0.6,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 48), 
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
                    GestureDetector(
                      onTap: () {
                        openGallery();
                      },
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: size.width * 0.4,
                            height: size.width * 0.4,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFAAC8A7),
                              image: profileImage != null
                                  ? DecorationImage(
                                      image: FileImage(profileImage!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: imageUrl != null
                              ? Container(
                                  width: size.width * 0.4,
                                  height: size.width * 0.4,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFAAC8A7),
                                    image: DecorationImage(
                                      image: NetworkImage(imageUrl!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : Icon(
                                  Icons.person,
                                  size: size.width * 0.2,
                                  color: Colors.white,
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
                    ),
                    Text.rich(
                      TextSpan(
                        text: userName ?? 'Usuario',
                        style: GoogleFonts.josefinSans(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: '\n' + (currentUser?.email ?? 'example@gmail.com'),
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
                                fontFamily: GoogleFonts.josefinSans().fontFamily, // Estilo de fuente agregado
                              ),
                            ),
                            Text(
                              'Vistas',
                              style: TextStyle(
                                fontSize: 19,
                                fontFamily: GoogleFonts.josefinSans().fontFamily, // Estilo de fuente agregado
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
                                fontFamily: GoogleFonts.josefinSans().fontFamily, // Estilo de fuente agregado
                              ),
                            ),
                            Text(
                              'Seguidores',
                              style: TextStyle(
                                fontSize: 19,
                                fontFamily: GoogleFonts.josefinSans().fontFamily, // Estilo de fuente agregado
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
                                fontFamily: GoogleFonts.josefinSans().fontFamily, // Estilo de fuente agregado
                              ),
                            ),
                            Text(
                              'Siguiendo',
                              style: TextStyle(
                                fontSize: 19,
                                fontFamily: GoogleFonts.josefinSans().fontFamily, // Estilo de fuente agregado
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFAAC8A7),
                            textStyle: TextStyle(
                              fontSize: 20,
                              fontFamily: GoogleFonts.josefinSans().fontFamily,
                            ),
                          ),
                          onPressed: () {

                          }, 
                          child: Text('Seguir')
                        ),
                        SizedBox(width: 40),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFAAC8A7),
                            textStyle: TextStyle(
                              fontSize: 20,
                              fontFamily: GoogleFonts.josefinSans().fontFamily,
                            ),
                          ),
                          onPressed: () {}, 
                          child: Text('Mensaje')
                        ),
                      ],
                    )
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
