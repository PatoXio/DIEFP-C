//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diefpc/states/login_state.dart';
import 'package:english_words/english_words.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:diefpc/app/app.dart';
import 'package:provider/provider.dart';

import 'ModificarProducto.dart';
import 'createProducto.dart';
import 'home.dart';

class ProductosTienda extends StatefulWidget{
  @override
  _ProductosTiendaState createState() => _ProductosTiendaState();
}

class _ProductosTiendaState extends State<ProductosTienda> {
  var _eliminar = Set<String>();
  String _modificar;
  bool state = false;
  FirebaseUser _user;
  double screenlong;
  double screenHeight;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenlong = MediaQuery.of(context).size.longestSide;
    Provider.of<LoginState>(context).actualizarProductos();
    _user = Provider.of<LoginState>(context).currentUser();
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
      Container(
        margin: EdgeInsets.only(top: screenHeight / 100),
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Column(
            children: <Widget> [
              FloatingActionButton.extended(
                heroTag: "hero1",
                splashColor: Colors.blueAccent,
                onPressed: () {
                  goToCreateProducto(context);
                },
                label: Text(
                  "Agregar Producto",
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              Row(
                children: <Widget> [
                  Divider(
                    indent: screenlong / 65,
                  ),
                  Card(
                      child:
                      Text(" Productos ",
                        style: _styleText(),
                      )),
                  Divider(
                    indent: screenlong / 4.6,
                  ),
                  Card(
                      child:
                      Text(" Seleccionar ",
                          style: _styleText())),
                ],
              ),
              Container(
                height: screenHeight / 1.4,
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
                        child: _queyList(context)),
                  ),
                ),
              ),
              Row(
                children: [
                  Divider(
                    indent: screenlong / 50,
                  ),
                  FloatingActionButton.extended(
                    heroTag: "hero2",
                    backgroundColor: Colors.red,
                    onPressed: () {
                      if(_eliminar.isNotEmpty)
                        eliminarProductos(_user.uid, _eliminar);
                      else
                        _showAlert("Debes seleccionar productos para eliminar");

                    },
                    label: Text(
                      "Eliminar",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                  Divider(
                    indent: screenlong /9,
                  ),
                  FloatingActionButton.extended(
                    heroTag: "hero3",
                    onPressed: () {
                      if(_modificar.isNotEmpty){
                        goToModificar(context, _modificar);
                       // Provider.of<LoginState>(context).actualizarProductos();
                      }else
                        _showAlert("Debes seleccionar productos para modificar");
                    },
                    label: Text(
                      "Modificar",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                ],
              )
            ]
    ),
      ),
    );
  }
  TextStyle _styleText(){
    return TextStyle(fontSize: 15,fontWeight: FontWeight.bold, color: Colors.black);
  }
  Widget _queyList(BuildContext context) {
    var listDocuments = Provider.of<LoginState>(context).getProductos();
    if (listDocuments != null) {
      return ListView.builder(
          itemCount: listDocuments.length,
          itemBuilder: (BuildContext context, int index) => buildBody(context, index)
      );
    } else{
      return Text("La tienda no posee Productos asociados :c",
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
          trailing: _iconTravel(listDocuments[index].documentID),
          isThreeLine: true,
        ),
      ),
    );
  }
  // ignore: non_constant_identifier_names
  Widget TextProducto(BuildContext context, List listaKeys, List listaValues){
    int i = 0;
    String info = '';
    if (listaKeys!=null){
      while(i<listaKeys.length){
        if (listaKeys[i].toString().compareTo("Tienda")!=0 && listaKeys[i].toString().compareTo("Codigo")!=0) {
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

  IconButton _iconTravel(String id) {
    bool enEliminar = _eliminar.contains(id);
    bool enModificar = _modificar == id ? true:false;
    if(enEliminar)
      if(state == false) {
        return IconButton(
            icon: Icon( Icons.indeterminate_check_box ),
            color: Colors.red,
            iconSize: 30,
            tooltip: 'Modificar',
            onPressed: () {
              _eliminar.remove( id );
              _modificar = id;
              state = true;
            } );
      }else{
        return IconButton(
            icon: Icon( Icons.indeterminate_check_box ),
            color: Colors.red,
            iconSize: 30,
            tooltip: 'Normal',
            onPressed: () {
              _eliminar.remove(id);
            } );
      }
    else
      if(enModificar)
      return IconButton(
          icon: Icon(Icons.check_box),
          color: Colors.blue,
          iconSize: 30,
          tooltip: 'Normal', onPressed: (){
        _modificar=null;
        state = false;
      });
      else
        return IconButton(
            icon: Icon(Icons.check_box_outline_blank),
            iconSize: 30,
            tooltip: 'Eliminar', onPressed: (){
          _eliminar.add(id);
        });
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

  void eliminarProductos(String uid, Set<String> eliminar) {
    int largo = eliminar.length;
    int i;
    try{
      for(i=0;i<largo;i++){
        Firestore.instance
            .collection('usuarios')
            .document(uid)
            .collection('Productos')
            .document(eliminar.elementAt(i))
            .delete();
      }
      eliminar.clear();
    }catch(error){
      return _showAlert("Ocurrió un error al borrar los productos");
    }
    return _showAlert("Se borraron los productos");
  }
  void _showAlert(String notify) {
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
  void goToModificar(BuildContext context, String modificar) {
    Navigator.push(
        context,
        MaterialPageRoute( builder: (context) => new ModificarProducto(modificar: modificar)));
  }
}