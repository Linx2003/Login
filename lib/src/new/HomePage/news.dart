import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'customBar.dart';
import 'newsSection.dart';

class NewsApp extends StatelessWidget {
  static const String id = 'news_app';

  NewsApp({Key? key}) : super(key: key);

  final CollectionReference postsRef = FirebaseFirestore.instance.collection('Publicaciones');

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            NewsSection(postsRef: postsRef),
          ],
        ),
      bottomNavigationBar: CustomBar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff4245ff),
        onPressed: () {},
        child: Icon(
          Icons.add,
          size: 34,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}