import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NewPostScreen extends StatefulWidget {
  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  String _currentText = '';
  File? _selectedProfileImage;
  File? _selectedPostImage;
  bool _showDeleteIcon = false;
  String nombreAutor = FirebaseAuth.instance.currentUser?.displayName ?? 'Nombre del autor';

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

  Future<void> _selectImageFromGallery() async {
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.gallery);

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

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
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
                      child: _selectedProfileImage != null
                          ? Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Image.file(
                                  _selectedProfileImage!,
                                  fit: BoxFit.cover,
                                ),
                                IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () => _clearSelectedImage(),
                                ),
                              ],
                            )
                          : FutureBuilder(
                              future: _getUserProfileImage(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<File?> snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    snapshot.data != null) {
                                  return CircleAvatar(
                                    backgroundImage:
                                        FileImage(snapshot.data!),
                                  );
                                } else {
                                  return Icon(Icons.person,
                                      color: Colors.white);
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
                      padding: const EdgeInsets.fromLTRB(
                          40.0, 0, 20.0, 0),
                      child: Image.file(
                        _selectedPostImage!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (_currentText.isNotEmpty)
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: _clearText,
                      ),
                  ],
                ),
              ),
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
    // Obtener una referencia a la colección "Post" en Firestore
    CollectionReference postCollection =
        FirebaseFirestore.instance.collection('Post');

    // Generar un ID automático para el nuevo post
    String postId = postCollection.doc().id;

    // Obtener la fecha actual
    DateTime fechaCreacion = DateTime.now();

    // Obtener el nombre de usuario actual
    User? user = FirebaseAuth.instance.currentUser;
    String nombreAutor = user?.displayName ?? 'Nombre del autor';

    // Crear un mapa con los datos del post
    Map<String, dynamic> postData = {
      'fechaCreacion': fechaCreacion,
      'nombreAutor': user?.displayName ?? 'Nombre del autor',
      'texto': _currentText,
    };

    // Guardar el post en Firestore
    postCollection.doc(postId).set(postData).then((value) {
      // Éxito al guardar el post, ahora puedes subir la imagen a Firestore Storage

      if (_selectedPostImage != null) {
        // Subir la imagen a Firestore Storage
        String imagePath = 'Post/$postId/${postId}_image.jpg'; // Ruta de almacenamiento en Firestore Storage
        Reference storageReference =
            FirebaseStorage.instance.ref().child(imagePath);
        UploadTask uploadTask = storageReference.putFile(_selectedPostImage!);

        uploadTask.then((TaskSnapshot snapshot) {
          // Obtener la URL de descarga de la imagen
          storageReference.getDownloadURL().then((imageUrl) {
            // Actualizar el campo de la imagen en el documento del post
            postCollection.doc(postId).update({'imagen': imageUrl}).then((value) {
              // La URL de la imagen se ha guardado correctamente en el documento del post
              // Puedes realizar cualquier otra acción que desees
              Navigator.pop(context);
            }).catchError((error) {
              // Error al actualizar el campo de la imagen en el documento del post
              // Maneja el error de acuerdo a tus necesidades
            });
          }).catchError((error) {
            // Error al obtener la URL de descarga de la imagen
            // Maneja el error de acuerdo a tus necesidades
          });
        }).catchError((error) {
          // Error al subir la imagen a Firestore Storage
          // Maneja el error de acuerdo a tus necesidades
        });
      }else{
        //No se seleccionó ninguna imagen, volver a la pantalla anterior
        Navigator.pop(context);
      }
    }).catchError((error) {
      // Error al guardar el post en Firestore
      // Maneja el error de acuerdo a tus necesidades
    });
  }

  Future<File?> _getUserProfileImage() async {
    // Lógica para obtener la imagen de perfil del usuario
    // Aquí debes implementar tu propia lógica para obtener el archivo de imagen correspondiente a la foto de perfil del usuario
    // Puedes retornar null si no hay ninguna imagen de perfil guardada
    return null;
  }
}