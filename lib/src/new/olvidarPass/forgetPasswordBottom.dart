import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import 'ForgetPassword.dart';
import 'ForgotPassword.dart';
import 'PasswordEmail.dart';

class ForgetPasswordBottom {
  static Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¡Elige una opcion!',
              style: GoogleFonts.poppins(
                fontSize: 24.0,
                fontWeight: FontWeight.w600,
                color: Color(0xFF272727),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade200
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ForgetPassword()));
              }, 
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                child: Row(
                  children: [
                    Icon(Icons.mail_outline_rounded, size: 50.0, color: Colors.black,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gmail', 
                          style: Theme.of(context).textTheme.headline6
                        ),
                        Text(
                          'Recuperarlo por correo', 
                          style: Theme.of(context).textTheme.bodyText2
                        ),
                      ],
                    )
                  ]
                ),
              )
            ),
            const SizedBox(height: 20.0),
            ForgetPasswordBtn(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
              },
              title: 'Celular',
              subtitle: 'Recuperarlo por sms',
              btnIcon: Icons.mobile_friendly_rounded,
            ),
          ],
        ),
      ),
    );
  }
}