import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl/intl.dart';

import 'news.dart';

class Post {
  final String postId;
  final String? imageUrl;
  final String? profileImage;
  final String authorName;
  final String text;
  final DateTime timestamp;
  final List<String> likedBy;

  Post({
    required this.postId,
    this.imageUrl,
    required this.authorName,
    required this.text,
    required this.timestamp,
    this.profileImage,
    List<String>? likedBy,
  }) : likedBy = likedBy ?? [];
}

class PostCard extends StatefulWidget {
  final Post post;
  final DateFormat dateFormatter = DateFormat('d MMM', 'es');

  PostCard({required this.post});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isImageZoomed = false;

  int getLikeCount() {
    return widget.post.likedBy.length;
  }

  String getPostTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(widget.post.timestamp);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} seg';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} h';
    } else {
      return widget.dateFormatter.format(widget.post.timestamp);
    }
  }

  Widget buildProfileImage() {
    if (widget.post.profileImage != null && widget.post.profileImage!.isNotEmpty) {
      return CircleAvatar(
        backgroundImage: NetworkImage(widget.post.profileImage!),
      );
    } else {
      return Icon(Icons.person); // Icono de persona si no hay imagen de perfil
    }
  }

  Widget buildPostImage() {
    if (widget.post.imageUrl != null && widget.post.imageUrl!.isNotEmpty) {
      return GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Scaffold(
              backgroundColor: Color.fromARGB(131, 0, 0, 0),
              body: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Center(
                  child: Image.network(
                    widget.post.imageUrl!,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            );
          }));
        },
        child: Image.network(
          widget.post.imageUrl!,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Future<String?> uploadImageToFirebase() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      String fileName = pickedImage.path.split('/').last;

      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref().child(fileName);

      try {
        await ref.putFile(File(pickedImage.path));
        String imageUrl = await ref.getDownloadURL();
        return imageUrl;
      } catch (e) {
        print('Error al cargar la imagen: $e');
        return null;
      }
    }

    return null;
  }

  void toggleLiked() {
    setState(() {
      final liked = widget.post.likedBy.contains(widget.post.postId);

      if (liked) {
        widget.post.likedBy.remove(widget.post.postId);
      } else {
        widget.post.likedBy.add(widget.post.postId);
      }

      final postRef = FirebaseFirestore.instance.collection('Publicaciones').doc(widget.post.postId);
      postRef.update({'likedBy': widget.post.likedBy}).then((value) {
        print('Me gusta actualizado exitosamente');
      }).catchError((error) {
        print('Error al actualizar el me gusta: $error');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: buildProfileImage(),
            title: Row(
              children: [
                Text(widget.post.authorName),
                SizedBox(width: 8.0),
                Text(
                  getPostTimeAgo(),
                  style: TextStyle(fontSize: 12.0, color: Colors.grey),
                ),
              ],
            ),
          ),
          buildPostImage(),
          SizedBox(height: 8.0),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(widget.post.text),
          ),
          ButtonBar(
            children: [
              IconButton(
                icon: Icon(
                  widget.post.likedBy.contains(widget.post.postId)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: widget.post.likedBy.contains(widget.post.postId)
                      ? Colors.red
                      : Colors.grey,
                ),
                onPressed: () {
                  print('me gusta');
                  toggleLiked();
                },
              ),
              Text(
                getLikeCount().toString(),
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey,
                ),
              ), // Mostrar el número de "me gusta"
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  // Acción de "Compartir"
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NewsSection extends StatelessWidget {
  const NewsSection({
    Key? key,
    required this.postsRef,
  }) : super(key: key);

  final CollectionReference<Object?> postsRef;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: postsRef.orderBy('fechaCreacion', descending: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error al cargar los datos');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        final List<Post> posts = snapshot.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final timestamp = (data['fechaCreacion'] as Timestamp).toDate();
          final likedBy = List<String>.from(data['likedBy'] ?? []);

          return Post(
            postId: doc.id,
            imageUrl: data['imagenAdjunta'],
            profileImage: data['imagenPerfil'],
            authorName: data['nombreAutor'] ?? '',
            text: data['texto'] ?? '',
            timestamp: timestamp,
            likedBy: likedBy,
          );
        }).toList();

        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return PostCard(post: post);
          },
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'News App',
    home: NewsApp(),
  ));
}
