import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../UserData.dart'; // Importa esta línea

class NewPostScreen extends StatefulWidget {
  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  String _currentText = '';
  File? _selectedProfileImage;
  File? _selectedPostImage;
  bool _showDeleteIcon = false;
  late String nombreAutor;

  @override
  void initState() {
    super.initState();
    _getUserName().then((value) {
      setState(() {
        nombreAutor = UserData.userName ?? value;
      });
    });
  }

  void _updateText(String newText) {
    setState(() {
      _currentText = newText;
    });
  }

  void _clearText() {
    setState(() {
      _currentText = '';
    });
  }

  Future<String> _getUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('Usuario').doc(user.uid).get();
      return userSnapshot['Usuario'] ?? 'Nombre del autor';
    }
    return 'Nombre del autor';
  }

  Future<void> _selectImageFromGallery() async {
    final pickedImage = await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        if (_selectedPostImage == null) {
          _selectedPostImage = File(pickedImage.path);
          _showDeleteIcon = true;
        } else {
          _selectedProfileImage = File(pickedImage.path);
        }
      });
    }
  }

  void _clearSelectedImage() {
    setState(() {
      if (_selectedProfileImage != null) {
        _selectedProfileImage = null;
      } else if (_selectedPostImage != null) {
        _selectedPostImage = null;
        _showDeleteIcon = false;
      }
    });
  }

  Future<File?> _getUserProfileImage() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('Usuario').doc(user.uid).get();
      String imagePath = userSnapshot['ImagenPerfil'];
      if (imagePath != null) {
        Reference storageReference = FirebaseStorage.instance.ref().child(imagePath);
        final data = await storageReference.getData();
        if (data != null) {
          Directory tempDir = await getTemporaryDirectory();
          String tempPath = tempDir.path;
          String imageName = imagePath.split('/').last;
          File tempFile = File('$tempPath/$imageName');
          await tempFile.writeAsBytes(data);
          return tempFile;
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              _publishPost();
            },
            child: Text(
              'Publicar',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 24,
                      child: FutureBuilder<File?>(
                        future: _getUserProfileImage(),
                        builder: (BuildContext context, AsyncSnapshot<File?> snapshot) {
                          if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                            return CircleAvatar(
                              backgroundImage: FileImage(snapshot.data!),
                            );
                          } else {
                            return Icon(Icons.person, color: Colors.white);
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        onChanged: _updateText,
                        maxLength: 500,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: 'Escribe tu publicación',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_showDeleteIcon)
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: _clearSelectedImage,
                      ),
                  ],
                ),
              ),
              _selectedPostImage != null
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(40.0, 0, 20.0, 0),
                      child: Image.file(
                        _selectedPostImage!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(),
            ],
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: _selectImageFromGallery,
              child: Icon(Icons.image),
            ),
          ),
        ],
      ),
    );
  }

  void _publishPost() {
    CollectionReference postCollection = FirebaseFirestore.instance.collection('Publicaciones');
    String postId = postCollection.doc().id;
    DateTime fechaCreacion = DateTime.now();
    User? user = FirebaseAuth.instance.currentUser;

    Map<String, dynamic> postData = {
      'fechaCreacion': fechaCreacion,
      'nombreAutor': nombreAutor,
      'texto': _currentText,
    };

    postCollection.doc(postId).set(postData).then((value) {
      if (_selectedPostImage != null) {
        String imagePath = 'Publicaciones/$postId/${postId}_image.jpg';
        Reference storageReference = FirebaseStorage.instance.ref().child(imagePath);
        UploadTask uploadTask = storageReference.putFile(_selectedPostImage!);

        uploadTask.then((TaskSnapshot snapshot) {
          storageReference.getDownloadURL().then((imageUrl) {
            postCollection.doc(postId).update({'imagen': imageUrl}).then((value) {
              Navigator.pop(context);
            }).catchError((error) {
              // Maneja el error de actualizar el campo de la imagen en el documento del post
            });
          }).catchError((error) {
            // Maneja el error de obtener la URL de descarga de la imagen
          });
        }).catchError((error) {
          // Maneja el error de subir la imagen a Firestore Storage
        });
      } else {
        Navigator.pop(context);
      }
    }).catchError((error) {
      // Maneja el error de guardar el post en Firestore
    });
  }
}
