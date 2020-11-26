import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diefpc/documents/documents_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:diefpc/app/app.dart';
import 'dart:core';

class PerfilDelivery extends StatefulWidget {
  String delivery;
  PerfilDelivery({this.delivery}) {
    this.delivery = delivery;
  }
  @override
  _PerfilDeliveryState createState() => _PerfilDeliveryState();
}

class _PerfilDeliveryState extends State<PerfilDelivery> {
  double screenHeight;
  DocumentSnapshot delivery;

  void cargarDelivery() async {
    DocumentSnapshot deli = await getDataDocumentService(widget.delivery);
    if (deli != null) {
      setState(() {
        delivery = deli;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    cargarDelivery();
    if (delivery == null) {
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
      screenHeight = MediaQuery.of(context).size.height;
      return Scaffold(
        appBar: AppBar(
          title: Text('Perfil Del Delivery'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.list),
                tooltip: 'Configuración',
                onPressed: () {
                  configMenu(context);
                }),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
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
                                  "Nombre: ${delivery.data["nombre"]}.",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.assignment_ind,
                                  size: 45,
                                ),
                                title: Text(
                                  "Rut: ${delivery.data["Rut"]}.",
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
                                  "Correo: ${delivery.data["email"]}.",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.phone_iphone,
                                  size: 45,
                                ),
                                title: Text(
                                  "Numero: ${delivery.data["numero"]}.",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.motorcycle,
                                  size: 45,
                                ),
                                title: Text(
                                  "Transporte: ${delivery.data["transporte"]}.",
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
                FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  label: Text("Atrás", style: TextStyle(fontSize: 20)),
                  icon: Icon(
                    Icons.keyboard_backspace,
                    size: 40,
                  ),
                  backgroundColor: Colors.blue,
                )
              ],
            ),
          ),
        ),
      );
    }
  }

  /*String _rol(String rol) {
    if (rol.compareTo("Cliente") == 0) return "Cliente";
    return rol;
  }*/

  // ignore: missing_return
}
