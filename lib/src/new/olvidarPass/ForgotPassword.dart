import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController _phoneNumberController = TextEditingController();

  Future<void> _sendEmail(BuildContext context) async {
    final phoneNumber = _phoneNumberController.text;

    // Buscar el correo asociado al número de teléfono en la colección "Usuario"
    final snapshot = await FirebaseFirestore.instance
        .collection('Usuario')
        .where('Celular', isEqualTo: phoneNumber)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final email = snapshot.docs.first['Email'];

      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Éxito'),
              content: Text('Se ha enviado un correo electrónico con instrucciones para restablecer la contraseña.'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Aceptar'),
                ),
              ],
            );
          },
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Ha ocurrido un error al intentar restablecer la contraseña. Por favor, intenta nuevamente.'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Aceptar'),
                ),
              ],
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('No se encontró ningún usuario con el número de teléfono proporcionado.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Aceptar'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 30.0 * 4),
                const FormHeaderWidget(
                  image: 'images/panda.jpeg',
                  title: '¿Se olvidó la contraseña?',
                  subtitle: 'Escriba su número de teléfono y se enviará un correo electrónico de restablecimiento de contraseña',
                  crossAxisAlignment: CrossAxisAlignment.center,
                  heightBetween: 30.0,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20.0),
                Form(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextFormField(
                          controller: _phoneNumberController,
                          decoration: const InputDecoration(
                            labelText: 'Número de teléfono',
                            hintText: '1234567890',
                            prefixIcon: Icon(Icons.phone),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _sendEmail(context),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue, // Cambia el color del botón aquí
                          ),
                          child: const Text('Siguiente'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FormHeaderWidget extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final CrossAxisAlignment crossAxisAlignment;
  final double heightBetween;
  final TextAlign textAlign;

  const FormHeaderWidget({
    Key? key,
    required this.image,
    required this.title,
    required this.subtitle,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.heightBetween = 20.0,
    this.textAlign = TextAlign.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Image.asset(
          image,
          width: size.width * 0.4,
        ),
        SizedBox(height: heightBetween),
        Text(
          title,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
          textAlign: textAlign,
        ),
        SizedBox(height: heightBetween),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 16.0,
          ),
          textAlign: textAlign,
        ),
      ],
    );
  }
}
