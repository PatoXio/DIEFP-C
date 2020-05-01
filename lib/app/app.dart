import 'package:flutter/material.dart';
import 'package:diefpc/screens/splashScreen.dart';
import 'package:flutter_test/flutter_test.dart';



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Todas sus apliaciones deben de estar dentro de Material App para poder
    // hacer uso de las facilidades de Material Design puede omitirce esto pero
    // no podran hacer uso de estos widgets de material.dart
    return MaterialApp(
      debugShowCheckedModeBanner: false,
//      theme: ThemeData.light(), //  Tema Claro
      theme: ThemeData.dark(), // Tema Obscuro
      home: SplashScreen(),
    );
  }
}

void configMenu(BuildContext context){
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text( 'Congifuración' ),
          ),
          body: ListView(
            children: const <Widget>[
              Card(
                child:
                ListTile(
                  leading: Icon(Icons.supervised_user_circle),
                  title: Text('Cambiar Nombre'),
                ),
              ),
              Card(
                child:
                ListTile(
                  leading: Icon(Icons.lock),
                  title: Text('Cambiar Contraseña'),
                ),
              ),
              Card(
                child:
                ListTile(
                  leading: Icon(Icons.power_settings_new),
                  title: Text('Cerrar Sesión'),
                  //subtitle: Text(''),
                  //trailing: Icon(Icons.more_vert),
                  //isThreeLine: true,
                ),
              )
            ],
          ),
          //backgroundColor: Colors.cyanAccent,
        );
      },
    ),
  );
}