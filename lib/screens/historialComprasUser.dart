import 'dart:wasm';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diefpc/states/login_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:diefpc/app/app.dart';
import 'package:provider/provider.dart';

import 'ComprarCarrito.dart';

/*class CarritoScreen extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => CarritoScreen( ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}*/
class HistorialCompras extends StatefulWidget{
  @override
  _HistorialComprasState createState() => _HistorialComprasState();
}

class _HistorialComprasState extends State<HistorialCompras>{
  final _saved = Set<String>();
  List<DocumentSnapshot> listDocuments;
  double screenlong;
  double screenHeight;
  @override
  Widget build(BuildContext context) {
    screenlong = MediaQuery.of(context).size.longestSide;
    screenHeight = MediaQuery.of(context).size.height;
    Provider.of<LoginState>(context).actualizarHistorial();
    return Scaffold(
      appBar: AppBar(
        title: Text("Historial Compras"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list),
              tooltip: 'Configuración',
              onPressed: (){
                configMenu(context);
              }
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(top: screenHeight / 100),
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: <Widget> [
            Card(child: Text("Search")),
            Container(
              height: screenHeight / 1.2,
              child: Card(
                //elevation: 5,
                margin: EdgeInsets.all(10),
                semanticContainer: true,
                //color: Colors.transparent,
                child: Theme(
                  data: ThemeData(
                    highlightColor: Colors.blue, //Does not work
                  ),
                  child: Scrollbar(
                      child:
                      _queyList(context)
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _queyList(BuildContext context) {
    listDocuments = Provider.of<LoginState>(context).getHistorial();
    if (listDocuments != null) {
      return ListView.builder(
          itemCount: listDocuments.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) => buildBody(context, index)
      );
    } else{
      return Text("No posees productos en tu carrito");
    }
  }
  Widget buildBody(BuildContext context, int index) {
     List<DocumentSnapshot> listDocuments = Provider.of<LoginState>(context).getHistorial();
     String idTienda = listDocuments[index].data["Tienda"];
     Provider.of<LoginState>(context).nombreTienda(idTienda);
     String nombre = Provider.of<LoginState>(context).getNombreTienda();
     return Card(
      child:
      ListTile(
        leading: IconButton(
          icon: Icon(Icons.local_hospital),
          iconSize: 40,
          tooltip: 'Productos', onPressed: () {
        },
        ),
        title: Text(listDocuments[index].data["Fecha"]),
        subtitle: Text("$nombre"),
        //trailing: _iconTravel(listDocuments[index].documentID),
        isThreeLine: true,
    )
    );
  }

  void goToComprarCarrito(BuildContext context){
    Navigator.push(
        context,
        MaterialPageRoute( builder: (context) => ComprarCarrito()));
  }
}