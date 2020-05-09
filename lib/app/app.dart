import 'package:diefpc/screens/createScreen.dart';
import 'package:diefpc/screens/home.dart';
import 'package:diefpc/states/login_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:diefpc/screens/cambiarContrasena.dart';
import 'package:diefpc/screens/cambiarCorreo.dart';
import 'package:diefpc/screens/login.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Todas sus apliaciones deben de estar dentro de Material App para poder
    // hacer uso de las facilidades de Material Design puede omitirce esto pero
    // no podran hacer uso de estos widgets de material.dart
    return ChangeNotifierProvider<LoginState>(
      builder: (BuildContext context) => LoginState( ),
      child: MaterialApp(
        title: "DIEFP-C",
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light( ),
//        theme: ThemeData.dark(),
        routes: {
          // ignore: missing_return
          "/": (BuildContext context) {
            var state = Provider.of<LoginState>( context );
            if (state.isLoggedIn()){
              return HomeScreen();
            }
            else{
              return LoginScreen();
            }
          }
        },
      ),
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
            children: <Widget>[
              Card(
                child: ListTile(
                  leading: IconButton(icon: Icon(Icons.supervised_user_circle),
                    iconSize: 40,
                    tooltip: 'Cambio de Contraseña',
                    onPressed: (){
                      goToCambioNombre(context);
                    },
                  ),
                  title: Text('Cambiar Correo'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: IconButton(icon: Icon(Icons.lock),
                    iconSize: 40,
                    tooltip: 'Cambio de Nombre',
                    onPressed: (){
                      goToCambioContrasena(context);
                    },
                  ),
                  title: Text('Cambiar Contraseña'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: IconButton(icon: Icon(Icons.power_settings_new),
                    iconSize: 40,
                    tooltip: 'Cerrar Sesión',
                    onPressed: () async {
                      await showDialog<void>(
                      context: context,
                      builder: (BuildContext context){
                        return AlertDialog(
                          title: const Text('¿Estás seguro de cerrar sesión?'),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: (){
                                Provider.of<LoginState>(context).logout();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>MyApp()));
                              },
                              child: const Text('Si'),
                            ),
                            FlatButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              child: const Text('No'),
                            )
                          ],
                        );
                      }
                      );
                    },
                  ),
                  title: Text('Cerrar Sesión'),
                ),
                  //subtitle: Text(''),
                  //trailing: Icon(Icons.more_vert),
                  //isThreeLine: true,
              )
            ],
          ),
          //backgroundColor: Colors.cyanAccent,
        );
      },
    ),
  );
}

void alertaCerrarSesion(BuildContext context) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text("Alert Dialog title"),
        content: new Text("Alert Dialog body"),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void alertText(){

}

void goToCambioContrasena(BuildContext context){
  Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CambioContrasenaScreen()));
}
void goToCambioNombre(BuildContext context){
  Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CambioCorreoScreen()));
}