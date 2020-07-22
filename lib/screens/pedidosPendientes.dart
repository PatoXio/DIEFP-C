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

class PedidosPendientes extends StatelessWidget {
  double screenlong;
  double screenHeight;
  int pendientesLength;
  FirebaseUser _user;
  List<DocumentSnapshot> pendientes;
  var _saved = Set<String>();
  @override
  Widget build(BuildContext context) {
    Provider.of<LoginState>(context).actualizarPendientes();
    _user = Provider.of<LoginState>(context).currentUser();
    screenlong = MediaQuery.of(context).size.longestSide;
    screenHeight = MediaQuery.of(context).size.height;
    pendientes = Provider.of<LoginState>(context).getPedidosPendientes();
    print(pendientes);
    if(pendientes != null)
      pendientesLength = pendientes.length;
    else
      pendientesLength = 0;
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedidos Pendientes"),
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
                      Text(" Pedidos ",
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
                        _queyList(context, _user.uid)
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
                        if(_saved.length!=0)
                          aceptarPedido(context, _saved, _user);
                        else return _showAlert(context, "Debes elegir al menos 1 pedido");
                      },
                      label: Text("Aceptar Pedidos", style: TextStyle(fontSize: 15)),
                      backgroundColor: Colors.blue,
                    ),
                    Divider(
                      indent: screenlong / 60,
                    ),
                    FloatingActionButton.extended(
                      heroTag: "boton2",
                      onPressed: () {
                        if(_saved.length !=0)
                        cancelarPedido(context, _saved, _user);
                        else return _showAlert(context, "Debes elegir al menos 1 pedido");
                      },
                      label: Text("Cancelar Pedido", style: TextStyle(fontSize: 15)),
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
    var listDocuments = Provider.of<LoginState>(context).getPedidosPendientes();
    if (listDocuments != null) {
      return ListView.builder(
          itemCount: listDocuments.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) => buildBody(context, index)
      );
    } else{
      return Text("La tienda no posee Pedidos Pendientes",
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
    var listDocuments = Provider.of<LoginState>(context).getPedidosPendientes();
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.only(top: screenHeight / 1000),
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Card(
        child: ListTile(
          leading: IconButton(
            icon: Icon(Icons.local_hospital),
            iconSize: 40,
            tooltip: 'Pedidos', onPressed: () {  },
          ),
          title: Text(listDocuments[index].data["Fecha"]),
          subtitle: TextProducto(context, listDocuments[index].data.keys.toList(), listDocuments[index].data.values.toList()),
          trailing: _iconTravel(listDocuments[index].documentID, context, listDocuments[index].data["Nombre"]),
          isThreeLine: true,
        ),
      ),
    );
  }

  IconButton _iconTravel(String id, BuildContext context, String nombre) {
    final alreadySaved = _saved.contains(id);
      if(alreadySaved){
        return IconButton(
            icon: Icon(Icons.indeterminate_check_box),
            color: Colors.red,
            iconSize: 25,
            tooltip: 'Deleter', onPressed: (){
          _saved.remove(id);
        });
      }else{
        return IconButton(
            icon: Icon(Icons.check_box_outline_blank),
            iconSize: 25,
            tooltip: 'Checker', onPressed: (){
          _saved.add(id);
        });
      }
    }// ignore: non_constant_identifier_names
  Widget TextProducto(BuildContext context, List listaKeys, List listaValues){
    int i = 0;
    String info = '';
    if (listaKeys!=null){
      while(i<listaKeys.length){
        if (listaKeys[i].toString( ).compareTo( "Entregado" ) != 0 && listaKeys[i].toString( ).compareTo( "Pendiente" ) != 0) {
          if (i == 1)
            info = "${listaKeys[i].toString( )}: ${listaValues[i].toString( )}\n";
          if (i >= 2) {
              info = info +"${listaKeys[i].toString( )}: ${listaValues[i].toString( )}\n";
          }
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

  void aceptarPedido(BuildContext context, Set<String> _saved, FirebaseUser _user){
    int largo = _saved.length;
    int i;
    try {
      for (i = 0; i < largo; i++) {
        Firestore.instance
            .collection( 'usuarios' )
            .document(_user.uid )
            .collection( 'Pendientes' )
            .document( _saved.elementAt( i ) )
            .get( )
        // ignore: missing_return
            .then( (DocumentSnapshot ds) {
              Firestore.instance
                  .collection( 'usuarios' )
                  .document( _user.uid )
                  .collection( 'ComprasRealizadas' )
                  .add( ds.data );
            });
      }
      _saved.clear( );
    } catch (error) {
      return _showAlert( context, 'Ocurrió un error al aceptar los pedidos' );
    }
    return _showAlert( context, "Se aceptaron los pedidos" );
  }

  void cancelarPedido(BuildContext context, Set<String> _saved, FirebaseUser _user) {
    int i;
    int largo = _saved.length;
    for (i = 0; i < largo; i++) {
      Firestore.instance
          .collection( 'usuarios' )
          .document( _user.uid ).collection( 'Pendientes' )
          .document( _saved.elementAt( i ) )
          .delete( );
    }
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
}