import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Header.dart';

class ForgetPassword extends StatelessWidget {
  TextEditingController _emailController = TextEditingController();
  ForgetPassword({Key? key}) : super(key: key);

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
                  title: '¿Olvidó la contraseña?',
                  subtitle: 'Seleccione una de las opciones a continuación para recuperar la contraseña',
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
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            hintText: 'ejemplo@gmail.com',
                            prefixIcon: Icon(Icons.mail_outline_rounded),
                            border: OutlineInputBorder()  //caja
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            String email = _emailController.text;
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
                          },
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
