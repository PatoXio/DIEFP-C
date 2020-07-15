//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diefpc/states/login_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:diefpc/app/app.dart';
import 'package:provider/provider.dart';

import 'carrito.dart';
import 'createProducto.dart';
import 'home.dart';

class AnadirProcutoCarrito extends StatelessWidget {
  String idTienda;
  double screenlong;
  double screenHeight;
  int carritoLength;
  final _saved = Set<String>();

  AnadirProcutoCarrito(String idTienda){
    this.idTienda = idTienda;
  }

  @override
  Widget build(BuildContext context) {
    FirebaseUser _user = Provider.of<LoginState>(context).currentUser();
    screenlong = MediaQuery.of(context).size.longestSide;
    screenHeight = MediaQuery.of(context).size.height;
    Provider.of<LoginState>(context).verProductosTienda(idTienda);
    Provider.of<LoginState>(context).actualizarCarrito();
    var carrito = Provider.of<LoginState>(context).getCarrito();
    if(carrito != null)
      carritoLength = carrito.length;
    else
      carritoLength = 0;
    return Scaffold(
      appBar: AppBar(
        title: Text("Productos De La Tienda"),
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
      Container(
        margin: EdgeInsets.only(top: screenHeight / 100),
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Column(
            children: <Widget> [
              Row(
                children: <Widget> [
                  Divider(
                    indent: screenlong / 65,
                  ),
                  Card(
                      color: Colors.blue,
                      child:
                      Text(" Productos ",
                        style: _styleText(),
                      )),
                  Divider(
                    indent: screenlong / 4.6,
                  ),
                  Card(
                      color: Colors.blue,
                      child:
                      Text(" Seleccionar ",
                          style: _styleText())),
                ],
              ),
              Container(
                height: screenHeight / 1.3,
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
                        _queyList(context, idTienda)
                    ),
                  ),
                ),
              ),
              Row(
                  children: <Widget> [
                    Divider(
                      indent: screenlong / 90,
                    ),
                    FloatingActionButton.extended(
                      heroTag: "boton1",
                      onPressed: () {
                        AnadirAlCarrito(context, _saved, _user, idTienda);
                      },
                      label: Text("Añadir al\nCarrito (${_saved.length})", style: TextStyle(fontSize: 15)),
                      backgroundColor: Colors.blue,
                    ),
                    Divider(
                      indent: screenlong / 7,
                    ),
                    FloatingActionButton.extended(
                      heroTag: "boton2",
                      onPressed: () {
                        goToCarrito(context);
                      },
                      label: Text("Ver Carrito\n\t\t\t\t(${carritoLength})", style: TextStyle(fontSize: 15)),
                      backgroundColor: Colors.blue,
                    ),
                  ]
              ),
            ]),
      ),
    );
  }

  TextStyle _styleText(){
    return TextStyle(fontSize: 15,fontWeight: FontWeight.bold, color: Colors.white);
  }

  Widget _queyList(BuildContext context, String idTienda) {
    var listDocuments = Provider.of<LoginState>(context).getProductosTienda();
    if (listDocuments != null) {
      return ListView.builder(
          itemCount: listDocuments.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) => buildBody(context, index)
      );
    } else{
      return Text("La tienda no posee Productos",
            style: TextStyle(
              color: Colors.red,
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          );
    }
  }
  Widget buildBody(BuildContext context, int index) {
    var listDocuments = Provider.of<LoginState>(context).getProductosTienda();
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
          trailing: _iconTravel(listDocuments[index].documentID, context),
          isThreeLine: true,
        ),
      ),
    );
  }

  IconButton _iconTravel(String id, BuildContext context) {
    final alreadySaved = _saved.contains(id);
    if(idIntoCarrito(id, context) == true)
      return IconButton(
          icon: Icon(Icons.clear),
          color: Colors.red,
          iconSize: 25,
          tooltip: 'Ya añadido', onPressed: (){
            _showAlertExist(context);
      });
    if(alreadySaved)
      return IconButton(
          icon: Icon(Icons.indeterminate_check_box),
          color: Colors.red,
          iconSize: 25,
          tooltip: 'Deleter', onPressed: (){
        _saved.remove(id);
      });
    else
      return IconButton(
          icon: Icon(Icons.check_box_outline_blank),
          iconSize: 25,
          tooltip: 'Checker', onPressed: (){
        _saved.add(id);
      });
  }
  // ignore: non_constant_identifier_names
  Widget TextProducto(BuildContext context, List listaKeys, List listaValues){
    int i = 0;
    String info;
    if (listaKeys!=null){
      while(i<listaKeys.length){
        if (listaKeys[i].toString( ).compareTo( "Tienda" ) != 0) {
          if (i == 1)
            info = "${listaKeys[i].toString( )}: ${listaValues[i].toString( )}";
          if (i > 1)
            info = info +"\n${listaKeys[i].toString( )}: ${listaValues[i].toString( )}";
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

  void AnadirAlCarrito(BuildContext context, Set<String> _saved, FirebaseUser _user, String idTienda){
    int largo = _saved.length;
    int i;
    Future<DocumentSnapshot>  producto;
    try {
      for (i = 0; i < largo; i++) {
        Firestore.instance
            .collection( 'usuarios' )
            .document(idTienda)
            .collection( 'Productos' )
            .document(_saved.elementAt(i))
            .get()
            // ignore: missing_return
            .then((DocumentSnapshot ds){
              Firestore.instance
                  .collection( 'usuarios' )
                  .document( _user.uid )
                  .collection('Carrito').add(ds.data);
            });
      }
      _saved.clear();
    }catch (error) {
      return _showAlert(context,'Ocurrió un error al agregar los productos' );
    }
    return _showAlert(context, "Se agregaron los productos" );
  }
  void goToCarrito(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CarritoCompras()));
  }
  void _showAlert(BuildContext context, String notify) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Aviso"),
          content: new Text(notify),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
  void _showAlertExist(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Aviso"),
          content: new Text("Este Producto ya está añadido"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
  bool idIntoCarrito(String id, BuildContext context) {
    List<DocumentSnapshot> carrito = Provider.of<LoginState>(context).getCarrito();
    return carrito.contains(id);
    }
}