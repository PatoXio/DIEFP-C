import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diefpc/Clases/Producto.dart';
import 'package:diefpc/Clases/Tienda.dart';
import 'package:diefpc/states/auth.dart';
import 'package:flutter/material.dart';
import 'package:diefpc/app/app.dart';
import 'package:provider/provider.dart';
import 'ModificarProducto.dart';
import 'createProducto.dart';
import 'home.dart';

class ProductosTienda extends StatefulWidget {
  @override
  _ProductosTiendaState createState() => _ProductosTiendaState();
}

class _ProductosTiendaState extends State<ProductosTienda> {
  var _prodSelect = Set<String>();
  Tienda _user;
  List<Producto> _listProducto;
  double screenlong;
  double screenHeight;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenlong = MediaQuery.of(context).size.longestSide;
    _user = Provider.of<AuthService>(context).currentUser();
    _listProducto = _user.getListProducto();
    return Scaffold(
      appBar: AppBar(
        title: Text("Productos Disponibles"),
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
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Column(children: <Widget>[
          Row(
            children: <Widget>[
              Divider(
                indent: screenlong / 65,
              ),
              Text(
                "  Productos ",
                style: _styleText(),
              ),
              Divider(
                indent: screenlong / 4,
              ),
              Text(" Seleccionar ", style: _styleText()),
            ],
          ),
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
          Expanded(
            child: Row(
              children: [
                FloatingActionButton.extended(
                  heroTag: "boton2",
                  backgroundColor: Colors.red,
                  onPressed: () {
                    if (_prodSelect.isNotEmpty)
                      eliminarProductos();
                    else
                      _showAlert("Debes seleccionar productos para eliminar");
                  },
                  label: Text(
                    "Eliminar",
                  ),
                ),
                Divider(
                  indent: screenlong / 60,
                ),
                FloatingActionButton.extended(
                  heroTag: "boton1",
                  splashColor: Colors.blueAccent,
                  onPressed: () {
                    goToCreateProducto(context);
                    setState(() {
                      _user = Provider.of<AuthService>(context).currentUser();
                      _listProducto = _user.getListProducto();
                      _prodSelect.clear();
                    });
                  },
                  label: Text(
                    "Agregar\nProducto",
                  ),
                ),
                Divider(
                  indent: screenlong / 60,
                ),
                if (_prodSelect.length == 1)
                  FloatingActionButton.extended(
                    heroTag: "hero3",
                    onPressed: () {
                      if (_prodSelect.isNotEmpty) {
                        if (_prodSelect.length == 1) {
                          goToModificar(context, _prodSelect.first);
                          setState(() {
                            _user =
                                Provider.of<AuthService>(context).currentUser();
                            _listProducto = _user.getListProducto();
                            _prodSelect.clear();
                          });
                        } else {
                          _showAlert(
                              "Solo puedes modificar 1 producto a la vez");
                        }
                      } else
                        _showAlert("Debes seleccionar un producto a modificar");
                    },
                    label: Text(
                      "Modificar",
                    ),
                  )
                else
                  FloatingActionButton.extended(
                    heroTag: "hero4",
                    backgroundColor: Colors.grey,
                    onPressed: () {},
                    label: Text(
                      "Modificar",
                    ),
                  ),
              ],
            ),
          )
        ]),
      ),
    );
  }

  TextStyle _styleText() {
    return TextStyle(
        fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black);
  }

  Widget _queyList(BuildContext context) {
    if (_listProducto != null) {
      if (_listProducto.length > 0) {
        return ListView.builder(
            itemCount: _listProducto.length,
            itemBuilder: (BuildContext context, int index) =>
                buildBody(context, index));
      } else {
        return Text(
          "La tienda no posee Productos asociados :c",
          style: TextStyle(
            color: Colors.red,
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        );
      }
    } else {
      return Text(
        "La tienda no posee Productos asociados :c",
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
    //double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.only(top: screenHeight / 1000),
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Card(
        child: ListTile(
          leading: IconButton(
            icon: Icon(Icons.local_hospital),
            iconSize: 40,
            tooltip: 'Productos',
            onPressed: () {},
          ),
          title: Text(_listProducto.elementAt(index).getNombre()),
          subtitle: Text(_listProducto.elementAt(index).getDatos()),
          trailing: _iconTravel(_listProducto.elementAt(index).getCodigo()),
          isThreeLine: true,
        ),
      ),
    );
  }

  IconButton _iconTravel(String id) {
    bool isSelect = _prodSelect.contains(id);
    if (isSelect) {
      return IconButton(
          icon: Icon(Icons.check_box),
          color: Colors.blue,
          iconSize: 30,
          tooltip: 'Seleccionado',
          onPressed: () {
            setState(() {
              _prodSelect.remove(id);
            });
          });
    } else {
      return IconButton(
          icon: Icon(Icons.check_box_outline_blank),
          color: Colors.grey,
          iconSize: 30,
          tooltip: 'Sin seleccionar',
          onPressed: () {
            setState(() {
              _prodSelect.add(id);
            });
          });
    }
  }

  void goToCreateProducto(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CrearProducto()));
  }

  void goToHomeScreen(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  void eliminarProductos() {
    int largo = _prodSelect.length;
    int i;
    int cont = 0;
    try {
      for (i = 0; i < largo; i++) {
        if (_user.eliminarProducto(_prodSelect.elementAt(i))) {
          cont++;
          Firestore.instance
              .collection('usuarios')
              .document(_user.getEmail())
              .collection('Productos')
              .document(_prodSelect.elementAt(i))
              .delete();
        }
      }
      setState(() {
        _prodSelect.clear();
        _user = Provider.of<AuthService>(context).currentUser();
      });
    } catch (error) {
      setState(() {
        _prodSelect.clear();
        _user = Provider.of<AuthService>(context).currentUser();
      });
      return _showAlert("Ocurrió un error al borrar los productos");
    }
    return _showAlert("Se borraron $cont productos");
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

  void goToModificar(BuildContext context, String codigo) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => new ModificarProducto(codigo)));
  }
}
