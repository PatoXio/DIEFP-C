import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diefpc/documents/documents_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:diefpc/app/app.dart';
import 'dart:core';

class DireccionScreen extends StatefulWidget {
  String id;
  DireccionScreen({this.id}) {
    this.id = id;
  }
  @override
  _DireccionScreenState createState() => _DireccionScreenState();
}

class _DireccionScreenState extends State<DireccionScreen> {
  double screenHeight;
  double screenlong;
  DocumentSnapshot direccion;

  void cargarDelivery() async {
    DocumentSnapshot deli = await getDataDocumentService(widget.id);
    if (deli != null) {
      DocumentSnapshot direc =
          await getDocumentDireccionService(widget.id, deli.data["Direccion"]);
      setState(() {
        direccion = direc;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    cargarDelivery();
    if (direccion == null) {
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
                                  Icons.streetview,
                                  size: 45,
                                ),
                                title: Text(
                                  "Calle: ${direccion.data["calle"]}.",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.location_city,
                                  size: 45,
                                ),
                                title: Text(
                                  "Ciudad: ${direccion.data["ciudad"]}.",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.photo_size_select_large,
                                  size: 45,
                                ),
                                title: Text(
                                  "Codigo Postal: ${direccion.data["codigoPostal"]}.",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.location_on,
                                  size: 45,
                                ),
                                title: Text(
                                  "País: ${direccion.data["country"]}.",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.home,
                                  size: 45,
                                ),
                                title: Text(
                                  "${direccion.data["depto"] == null ? "Número de casa: ${direccion.data["numero"]}" : "Número de Depto: ${direccion.data["depto"]}"}",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.pin_drop,
                                  size: 45,
                                ),
                                title: Text(
                                  "Provincia: ${direccion.data["provincia"]}.",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.local_airport,
                                  size: 45,
                                ),
                                title: Text(
                                  "Región: ${direccion.data["region"]}.",
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
}
