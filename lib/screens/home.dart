import 'package:diefpc/screens/Menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:diefpc/app/app.dart';
//import 'dart:core';

class HomeScreen extends StatelessWidget {
  final mensaje;
  const HomeScreen({Key key, @required this.mensaje}) : super( key: key);

  static Route<dynamic> route(String mensaje) {
    return MaterialPageRoute(
      builder: (context) => HomeScreen( mensaje: mensaje ),
    );
  }
  @override
  Widget build(BuildContext context) {
    String texto = mensaje;
    String correo = texto.split('/')[0];
    //String contrasena = texto.split('/')[1];
    return Scaffold(
      drawer: Text('Hola perro ql bastardo y la ctm uwu'),
      appBar: AppBar(
        title: Text( '¡Bienvenido!' ),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list),
              tooltip: 'Configuración',
              onPressed: (){
                configMenu(context);
              }
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
            Card(
              child:
                Center(
                  child: Text('\nBienvenido $correo\n\nEsperemos que tengas un buen día\n', style: TextStyle(fontSize: 20),
                  ),
                ),
          ),
          Card(
            child: RaisedButton(
             onPressed: (){
               goToMenu(context);
             },
              color: Colors.black26,
              child: Text('Menú',
              style: TextStyle(fontSize: 50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
void goToMenu(BuildContext context){
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => MenuScreen()));
}
