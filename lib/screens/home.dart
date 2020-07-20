import 'package:diefpc/screens/Menu.dart';
import 'package:diefpc/states/login_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:diefpc/app/app.dart';
import 'dart:core';
import 'package:provider/provider.dart';

import 'MenuTienda.dart';
import 'createScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
// ignore: must_be_immutable
class _HomeScreenState extends State<HomeScreen> {
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  double screenHeight;
  String name;
  String rol;
  var _user;
  var isComplete;
  String elTiempo;
  String email;
  @override
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    _user = Provider.of<LoginState>(context).currentUser();
    isComplete = Provider.of<LoginState>(context).isComplete();
    rol = Provider.of<LoginState>(context).getRol();
    screenHeight = MediaQuery.of(context).size.height;
    name = _user.displayName;
    email = _user.email;
    elTiempo = _elTiempo();

    return Scaffold(
        //drawer: Text( 'Hola perro ql bastardo y la ctm uwu' ),
        appBar: AppBar(
          title: Text('¡Bienvenido!'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.list),
                tooltip: 'Configuración',
                onPressed: () {
                  configMenu(context);
                }),
          ],
          leading: new IconButton(
            icon: new Icon(Icons.home, color: Colors.blue),
            onPressed: (){},
          ),
        ),
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 5,
            ),
            Container(
                margin: EdgeInsets.only(top: screenHeight / 100),
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Column(children: <Widget>[
                  Card(
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                        ListTile(
                          leading: Icon(
                            Icons.account_box,
                            size: 45,
                          ),
                          title: Text(
                            "Hola, ${name.split(" ")[0]}.",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text("$elTiempo",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        ListTile(
                          leading: Icon(
                            _selectIcon(rol),
                            size: 45,
                          ),
                          title: Text(
                            "Tu rol de Usuario es: ${_rol(rol)}.",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.email,
                            size: 45,
                          ),
                          title: Text(
                            "Correo: $email.",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ])),
                ])),
            SizedBox(
              height: 5,
            ),
            Consumer<LoginState>(
              // ignore: missing_return
              builder: (BuildContext context, LoginState value, child){
                if(value.isLoading())
                  return CircularProgressIndicator();
                else
                  return _boton(context, isComplete, rol);
              },
            ),
          ],
        ),
    );
  }
   _selectIcon(String rol){
    if (rol.compareTo("Delivery") == 0)
      return Icons.directions_bike;
    else
      if(rol.compareTo("Tienda") == 0)
        return Icons.local_hospital;
      else
        return Icons.supervised_user_circle;
  }

  Widget _boton(BuildContext context, bool isComplete, String rol){
    if(Provider.of<LoginState>(context).isComplete() == false) {
      return FloatingActionButton.extended(
        onPressed: () {
          Navigator.push( context,
              MaterialPageRoute( builder: (context) => CreateScreen( ) ) );
        },
        label: Text("Completar\nDatos", style: TextStyle(fontSize: 20)),
        icon: Icon( Icons.widgets, size: 40, ),
        backgroundColor: Colors.blue,
      );
    }
    else
      return FloatingActionButton.extended(
        onPressed: () {
          if(rol.compareTo("Tienda") == 0)
            goToMenuTienda(context);
          else
            if(rol.compareTo("Delivery") == 0)
              goToMenuUsuario(context);
            else
              goToMenuUsuario(context);
        },
        label: Text( "Menú", style: TextStyle( fontSize: 20 ) ),
        icon: Icon( Icons.widgets, size: 40, ),
        backgroundColor: Colors.blue,
      );

  }

  void goToMenuUsuario(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MenuScreen()));
  }

  void goToMenuTienda(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MenuScreenTienda()));
  }

  String _rol(String rol){
    if(rol.compareTo("Normal") == 0)
      return "Común";
    return rol;
  }

  // ignore: missing_return
  String _elTiempo() {
    DateTime now = DateTime.now();

    if (now.hour >= 6 && now.hour <= 12) {
      return "Buenos Dias";
    } else {
      if (now.hour >= 12 && now.hour <= 19) {
        return "Buenas Tardes";
      } else {
        if (now.hour >= 19 && now.hour <= 24) {
          return "Buenas Noches";
        } else {
          if (now.hour < 6) {
            return "!AL QUE MADRUGA DIOS LO AYUDA! \tRecuerda dormir temprano";
          }
        }
      }
    }
  }
}
