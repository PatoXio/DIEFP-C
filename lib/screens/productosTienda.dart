//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diefpc/states/login_state.dart';
import 'package:flutter/material.dart';
import 'package:diefpc/app/app.dart';
import 'package:provider/provider.dart';

import 'createProducto.dart';
import 'home.dart';

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
class ProductosTienda extends StatefulWidget{
  @override
  _ProductosTiendaState createState() => _ProductosTiendaState();
}

class _ProductosTiendaState extends State<ProductosTienda> {
  @override
  Widget build(BuildContext context) {
    Provider.of<LoginState>(context).actualizarProductos();
    return Scaffold(
      appBar: AppBar(
        title: Text("Productos Disponibles"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list),
              tooltip: 'Configuración',
              onPressed: (){
                configMenu(context);
              }
          ),
        ],
      ),
      body:
      Column(
          children: <Widget> [
            FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              padding: EdgeInsets.all(8.0),
              splashColor: Colors.blueAccent,
              onPressed: () {
                goToCreateProducto(context);
              },
              child: Text(
                "Agregar Producto",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Expanded(
                child: _queyList(context)
            )
          ]),
    );
  }
  Widget _queyList(BuildContext context) {
    var listDocuments = Provider.of<LoginState>(context).getProductos();
    if (listDocuments != null) {
      return ListView.builder(
          itemCount: listDocuments.length,
          itemBuilder: (BuildContext context, int index) => buildBody(context, index)
      );
    } else{
      return Text("La tienda no posee Productos :c",
            style: TextStyle(
              color: Colors.red,
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          );
    }
  }
  Widget buildBody(BuildContext ctxt, int index) {
    var listDocuments = Provider.of<LoginState>(context).getProductos();
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.only(top: screenHeight / 1000),
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Card(
        child: ListTile(
          leading: IconButton(
            icon: Icon(Icons.local_hospital),
            iconSize: 40,
            tooltip: 'Productos', onPressed: () {  },
          ),
          title: Text(listDocuments[index].data["Nombre"]),
          subtitle: TextProducto(context, listDocuments[index].data.keys.toList(), listDocuments[index].data.values.toList()),
          //trailing: Icon(Icons.more_vert),
          isThreeLine: true,
        ),
      ),
    );
  }
  // ignore: non_constant_identifier_names
  Widget TextProducto(BuildContext context, List listaKeys, List listaValues){
    int i = 0;
    String info;
    if (listaKeys!=null){
      while(i<listaKeys.length){
        if(i==1){
          info = "${listaKeys[i].toString()}: ${listaValues[i].toString()}";
        }
        if(i>1){
          info = info + "\n${listaKeys[i].toString()}: ${listaValues[i].toString()}";
        }
        i=i+1;
      }
    }else
      info = "Este producto no posee datos";
    return Text("$info");
  }
  void goToCreateProducto(BuildContext context){
    Navigator.push(
        context,
        MaterialPageRoute( builder: (context) => CrearProducto()));
  }
  void goToHomeScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute( builder: (context) => HomeScreen( ) ) );
  }
}