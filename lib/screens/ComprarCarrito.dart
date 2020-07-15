//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_counter/flutter_counter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diefpc/states/login_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:diefpc/app/app.dart';
import 'package:provider/provider.dart';

import 'carrito.dart';
import 'createProducto.dart';
import 'home.dart';

class ComprarCarrito extends StatefulWidget {
  @override
  _ComprarCarritoState createState() => _ComprarCarritoState();
}

class ListTileItem extends StatefulWidget{
  int index;
  ListTileItem({this.index});
  @override
  _ListTileItemState createState() => new _ListTileItemState();
}

class _ListTileItemState extends State<ListTileItem> {
  int count = 1;
  @override
  Widget build(BuildContext context) {
    var _user = Provider.of<LoginState>(context).currentUser();
    var listDocuments = Provider.of<LoginState>(context).getCarrito();
    Provider.of<LoginState>(context).actualizarCarrito();
    return ListTile(
        leading: IconButton(
          icon: Icon(Icons.local_hospital),
          iconSize: 40,
          tooltip: 'Productos', onPressed: () {  },
        ),
        title: Text(listDocuments[widget.index].data["Nombre"]),
        subtitle: TextProducto(context, listDocuments[widget.index].data.keys.toList(), listDocuments[widget.index].data.values.toList()),
        trailing: new Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            count!=0?
            IconButton(icon: Icon(Icons.remove),onPressed: ()=> {
              setState(()=>count--),
              actualizarCarritoCant(listDocuments[widget.index].documentID,_user.uid, count)
            },):new Container(),
            Text(count.toString()),
            IconButton(icon: Icon(Icons.add),onPressed: ()=>{

              if(int.parse(listDocuments[widget.index].data["Stock"]) > count)
                setState(()=>count++),
                actualizarCarritoCant(listDocuments[widget.index].documentID,_user.uid, count)
            })
          ],
        ),
        isThreeLine: true,
    );
  }
  Widget TextProducto(BuildContext context, List listaKeys, List listaValues){
    int i = 0;
    String info;
    if (listaKeys!=null) {
      while (i < listaKeys.length) {
        if (listaKeys[i].toString( ).compareTo( "Tienda" ) != 0) {
          if (i == 1) {
            info = "${listaKeys[i].toString( )}: ${listaValues[i].toString( )}";
          }
          if (i > 1) {
            info = info +"\n${listaKeys[i].toString( )}: ${listaValues[i].toString( )}";
          }
        }
        i = i + 1;
    }
    }else
      info = "Este producto no posee datos";
    return Text("$info");
  }
  void actualizarCarritoCant(String idProducto, String uid, int count){
    Firestore.instance
        .collection('usuarios')
        .document(uid)
        .collection("Carrito")
        .document(idProducto).updateData({"Cantidad": count.toString()});
  }
}

class _ComprarCarritoState extends State<ComprarCarrito> {
  double screenlong;
  double screenHeight;
  String medioDePago = 'WebPay';
  List<DocumentSnapshot> carrito;
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<LoginState>(context).currentUser();
    screenlong = MediaQuery.of(context).size.longestSide;
    screenHeight = MediaQuery.of(context).size.height;
    Provider.of<LoginState>(context).actualizarCarrito();
    carrito = Provider.of<LoginState>(context).getCarrito();
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
                  Text("Productos:",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue
                    ),
                  ),
                ],
              ),
              Container(
                height: screenHeight / 2.5,
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
              Container(
                height: screenHeight / 3,
                child: Card(
                  //elevation: 5,
                  margin: EdgeInsets.all(10),
                  semanticContainer: true,
                  //color: Colors.transparent,
                  child: Column(
                    children: [
                        Row(
                          children: [
                            Text("\n Costo de Envío:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.blue ) ),
                            Divider(
                              indent: screenlong / 20,
                            ),
                            Text("\n ${_costoEnvio()} Pesos",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.blue ) ),
                          ],
                        ),
                      Row(
                        children: [
                          Text("\n Costo Total:", style: TextStyle( fontSize: 20, color: Colors.blue ) ),
                          Divider(
                            indent: screenlong / 10,
                          ),
                          Text("\n${_totalCosto(carrito, _costoEnvio(), _user.uid )} Pesos", style: TextStyle(fontSize: 20, color: Colors.blue)),
                        ],
                      ),
                      Divider(
                        height: screenHeight / 30,
                      ),
                      Row(
                        children: [
                          Text(" Pagar con:", style: TextStyle( fontSize: 20, color: Colors.blue ) ),
                          Divider(
                            indent: screenlong / 9,
                          ),
                        DropdownButton<String>(
                          value: medioDePago,
                          icon: Icon(Icons.arrow_downward, color: Colors.blue,),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.green),
                          underline: Container(
                            height: 2,
                            color: Colors.green,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              medioDePago = newValue;
                            });
                            },
                          items: <String>['WebPay', 'Efectivo', 'Match']
                              .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text("$value", style: TextStyle(fontSize: 20, color: Colors.blue)),
                                );
                              }).toList(),
                        ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                  children: <Widget> [
                    Divider(
                      indent: screenlong / 90,
                    ),
                    FloatingActionButton.extended(
                      heroTag: "boton1c",
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      label: Text("Atras",
                          style: TextStyle(fontSize: 15)),
                      backgroundColor: Colors.blue,
                    ),
                    Divider(
                      indent: screenlong / 4,
                    ),
                    FloatingActionButton.extended(
                      heroTag: "boton2c",
                      onPressed: () {
                      },
                      label: Text("Pagar", style: TextStyle(fontSize: 15)),
                      backgroundColor: Colors.blue,
                    ),
                  ]
              ),
            ])),
      );
  }

  Widget _queyList(BuildContext context) {
    var listDocuments = Provider.of<LoginState>(context).getCarrito();
    int carritoLength = listDocuments.length;
    if (listDocuments != null) {
      return ListView(
        children: List.generate(carritoLength, (i) => new ListTileItem(index: i))
      );
    }else{
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

  int _totalCosto(List<DocumentSnapshot> carrito, int costoEnvio, String uid){
    int length;
    int i;
    int suma = 0;
    if (carrito.length>0) {
      length = carrito.length;
      for(i=0;i<length;i++){
          suma = suma + (int.parse(carrito.elementAt(i).data["Precio"])*int.parse(carrito.elementAt(i).data["Cantidad"]));
      }
    }else
      return 0;
    return suma+costoEnvio;
  }

  int _costoEnvio(){
    return 1000;
  }

  void goToCreateProducto(BuildContext context){
    Navigator.push(
        context,
        MaterialPageRoute( builder: (context) => CrearProducto()));
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
  /*void _showAlertExist(BuildContext context) {
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
  }*/
  bool idIntoCarrito(String id, BuildContext context) {
    List<DocumentSnapshot> carrito = Provider.of<LoginState>(context).getCarrito();
    return carrito.contains(id);
    }
}