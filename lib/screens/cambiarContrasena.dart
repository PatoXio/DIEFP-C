import 'package:flutter/material.dart';

class CambioContrasenaScreen extends StatefulWidget{
  @override
  _CambioContrasenaScreenState createState() => _CambioContrasenaScreenState();
}

class _CambioContrasenaScreenState extends State<CambioContrasenaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cambiar Contraseña"),
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
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}