import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                'https://9to5mac.com/wp-content/uploads/sites/6/2021/08/twitter-sign-in.jpg?quality=82&strip=all',
                width: 300,
                height: 200,
                color: Colors.deepPurple, // Cambio de color de la imagen a morado
                colorBlendMode: BlendMode.multiply, // Mezcla el color con la imagen
              ),
              SizedBox(height: 20.0),
              TextField(
                style: TextStyle(color: Colors.black), // Color de texto negro
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200], // Color de fondo del campo de texto
                  hintText: 'Nombre de usuario',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              TextField(
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: 'Contraseña',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Acción al hacer clic en el botón
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurple, // Color de fondo del botón morado
                  onPrimary: Colors.white, // Color de texto del botón blanco
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                ),
                child: Text(
                  'Registrarse',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              SizedBox(height: 10.0),
              TextButton(
                onPressed: () {
                  // Acción al hacer clic en el enlace de inicio de sesión
                  Navigator.pushNamed(context, '/login'); // Reemplaza '/login' con la ruta de la página de inicio de sesión
                },
                style: TextButton.styleFrom(
                  primary: Colors.black, // Color de texto negro
                ),
                child: Text('¿Ya tienes una cuenta? Inicia sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
