import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diefpc/Clases/Cliente.dart';
import 'package:diefpc/screens/anadirDireccion.dart';
import 'package:diefpc/states/auth.dart';
import 'package:flutter/material.dart';
import 'package:diefpc/app/app.dart';
import 'package:provider/provider.dart';
import 'carrito.dart';
import 'createProducto.dart';

// ignore: must_be_immutable
class Direcciones extends StatefulWidget {
  @override
  _DireccionesState createState() => new _DireccionesState();
}

class _DireccionesState extends State<Direcciones> {
  double screenlong;

  double screenHeight;

  Cliente _user;

  @override
  Widget build(BuildContext context) {
    screenlong = MediaQuery.of(context).size.longestSide;
    screenHeight = MediaQuery.of(context).size.height;
    _user = Provider.of<AuthService>(context).currentUser();
    return Scaffold(
      appBar: AppBar(
        title: Text("Direcciones"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.list),
              tooltip: 'Configuración',
              onPressed: () {
                configMenu(context);
              }),
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(top: screenHeight / 100),
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Column(children: <Widget>[
          Expanded(
            flex: 7,
            child: Container(
              height: screenHeight / 1.4,
              child: Theme(
                data: ThemeData(
                  highlightColor: Colors.blue, //Does not work
                ),
                child: Scrollbar(child: _queyList(context)),
              ),
            ),
          ),
          FloatingActionButton.extended(
            heroTag: "boton2",
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CrearDireccion()));
            },
            label: Text("  Añadir\nDireccion", style: TextStyle(fontSize: 15)),
            backgroundColor: Colors.blue,
          ),
        ]),
      ),
    );
  }

  Widget _queyList(BuildContext context) {
    if (_user.getListDireccion() != null) {
      if (_user.getListDireccion().getListDireccion().isNotEmpty) {
        return ListView.builder(
            itemCount: _user.getListDireccion().getListDireccion().length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) =>
                buildBody(context, index));
      } else {
        return Text(
          "La tienda no posee Productos",
          style: TextStyle(
            color: Colors.red,
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        );
      }
    }
  }

  Widget buildBody(BuildContext context, int index) {
    if (estaCargados() == false) {
      return Container(
        margin: EdgeInsets.only(top: screenHeight / 1000),
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Card(child: CircularProgressIndicator()),
      );
    } else
      return Container(
        margin: EdgeInsets.only(top: screenHeight / 1000),
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Card(
          child: ListTile(
            leading: IconButton(
              icon: Icon(Icons.local_hospital),
              iconSize: 40,
              tooltip: 'Direccion',
              onPressed: () {},
            ),
            onLongPress: () {
              if (_user.getIdDireccion().compareTo(_user
                      .getListDireccion()
                      .getListDireccion()[index]
                      .getId()
                      .toString()) !=
                  0) {
                _showAlertEliminarDireccion(_user
                    .getListDireccion()
                    .getListDireccion()[index]
                    .getId()
                    .toString());
              } else {
                _showAlert("No puedes eliminar tu dirección actual.");
              }
            },
            title: Text(_user
                .getListDireccion()
                .getListDireccion()[index]
                .getDireccion()),
            subtitle: Text(""),
            trailing: _iconTravel(
                _user.getListDireccion().getListDireccion()[index].getId(),
                context),
            isThreeLine: true,
          ),
        ),
      );
  }

  bool estaCargados() {
    if (_user.getListDireccion() == null) {
      return false;
    } else {
      return true;
    }
  }

  Column _iconTravel(String id, BuildContext context) {
    if (_user.getIdDireccion().compareTo(id) == 0) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Seleccionar"),
          Expanded(
            child: IconButton(
                icon: Icon(Icons.check_box),
                color: Colors.green,
                iconSize: 25,
                tooltip: 'Deleter',
                onPressed: () {}),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Seleccionar"),
          Expanded(
            child: IconButton(
                icon: Icon(Icons.check_box_outline_blank),
                iconSize: 25,
                tooltip: 'Checker',
                onPressed: () {
                  setState(() {
                    _user.setIdDireccion(id);
                  });
                }),
          ),
        ],
      );
    }
  }

  void goToCreateProducto(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CrearProducto()));
  }

  void goToCarrito(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CarritoCompras()));
  }

  void _showAlertEliminarDireccion(String id) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("¿Desea eliminar esta dirección?"),
          content: new Text(
              "Una vez que elimine la dirección, deberá añadirla nuevamente."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Atras"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Firestore.instance
                    .collection("usuarios")
                    .document(_user.getEmail())
                    .collection("Direccion")
                    .document(id)
                    .delete();

                setState(() {
                  _user.deleteDireccion(id);
                  Provider.of<AuthService>(context).actualizarUser(_user);
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
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
}
