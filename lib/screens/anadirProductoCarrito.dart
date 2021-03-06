//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diefpc/Clases/Cliente.dart';
import 'package:diefpc/Clases/Producto.dart';
import 'package:diefpc/documents/documents_service.dart';
import 'package:diefpc/states/auth.dart';
import 'package:flutter/material.dart';
import 'package:diefpc/app/app.dart';
import 'package:provider/provider.dart';
import 'carrito.dart';
import 'createProducto.dart';

// ignore: must_be_immutable
class AnadirProductoCarrito extends StatefulWidget {
  String idTienda, nombre;

  AnadirProductoCarrito({String idTienda, nombre}) {
    this.idTienda = idTienda;
    this.nombre = nombre;
  }

  @override
  _AnadirProductoCarritoState createState() =>
      new _AnadirProductoCarritoState();
}

class _AnadirProductoCarritoState extends State<AnadirProductoCarrito> {
  double screenlong;

  double screenHeight;

  List<DocumentSnapshot> listDocuments;

  Cliente _user;
  String filtro;

  Set<String> _saved = Set<String>();

  @override
  Widget build(BuildContext context) {
    screenlong = MediaQuery.of(context).size.longestSide;
    screenHeight = MediaQuery.of(context).size.height;
    setState(() {
      _user = Provider.of<AuthService>(context).currentUser();
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("Productos de\n${widget.nombre}"),
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
          TextField(
            decoration: InputDecoration(
              labelText: "Ingrese el nombre para filtrar",
            ),
            onChanged: (String value) {
              setState(() {
                filtro = value;
              });
            },
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
          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Row(children: <Widget>[
                Divider(
                  indent: screenlong / 90,
                ),
                FloatingActionButton.extended(
                  heroTag: "boton1",
                  onPressed: () {
                    if (_saved.length != 0)
                      AnadirAlCarrito(context, _saved, _user);
                    else
                      return _showAlert(
                          context, "Debes elegir productos para agregarlos.");
                  },
                  label: Text("Añadir al\nCarrito (${_saved.length})",
                      style: TextStyle(fontSize: 15)),
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
                  label: Text(
                      "Ver Carrito\n\t\t\t\t(${_user.getCarritoDeCompra().getListProducto().length})",
                      style: TextStyle(fontSize: 15)),
                  backgroundColor: Colors.blue,
                ),
              ]),
            ),
          ),
        ]),
      ),
    );
  }

  TextStyle _styleText() {
    return TextStyle(
        fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white);
  }

  Widget _queyList(BuildContext context) {
    cargarListDocument();
    if (listDocuments != null) {
      List<DocumentSnapshot> listProductos = new List<DocumentSnapshot>();
      if (filtro != null) {
        for (int i = 0; i < listDocuments.length; i++) {
          DocumentSnapshot document = listDocuments[i];
          String nombre = document.data["Nombre"].toString().toLowerCase();
          if (nombre.contains(filtro.toLowerCase()) == true) {
            setState(() {
              listProductos.add(document);
            });
          }
        }
        if (listProductos != null) {
          return ListView.builder(
              itemCount: listProductos.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) =>
                  buildBody(context, index, listProductos));
        } else {
          return ListView.builder(
              itemCount: listDocuments.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) =>
                  buildBody(context, index, listDocuments));
        }
      } else {
        return ListView.builder(
            itemCount: listDocuments.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) =>
                buildBody(context, index, listDocuments));
      }
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

  void cargarListDocument() async {
    var documentos =
        await getListDocumentOneCollecionService(widget.idTienda, dbProductos);
    if (documentos != null) {
      for (int i = 0; i < documentos.length; i++) {
        setState(() {
          listDocuments = documentos;
        });
      }
    }
  }

  Widget buildBody(
      BuildContext context, int index, List<DocumentSnapshot> listProductos) {
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
              tooltip: 'Productos',
              onPressed: () {},
            ),
            title: Text(listProductos[index].data["Nombre"]),
            subtitle: TextProducto(
                context,
                listProductos[index].data.keys.toList(),
                listProductos[index].data.values.toList()),
            trailing: _iconTravel(
                listProductos[index].documentID,
                context,
                listProductos[index].data["Nombre"],
                int.parse(listProductos[index].data["Stock"])),
            isThreeLine: true,
          ),
        ),
      );
  }

  bool estaCargados() {
    if (listDocuments == null) {
      return false;
    } else {
      return true;
    }
  }

  Column _iconTravel(
      String id, BuildContext context, String nombre, int stock) {
    bool alreadySaved = _saved.contains(id);
    if (stock <= 0) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("Seleccionar"),
          Expanded(
            child: IconButton(
                icon: Icon(Icons.watch_later),
                color: Colors.green,
                iconSize: 25,
                tooltip: 'Sin Stock',
                onPressed: () {
                  _showAlert(context, "Este producto ya no tiene STOCK");
                }),
          ),
        ],
      );
    } else if (idIntoCarrito(context, nombre) == true) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("Seleccionar"),
          Expanded(
            child: IconButton(
                icon: Icon(Icons.indeterminate_check_box),
                color: Colors.green,
                iconSize: 25,
                tooltip: 'Ya añadido',
                onPressed: () {
                  _showAlertExist(context);
                }),
          ),
        ],
      );
    } else {
      if (alreadySaved) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Seleccionar"),
            Expanded(
              child: IconButton(
                  icon: Icon(Icons.indeterminate_check_box),
                  color: Colors.red,
                  iconSize: 25,
                  tooltip: 'Deleter',
                  onPressed: () {
                    setState(() {
                      _saved.remove(id);
                    });
                  }),
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
                      _saved.add(id);
                    });
                  }),
            ),
          ],
        );
      }
    }
  }

  Widget TextProducto(BuildContext context, List listaKeys, List listaValues) {
    int i = 0;
    String info = '';
    if (listaKeys != null) {
      while (i < listaKeys.length) {
        if (listaKeys[i].toString().compareTo("Tienda") != 0 &&
            listaKeys[i].toString().compareTo("Codigo") != 0 &&
            listaKeys[i].toString().compareTo("nombreTienda") != 0 &&
            listaKeys[i].toString().compareTo("Nombre") != 0 &&
            listaKeys[i].toString().compareTo("StockReservado") != 0 &&
            listaKeys[i].toString().compareTo("Categorias") != 0 &&
            listaKeys[i].toString().compareTo("Cantidad") != 0) {
          if (i == 0)
            info = "${listaKeys[i].toString()}: ${listaValues[i].toString()}\n";
          if (i > 0) {
            info = info +
                "${listaKeys[i].toString()}: ${listaValues[i].toString()}\n";
          }
        }
        i = i + 1;
      }
    } else
      info = "Este producto no posee datos";
    return Text("$info");
  }

  void goToCreateProducto(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CrearProducto()));
  }

  // ignore: non_constant_identifier_names
  void AnadirAlCarrito(
      BuildContext context, Set<String> _saved, Cliente user) async {
    int largo = _saved.length;
    int i;
    if (_user.getCarritoDeCompra().getListProducto().isNotEmpty) {
      if (_user
              .getCarritoDeCompra()
              .getListProducto()
              .last
              .getIdTienda()
              .compareTo(widget.idTienda) !=
          0) {
        _showAlertBorrarCarrito(context);
        return;
      }
    }
    try {
      for (i = 0; i < largo; i++) {
        Firestore.instance
            .collection('usuarios')
            .document(widget.idTienda)
            .collection('Productos')
            .document(_saved.elementAt(i))
            .get()
            // ignore: missing_return
            .then((DocumentSnapshot ds) async {
          Firestore.instance
              .collection('usuarios')
              .document(_user.getEmail())
              .collection('Carrito')
              .document(ds.data["Codigo"])
              .setData(ds.data);
          Firestore.instance
              .collection('usuarios')
              .document(_user.getEmail())
              .collection('Carrito')
              .document(ds.data["Codigo"])
              .setData({"Cantidad": "1"}, merge: true);
          Producto producto = new Producto.carga(
              ds.data["Codigo"],
              ds.data["Codigo"],
              ds.data["Tienda"],
              ds.data["nombreTienda"],
              ds.data["Nombre"],
              List<String>.from(ds.data["Categorias"]),
              1,
              int.parse(ds.data["Precio"]),
              int.parse(ds.data["Stock"]),
              int.parse(ds.data["StockReservado"]),
              double.parse(ds.data["Mg/u"]));
          user.setProductoACarrito(producto);
        });
      }
      setState(() {
        _user = user;
        _saved.clear();
      });
      return _showAlert(context, "Se agregaron los productos");
    } catch (error) {
      return _showAlert(context, 'Ocurrió un error al agregar los productos');
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
                /*Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AnadirProductoCarrito(
                            idTienda: widget.idTienda, nombre: widget.nombre)));
              */
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showAlertBorrarCarrito(BuildContext context) {
    int i;
    //int largo = _saved.length;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Aviso"),
          content: new Text(
              "Al seleccionar un producto de otra tienda borraras los productos de tu carrito actual\n¿Estás seguro?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("SI"),
              onPressed: () {
                Firestore.instance
                    .collection('usuarios')
                    .document(_user.getEmail())
                    .collection('Carrito')
                    .getDocuments()
                    .then((snapshot) {
                  for (DocumentSnapshot ds in snapshot.documents) {
                    ds.reference.delete();
                  }
                });
                _user.deleteCarrito();
                Navigator.pop(context);
              },
            ),
            new FlatButton(
              child: new Text("NO"),
              onPressed: () {
                _saved.clear();
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

  bool idIntoCarrito(BuildContext context, String nombre) {
    int i;
    if (_user.getCarritoDeCompra().getListProducto().length > 0) {
      for (i = 0;
          i < _user.getCarritoDeCompra().getListProducto().length;
          i++) {
        if (_user
                .getCarritoDeCompra()
                .getListProducto()[i]
                .getNombre()
                .compareTo(nombre) ==
            0) return true;
      }
    }
    return false;
  }
}
