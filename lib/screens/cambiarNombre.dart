import 'package:diefpc/screens/home.dart';
import 'package:flutter/material.dart';

class CambioNombreScreen extends StatefulWidget{
  @override
  _CambioNombreScreenState createState() => _CambioNombreScreenState();
}

class _CambioNombreScreenState extends State<CambioNombreScreen> {
  var correo = 'Francisco';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cambiar Correo"),
        /*actions: <Widget>[
          IconButton(icon: Icon(Icons.list),
              tooltip: 'Configuración',
              onPressed: (){
                configMenu(context);
              }
          ),
        ],*/
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Go back'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()));
          },
        ),
      ),
    );
  }
}