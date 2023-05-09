import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/framework.dart';

class RegistrarPage extends StatefulWidget {
  @override
  State<RegistrarPage> createState() => _RegistrarPageState();
}

class _RegistrarPageState extends State<RegistrarPage> {
  TextEditingController usuario = TextEditingController();
  TextEditingController apellido = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController celular = TextEditingController();
  TextEditingController contrasena = TextEditingController();
  final firebase=FirebaseFirestore.instance;

  registroUsuario() async{
    try{
      await firebase.collection('Usuario').doc().set(
        {
          "Nombre":usuario.text,
          "Apellido":apellido.text,
          "Email":email.text,
          "Celular":celular.text,
          "Contraseña":contrasena.text
        }
      );
    }catch (e){
      print('No hay sistema: '+e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Flexible(
              child: Image.asset(
                'images/panda.jpeg',
                width: 200, // Ajusta el ancho según tus necesidades
                height: 200, // Ajusta la altura según tus necesidades
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            _usuarioTextField(),
            SizedBox(
              height: 15,
            ),
            _apellidoTextField(),
            SizedBox(
              height: 15,
            ),
            _emailTextField(),
            SizedBox(
              height: 15,
            ),
            _celularTextField(),
            SizedBox(
              height: 15,
            ),
            _passwordTextField(),
            SizedBox(
              height: 20.0,
            ),
            _bottonRegistrarse(),
          ]),
        ),
      ),
    );
  }

  _usuarioTextField() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: TextField(
          controller: usuario,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            icon: Icon(Icons.person),
            hintText: 'Nombre',
            labelText: 'Usuario',
          ),
          onChanged: (value) {},
        ),
      );
    });
  }

  _apellidoTextField() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: TextField(
          controller: apellido,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            icon: Icon(Icons.person),
            hintText: 'Apellido',
            labelText: 'Apellido',
          ),
          onChanged: (value) {},
        ),
      );
    });
  }

  _emailTextField() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: TextField(
          controller: email,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            icon: Icon(Icons.email),
            hintText: 'ejemplo@correo.com',
            labelText: 'Correo electronico',
          ),
          onChanged: (value) {},
        ),
      );
    });
  }

  _celularTextField() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: TextField(
          controller: celular,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            icon: Icon(Icons.phone),
            hintText: '300 0000000',
            labelText: 'Celular',
          ),
          onChanged: (value) {},
        ),
      );
    });
  }

  _passwordTextField() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: TextField(
          controller: contrasena,
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
          decoration: InputDecoration(
            icon: Icon(Icons.lock),
            hintText: 'Contraseña',
            labelText: 'Contraseña',
          ),
          onChanged: (value) {},
        ),
      );
    });
  }

  _bottonRegistrarse() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
      return ElevatedButton(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
          child: Text(
            'Iniciar Sesion',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
        ),
        onPressed: () {
          print('enviandoooooo');
          registroUsuario();
          /* final snackBar = SnackBar(
            content: Text('Usuario registrado');
            
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar); */
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.amber)),
      );
    });
  }
}