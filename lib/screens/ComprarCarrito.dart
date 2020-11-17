//import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'package:diefpc/Clases/Cliente.dart';
import 'package:diefpc/Clases/Pedido.dart';
import 'package:diefpc/Clases/Producto.dart';
import 'package:diefpc/screens/seguimientoCompra.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diefpc/documents/documents_service.dart';
import 'package:diefpc/states/auth.dart';
import 'package:flutter/material.dart';
import 'package:diefpc/app/app.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'carrito.dart';

class ComprarCarrito extends StatefulWidget {
  @override
  _ComprarCarritoState createState() => _ComprarCarritoState();
}

// ignore: must_be_immutable
class ListTileItem extends StatefulWidget {
  int index;
  ListTileItem({this.index});
  @override
  _ListTileItemState createState() => new _ListTileItemState();
}

class _ListTileItemState extends State<ListTileItem> {
  int count;
  @override
  Widget build(BuildContext context) {
    Cliente _user = Provider.of<AuthService>(context).currentUser();
    if (_user
            .getCarritoDeCompra()
            .getListProducto()[widget.index]
            .getCantidad() !=
        null) {
      count = _user
          .getCarritoDeCompra()
          .getListProducto()[widget.index]
          .getCantidad();
    } else {
      count = 1;
    }
    return ListTile(
      leading: IconButton(
        icon: Icon(Icons.local_hospital),
        iconSize: 40,
        tooltip: 'Productos',
        onPressed: () {},
      ),
      title: Text(_user
          .getCarritoDeCompra()
          .getListProducto()[widget.index]
          .getNombre()),
      subtitle: Text(_user
          .getCarritoDeCompra()
          .getListProducto()[widget.index]
          .getDatosAlComprar()),
      trailing: new Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
              icon: Icon(Icons.remove),
              onPressed: () => {
                    if (_user
                            .getCarritoDeCompra()
                            .getListProducto()[widget.index]
                            .getCantidad() >
                        0)
                      {
                        setState(() {
                          count--;
                          _user
                              .getCarritoDeCompra()
                              .getListProducto()[widget.index]
                              .setCantidad(count);
                          actualizarCarritoCant(
                              _user
                                  .getCarritoDeCompra()
                                  .getListProducto()[widget.index]
                                  .getCodigo(),
                              _user.getEmail(),
                              count);
                        })
                      }
                  }),
          Text("$count"),
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () => {
                    if (_user
                            .getCarritoDeCompra()
                            .getListProducto()[widget.index]
                            .getStock() >
                        count)
                      {
                        setState(() {
                          count++;
                          _user
                              .getCarritoDeCompra()
                              .getListProducto()[widget.index]
                              .setCantidad(count);
                          actualizarCarritoCant(
                              _user
                                  .getCarritoDeCompra()
                                  .getListProducto()[widget.index]
                                  .getCodigo(),
                              _user.getEmail(),
                              count);
                        })
                      }
                  })
        ],
      ),
      isThreeLine: true,
    );
  }

  void actualizarCarritoCant(String idProducto, String uid, int count) {
    Firestore.instance
        .collection('usuarios')
        .document(uid)
        .collection("Carrito")
        .document(idProducto)
        .setData({"Cantidad": count.toString()}, merge: true);
  }
}

class _ComprarCarritoState extends State<ComprarCarrito> {
  double screenlong;
  double screenHeight;
  int costoTotal;
  int cont;
  Timer timer;
  int costoEnvio;
  int costoCompleto;
  String medioDePago = 'Efectivo';
  Cliente _user;
  String nombre;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 2), (timer) => actualizarCobros());
  }

  @override
  Widget build(BuildContext context) {
    screenlong = MediaQuery.of(context).size.longestSide;
    screenHeight = MediaQuery.of(context).size.height;
    _user = Provider.of<AuthService>(context).currentUser();
    costoTotal = totalCosto();
    costoEnvio = costoDeEnvio();
    costoCompleto = costoTotal + costoEnvio;
    return Scaffold(
      appBar: AppBar(
        title: Text("Comprar Productos"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.list),
              tooltip: 'Configuración',
              onPressed: () {
                configMenu(context);
              }),
        ],
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            timer.cancel();
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.only(top: screenHeight / 100),
            //padding: EdgeInsets.only(left: 10, right: 10),
            child: Column(children: <Widget>[
              Row(
                children: <Widget>[
                  Divider(
                    indent: screenlong / 65,
                  ),
                  Text(
                    "Productos:",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                ],
              ),
              Container(
                height: screenHeight / 2.5,
                child: Card(
                  //elevation: 5,
                  //margin: EdgeInsets.all(0),
                  semanticContainer: true,
                  //color: Colors.transparent,
                  child: Theme(
                    data: ThemeData(
                      highlightColor: Colors.blue, //Does not work
                    ),
                    child: Scrollbar(child: _queyList(context)),
                  ),
                ),
              ),
              /* FloatingActionButton.extended(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        onPressed: () {
                          calcular();
                        },
                        icon: Icon(Icons.refresh),
                        label: Text('Calcular'),
                      ),*/
              Container(
                //height: screenHeight / 3,
                child: Card(
                  elevation: 5,
                  //margin: EdgeInsets.fromLTRB(0, top, 0, 0),
                  semanticContainer: true,
                  //color: Colors.transparent,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(" Costo de Envío:",
                              style: TextStyle(
                                  //fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.blue)),
                          Text(" $costoEnvio Pesos",
                              style: TextStyle(
                                  //fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.blue)),
                        ],
                      ),
                      Row(
                        children: [
                          Text("\n Costo Total Sin Envio:",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.blue)),
                          Text("\n $costoTotal Pesos",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.blue)),
                        ],
                      ),
                      Row(
                        children: [
                          Text("\n Costo Total Con Envio:",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.blue)),
                          Text("\n $costoCompleto Pesos",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.blue)),
                        ],
                      ),
                      Row(
                        children: [
                          Text(" Pagar con:",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.blue)),
                          Divider(
                            indent: screenlong / 30,
                          ),
                          DropdownButton<String>(
                            value: medioDePago,
                            icon: Icon(
                              Icons.arrow_downward,
                              color: Colors.blue,
                            ),
                            iconSize: 15,
                            //elevation: 16,
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
                            items: <String>['Efectivo']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text("$value",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.blue)),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              FloatingActionButton.extended(
                elevation: 0,
                heroTag: "boton2",
                icon: Icon(Icons.monetization_on),
                onPressed: () {
                  goToSeguimiento(context, _user.getEmail());
                },
                label: Text("Pagar"),
                backgroundColor: Colors.blue,
              ),
              Divider(
                height: 2,
              ),
              FloatingActionButton.extended(
                heroTag: "boton1",
                elevation: 0,
                icon: Icon(Icons.keyboard_backspace),
                onPressed: () {
                  timer.cancel();
                  Navigator.pop(context);
                },
                label: Text("Volver al carrito"),
                backgroundColor: Colors.blue,
              ),
              Divider(
                height: 5,
              ),
            ])),
      ),
    );
  }

  void calcular() {
    setState(() {
      costoTotal = totalCosto();
      costoEnvio = costoDeEnvio();
      costoCompleto = costoTotal + costoEnvio;
    });
  }

  Widget _queyList(BuildContext context) {
    var listDocuments = _user.getCarritoDeCompra();
    int carritoLength;
    if (listDocuments != null) {
      carritoLength = listDocuments.getListProducto().length;
      return ListView(
          children:
              List.generate(carritoLength, (i) => new ListTileItem(index: i)));
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

  int totalCosto() {
    int count = 0;
    int length;
    int i;
    int suma = 0;
    if (_user.getCarritoDeCompra().getListProducto().length > 0) {
      length = _user.getCarritoDeCompra().getListProducto().length;
      for (i = 0; i < length; i++) {
        if (_user
                    .getCarritoDeCompra()
                    .getListProducto()
                    .elementAt(i)
                    .getPrecio() !=
                null &&
            _user
                    .getCarritoDeCompra()
                    .getListProducto()
                    .elementAt(i)
                    .getCantidad() !=
                null)
          suma = suma +
              (_user
                      .getCarritoDeCompra()
                      .getListProducto()
                      .elementAt(i)
                      .getPrecio() *
                  _user
                      .getCarritoDeCompra()
                      .getListProducto()
                      .elementAt(i)
                      .getCantidad());
        count = count +
            _user
                .getCarritoDeCompra()
                .getListProducto()
                .elementAt(i)
                .getCantidad();
      }
    } else
      return 0;
    setState(() {
      cont = count;
    });
    return suma;
  }

  int _totalCostoEnvio(int costoEnvio, String idTienda) {
    int length;
    int i;
    int suma = 0;
    if (_user.getCarritoDeCompra().getListProducto().length > 0) {
      length = _user.getCarritoDeCompra().getListProducto().length;
      for (i = 0; i < length; i++) {
        if (_user
                .getCarritoDeCompra()
                .getListProducto()
                .elementAt(i)
                .getPrecio() !=
            null) if (_user
                .getCarritoDeCompra()
                .getListProducto()
                .elementAt(i)
                .getIdTienda()
                .toString()
                .compareTo(idTienda) ==
            0)
          suma = suma +
              (_user
                      .getCarritoDeCompra()
                      .getListProducto()
                      .elementAt(i)
                      .getPrecio() *
                  _user
                      .getCarritoDeCompra()
                      .getListProducto()
                      .elementAt(i)
                      .getCantidad());
      }
    } else
      return 0;
    return suma + costoEnvio;
  }

  int costoDeEnvio() {
    return (1000 * (1 + (cont / 10))).round();
  }

  void goToSeguimiento(BuildContext context, String uid) async {
    List<DocumentSnapshot> carritoDocument =
        await getListDocumentOneCollecionService(uid, dbCarrito);
    final _saved = Set<String>();
    final _deleted = Set<String>();
    List<String> categorias = List();
    DateTime fecha = DateTime.now();
    String format = DateFormat('yyyy-MM-dd – kk:mm').format(fecha);
    String pivot;
    int i;
    int j;
    int x;
    if (_user.getCarritoDeCompra() != null) {
      for (i = 0;
          i < _user.getCarritoDeCompra().getListProducto().length;
          i++) {
        pivot = _user
            .getCarritoDeCompra()
            .getListProducto()
            .elementAt(i)
            .getIdTienda();
        if (_deleted.contains(pivot) == false) {
          _saved.add(i.toString());
          for (j = i + 1;
              j < _user.getCarritoDeCompra().getListProducto().length;
              j++) {
            if (pivot.compareTo(_user
                    .getCarritoDeCompra()
                    .getListProducto()
                    .elementAt(j)
                    .getIdTienda()) ==
                0) {
              _saved.add(j.toString());
            }
          }
          for (x = 0; x < _saved.length; x++) {
            String horaPedido =
                "$format:${_user.getCarritoDeCompra().getListProducto().elementAt(x).getIdTienda()}";
            List<String> listCatego = _user
                .getCarritoDeCompra()
                .getListProducto()
                .elementAt(x)
                .getCategoria();
            for (int v = 0; v < listCatego.length; v++) {
              if (categorias.contains(listCatego.elementAt(v)) == false)
                categorias.add(listCatego.elementAt(v));
            }
            Firestore.instance
                .collection('usuarios')
                .document(uid)
                .collection('Pedidos')
                .document(horaPedido)
                .setData({
              "Fecha": fecha.toString(),
              "PorAceptar": true,
              "PorEntregar": true,
              "Medio de Pago": medioDePago,
              "Total Pagado": _totalCostoEnvio(
                  costoDeEnvio(),
                  _user
                      .getCarritoDeCompra()
                      .getListProducto()
                      .elementAt(x)
                      .getIdTienda()),
              "Costo de Envío": costoDeEnvio(),
              "Tienda": _user
                  .getCarritoDeCompra()
                  .getListProducto()
                  .elementAt(x)
                  .getIdTienda(),
              "Cliente": _user.email,
              "Categorias": categorias,
              "nombreTienda": _user
                  .getCarritoDeCompra()
                  .getListProducto()
                  .elementAt(x)
                  .getNombreTienda()
            });
            Firestore.instance
                .collection('usuarios')
                .document(uid)
                .collection('Pedidos')
                .document(horaPedido)
                .collection('Productos')
                .document(
                    'Producto:$horaPedido:${carritoDocument.elementAt(x).documentID}')
                .setData(carritoDocument.elementAt(x).data);

            Pedido newPedido = new Pedido.carga(
                horaPedido,
                medioDePago,
                _user
                    .getCarritoDeCompra()
                    .getListProducto()
                    .elementAt(x)
                    .getIdTienda(),
                _user.getEmail(),
                _user
                    .getCarritoDeCompra()
                    .getListProducto()
                    .elementAt(x)
                    .getNombreTienda(),
                costoEnvio,
                costoTotal,
                true,
                true,
                fecha,
                null,
                categorias,
                _user.getCarritoDeCompra());

            _user.setPedidoPendiente(newPedido);

            Firestore.instance
                .collection('usuarios')
                .document(_user
                    .getCarritoDeCompra()
                    .getListProducto()
                    .elementAt(x)
                    .getIdTienda())
                .collection('PedidosPendientes')
                .document(horaPedido)
                .setData({
              "Fecha": fecha.toString(),
              "PorAceptar": true,
              "PorEntregar": true,
              "Medio de Pago": medioDePago,
              "Total Pagado": _totalCostoEnvio(
                  costoDeEnvio(),
                  _user
                      .getCarritoDeCompra()
                      .getListProducto()
                      .elementAt(x)
                      .getIdTienda()),
              "Costo de Envío": costoDeEnvio(),
              "Tienda": _user
                  .getCarritoDeCompra()
                  .getListProducto()
                  .elementAt(x)
                  .getIdTienda(),
              "Cliente": _user.email,
              "Categorias": categorias,
              "nombreTienda": _user
                  .getCarritoDeCompra()
                  .getListProducto()
                  .elementAt(x)
                  .getNombreTienda()
            });

            Firestore.instance
                .collection('usuarios')
                .document(_user
                    .getCarritoDeCompra()
                    .getListProducto()
                    .elementAt(x)
                    .getIdTienda())
                .collection('PedidosPendientes')
                .document(horaPedido)
                .collection('Productos')
                .document(
                    'Producto:$horaPedido:${carritoDocument.elementAt(x).documentID}')
                .setData(carritoDocument.elementAt(x).data);

            /*/Testing compra
            Firestore.instance
                .collection('usuarios')
                .document(_user.getEmail())
                .collection('HistorialCompras')
                .document(horaPedido)
                .setData({
              "Fecha": fecha.toString(),
              "PorAceptar": false, //aceptado
              "PorEntregar": false, //entregado
              "Medio de Pago": medioDePago,
              "HoraEntrega": fecha.add(new Duration(hours: 2)).toString(),
              "Total Pagado": _totalCostoEnvio(
                  costoDeEnvio(),
                  _user
                      .getCarritoDeCompra()
                      .getListProducto()
                      .elementAt(x)
                      .getIdTienda()),
              "Costo de Envío": costoDeEnvio(),
              "Tienda": _user
                  .getCarritoDeCompra()
                  .getListProducto()
                  .elementAt(x)
                  .getIdTienda(),
              "Cliente": _user.email,
              "Categorias": categorias,
              "nombreTienda": _user
                  .getCarritoDeCompra()
                  .getListProducto()
                  .elementAt(x)
                  .getNombreTienda()
            });

            Firestore.instance
                .collection('usuarios')
                .document(_user.getEmail())
                .collection('HistorialCompras')
                .document(horaPedido)
                .collection('Productos')
                .document(
                    'Producto:$horaPedido:${carritoDocument.elementAt(x).documentID}')
                .setData(carritoDocument.elementAt(x).data);

            _user.setCompra(newPedido);*/
          }
          _deleted.add(_saved.first);
          _saved.clear();
        }
      }
      Firestore.instance
          .collection('usuarios')
          .document(uid)
          .collection('Carrito')
          .getDocuments()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.documents) {
          ds.reference.delete();
        }
      });
      _user.deleteCarrito();
    }
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Seguimiento()));
  }

  void goToCarrito(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CarritoCompras()));
  }

  // ignore: unused_element
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
    return _user.getCarritoDeCompra().getListProducto().contains(id);
  }

  void actualizarCobros() {
    setState(() {
      costoTotal = totalCosto();
      costoEnvio = costoDeEnvio();
      costoCompleto = costoTotal + costoEnvio;
    });
  }
}
