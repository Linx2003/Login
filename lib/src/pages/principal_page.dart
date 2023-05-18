import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';

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
  final DateFormat dateFormatter = DateFormat('d MMM', 'ES');

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
              backgroundColor: Colors.black,
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
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        if (widget.post.likedBy.contains(user.uid)) {
          widget.post.likedBy.remove(user.uid);
        } else {
          widget.post.likedBy.add(user.uid);
        }
      });
      FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.post.postId)
          .update({'likedBy': widget.post.likedBy});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        child: Column(
          children: [
            ListTile(
              leading: buildProfileImage(),
              title: Text(widget.post.authorName),
              subtitle: Text(getPostTimeAgo()),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.post.text),
            ),
            buildPostImage(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.favorite),
                    color: widget.post.likedBy.contains(FirebaseAuth.instance.currentUser?.uid) ? Colors.red : null,
                    onPressed: toggleLiked,
                  ),
                  Text('${getLikeCount()} likes'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  static const String id = 'home_page';

  final CollectionReference postsRef =
      FirebaseFirestore.instance.collection('Publicaciones');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Red Social'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Acción para publicar
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: postsRef.snapshots(),
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
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Mi Red Social',
    home: HomePage(),
  ));
}
