import 'dart:wasm';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diefpc/screens/producto.dart';
import 'package:diefpc/states/login_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:diefpc/app/app.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'ComprarCarrito.dart';

class HistorialProductos extends StatefulWidget{
  String idTienda;
  String idDocument;
  String totalPagado;
  String costoEnvio;
  HistorialProductos(String idTienda, String idDocument, String totalPagado, String costoEnvio){
    this.idTienda = idTienda;
    this.idDocument = idDocument;
    this.totalPagado = totalPagado;
    this.costoEnvio = costoEnvio;
  }
  @override
  _HistorialProductosState createState() => _HistorialProductosState();
}

class ListTileItem extends StatefulWidget{
  int index;
  String idDocument;
  ListTileItem({this.index, this.idDocument});
  @override
  _ListTileItemState createState() => new _ListTileItemState();
}

class _ListTileItemState extends State<ListTileItem> {
  @override
  Widget build(BuildContext context) {
    Provider.of<LoginState>(context).actualizarHistorialProductos(widget.idDocument);
    List<DocumentSnapshot> listDocuments = Provider.of<LoginState>(context).getHistorialProductos();
    return Card(
        child: ListTile(
          leading: IconButton(
            icon: Icon(Icons.shop_two, size: 40,),
            iconSize: 20,
            tooltip: 'Productos', onPressed: () {
          },
          ),
          title: Text(listDocuments[widget.index].data["Nombre"]),
          subtitle: TextProducto(context, listDocuments[widget.index].data.values.toList(), listDocuments[widget.index].data.keys.toList()),
          trailing: Text((int.parse(listDocuments[widget.index].data["Cantidad"])*int.parse(listDocuments[widget.index].data["Precio"])).toString()),
          isThreeLine: true,
        )
    );
  }
  Widget TextProducto(BuildContext context, List listaValues, List listaKeys){
    int i = 0;
    String info = '';
    if (listaKeys!=null){
      while(i<listaKeys.length){
        if (listaKeys[i].toString().compareTo("Tienda")!=0 && listaKeys[i].toString().compareTo("Stock")!=0) {
          if (i == 1) {
            info = "${listaKeys[i].toString( )}: ${listaValues[i].toString( )}\n";
          }
          if (i > 1) {
            info = info +"${listaKeys[i].toString( )}: ${listaValues[i].toString( )}\n";
          }
        }
        i=i+1;
      }
    }else
      info = "Este producto no posee datos";
    return Text("$info");
  }
}



class _HistorialProductosState extends State<HistorialProductos>{
  List<DocumentSnapshot> listDocuments;
  double screenlong;
  double screenHeight;
  int costoTotal = 0;
  int count = 0;
  @override
  Widget build(BuildContext context) {
    screenlong = MediaQuery.of(context).size.longestSide;
    screenHeight = MediaQuery.of(context).size.height;
    Provider.of<LoginState>(context).actualizarHistorialProductos(widget.idDocument);
    return Scaffold(
      appBar: AppBar(
        title: Text("Productos Comprados"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list),
              tooltip: 'Configuración',
              onPressed: (){
                configMenu(context);
              }
          ),
        ],
      ),
      body: Scrollbar(
        child: Container(
          margin: EdgeInsets.only(top: screenHeight / 100),
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: <Widget> [
              Container(
                height: screenHeight / 1.3,
                child: Theme(
                  data: ThemeData(
                    highlightColor: Colors.blue, //Does not work
                  ),
                  child: _queyList(context),
                ),
              ),
              Text("Costo de Envío: ${widget.costoEnvio}\nCosto Total: ${widget.totalPagado}",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _queyList(BuildContext context) {
    Provider.of<LoginState>(context).actualizarHistorialProductos(widget.idDocument);
    listDocuments = Provider.of<LoginState>(context).getHistorialProductos();
    if (listDocuments != null) {
      return ListView(
          children: List.generate(listDocuments.length, (i) => new ListTileItem(index: i, idDocument: widget.idDocument))
      );
    } else{
      return Text("Ocurrió un error al mostrar los productos");
    }
  }

  void goToProducto(BuildContext context, String idProducto){
    Navigator.push(
        context,
        MaterialPageRoute( builder: (context) => Producto(idProducto)));
  }
}