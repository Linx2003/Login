import 'package:flutter/material.dart';

class ForgetPasswordBtn extends StatelessWidget {
  const ForgetPasswordBtn({
    required this.btnIcon,
    required this.onPressed,
    required this.title,
    required this.subtitle,
    Key? key
  }) : super(key: key);

  final IconData btnIcon;
  final String title, subtitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade200
      ),
      onPressed: onPressed, 
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: Row(
          children: [
            Icon(btnIcon, size: 50.0, color: Colors.black,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title, 
                  style: Theme.of(context).textTheme.headline6
                ),
                Text(
                  subtitle, 
                  style: Theme.of(context).textTheme.bodyText2
                ),
              ],
            )
          ]
        ),
      )
    );
  }
}