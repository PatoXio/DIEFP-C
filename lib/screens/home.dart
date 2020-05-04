import 'package:diefpc/screens/Menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:diefpc/app/app.dart';
import 'dart:core';


class HomeScreen extends StatelessWidget {
  final String id;
  HomeScreen({Key key, @required this.id}) : super(key: key);
initState(){

}

  static Route<dynamic> route(String id) {
    return MaterialPageRoute(
      builder: (context) => HomeScreen(id: id),
    );
  }
  @override
  Widget build(BuildContext context) {
    String rut = id;
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
                  child: Text('\nBienvenido $rut\n\nEsperemos que tengas un buen día\n', style: TextStyle(fontSize: 20),
                  ),
                ),
          ),
          SizedBox(
            height: 50,
          ),
          Card(
            child: RaisedButton(
             onPressed: (){
               goToMenu(context, rut);
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
void goToMenu(BuildContext context, String rut){
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => MenuScreen(id: rut)));
}