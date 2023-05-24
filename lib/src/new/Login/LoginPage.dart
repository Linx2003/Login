import 'package:flutter/material.dart';
import 'LoginFooter.dart';
import 'LoginHead.dart';
import 'loginForm.dart';

class LoginPage extends StatelessWidget {
  static const String id = 'login_page';

  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LoginHead(size: size),
                LoginForm(context: context),
                LoginFooter(context: context,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}