import 'package:flutter/material.dart';
import 'package:diefpc/app/app.dart';

class HomeScreen extends StatelessWidget {
  final String mensaje;

  const HomeScreen({Key key, @required this.mensaje}) : super( key: key );

  get drawer => null;
  static Route<dynamic> route(String mensaje) {
    return MaterialPageRoute(
      builder: (context) => HomeScreen( mensaje: mensaje ),
    );
  }
  @override
  Widget build(BuildContext context) {
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
      body: Text('hola, aquí debería ir ael menú, estamos trabajando para usted'),
    );
  }
}
