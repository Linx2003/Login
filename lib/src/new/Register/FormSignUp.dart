import 'package:flutter/material.dart';

class FormSignUp extends StatelessWidget{
  const FormSignUp({
      Key? key,
      required this.image,
      required this.title,
  }) : super(key: key);

  final String image, title;

  @override
  Widget build(BuildContext context){
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(image: AssetImage(image), height: size.height * 0.2),
        Text(title, style: Theme.of(context).textTheme.headline6)
      ],
    );
  }
}