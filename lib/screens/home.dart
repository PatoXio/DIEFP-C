import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diefpc/screens/Menu.dart';
import 'package:diefpc/states/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:diefpc/app/app.dart';
import 'package:provider/provider.dart';
import 'dart:core';
import 'MenuTienda.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double screenHeight;
  var isComplete;
  String elTiempo;
  var user;
  DocumentSnapshot document;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    user = Provider.of<AuthService>(context).currentUser();
    if (user == null) {
      return Material(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 100.0,
            ),
            Flexible(
              flex: 2,
              child: SafeArea(
                child: FractionallySizedBox(
                  widthFactor: 0.7,
                  //child: Image.asset('assets/argelbejarano.png'),
                ),
              ),
            ),
            Text(
              "Cargando Datos...",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
              ),
            ),
            CircularProgressIndicator(),
          ],
        ),
      );
    } else {
      document = Provider.of<AuthService>(context).getDocument();
      elTiempo = _elTiempo();
      screenHeight = MediaQuery.of(context).size.height;
      return Scaffold(
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
            icon: new Icon(Icons.home, color: Colors.white),
            onPressed: () {},
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
                              "Hola, ${user.getName()}.",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text("${_elTiempo()}",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          ListTile(
                            leading: Icon(
                              _selectIcon(user.getTipo()),
                              size: 45,
                            ),
                            title: Text(
                              "Tu rol de Usuario es: ${user.getTipo()}.",
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
                              "Correo: ${user.getEmail()}.",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ]),
                  )
                ])),
            SizedBox(
              height: 5,
            ),
            Consumer<AuthService>(
              // ignore: missing_return
              builder: (BuildContext context, AuthService value, child) {
                if (value.isLoading())
                  return CircularProgressIndicator();
                else
                  return _boton(context, value.isComplete(), user.getTipo());
              },
            ),
          ],
        ),
      );
    }
  }

  _selectIcon(String rol) {
    if (rol == null) return Icons.access_alarms;
    if (rol.compareTo("Delivery") == 0)
      return Icons.directions_bike;
    else if (rol.compareTo("Tienda") == 0)
      return Icons.local_hospital;
    else
      return Icons.supervised_user_circle;
  }

  Widget _boton(BuildContext context, bool isComplete, String rol) {
    if (Provider.of<AuthService>(context).isComplete() == false) {
      return FloatingActionButton.extended(
        onPressed: () {
          /*Navigator.push(
                context, MaterialPageRoute(builder: (context) => CreateScreen()));*/
        },
        label: Text("  Añadir\nDireccion", style: TextStyle(fontSize: 20)),
        icon: Icon(
          Icons.widgets,
          size: 40,
        ),
        backgroundColor: Colors.blue,
      );
    } else
      return FloatingActionButton.extended(
        onPressed: () {
          if (rol.compareTo("Tienda") == 0)
            goToMenuTienda(context);
          else if (rol.compareTo("Delivery") == 0)
            goToMenuDelivery(context);
          else
            goToMenuUsuario(context);
        },
        label: Text("Menú", style: TextStyle(fontSize: 20)),
        icon: Icon(
          Icons.widgets,
          size: 40,
        ),
        backgroundColor: Colors.blue,
      );
  }

  void goToMenuUsuario(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MenuScreen()));
  }

  void goToMenuDelivery(BuildContext context) {}

  void goToMenuTienda(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MenuScreenTienda()));
  }

  /*String _rol(String rol) {
    if (rol.compareTo("Cliente") == 0) return "Cliente";
    return rol;
  }*/

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
