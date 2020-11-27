import 'package:diefpc/Clases/Delivery.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diefpc/documents/documents_service.dart';
import 'package:diefpc/screens/direccionVista.dart';
import 'package:diefpc/screens/home.dart';
import 'package:diefpc/states/auth.dart';
import 'package:flutter/material.dart';
import 'package:diefpc/app/app.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:provider/provider.dart';

class DetallesPedidoEntregar extends StatefulWidget {
  DocumentSnapshot document;
  DetallesPedidoEntregar({this.document}) {
    this.document = document;
  }
  @override
  _DetallesPedidoEntregarState createState() => _DetallesPedidoEntregarState();
}

// ignore: must_be_immutable
class ListTileItem extends StatefulWidget {
  int index;
  List<DocumentSnapshot> listDocument;
  ListTileItem({this.index, this.listDocument});
  @override
  _ListTileItemState createState() => new _ListTileItemState();
}

class _ListTileItemState extends State<ListTileItem> {
  DocumentSnapshot document;
  @override
  Widget build(BuildContext context) {
    document = widget.listDocument[widget.index];
    return ListTile(
      leading: IconButton(
        icon: Icon(Icons.local_hospital),
        iconSize: 40,
        tooltip: 'Productos',
        onPressed: () {},
      ),
      title: Text(document.data["Nombre"]),
      subtitle: Text("Cantidad: " +
          document.data["Cantidad"] +
          "\n" +
          "Precio: " +
          document.data["Precio"]),
      trailing: Text((int.parse(document.data["Cantidad"]) *
              int.parse(document.data["Precio"]))
          .toString()),
      isThreeLine: true,
    );
  }
}

class _DetallesPedidoEntregarState extends State<DetallesPedidoEntregar> {
  double screenlong;
  double screenHeight;
  int cont;
  Delivery _user;
  List<DocumentSnapshot> listDocuments;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenlong = MediaQuery.of(context).size.longestSide;
    screenHeight = MediaQuery.of(context).size.height;
    _user = Provider.of<AuthService>(context).currentUser();
    cargarProductosPedido();
    return Scaffold(
      appBar: AppBar(
        title: Text("Entregar/Revisar\nProductos"),
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
              FloatingActionButton.extended(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                onPressed: () {
                  goToDireccionVista(widget.document.data["Cliente"]);
                },
                icon: Icon(Icons.directions),
                label: Text('Ver Direccion'),
              ),
              Container(
                //height: screenHeight / 3,
                //padding: EdgeInsets.only(top: 10),
                child: Card(
                  elevation: 5,
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
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
                          Text(
                              " ${widget.document.data["Costo de Envío"].toString()} Pesos",
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
                          Text(
                              "\n ${(widget.document.data["Total Pagado"] - widget.document.data["Costo de Envío"]).toString()} Pesos",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.blue)),
                        ],
                      ),
                      Row(
                        children: [
                          Text("\n Costo Total Con Envio:",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.blue)),
                          Text(
                              "\n ${widget.document.data["Total Pagado"].toString()} Pesos",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.blue)),
                        ],
                      ),
                      Row(
                        children: [
                          Text("\n Medio de Pago:",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.blue)),
                          Text("\n ${widget.document.data["Medio de Pago"]}",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.blue)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              FloatingActionButton.extended(
                elevation: 0,
                heroTag: "botonh1",
                icon: Icon(Icons.check_box),
                onPressed: () {
                  _showAlert(context,
                      "Confirmar la entrega del pedido.\nEn caso contrario, presione en el botón ATRÁS o fuera del cuadro AVISO");
                },
                label: Text("Entregar Pedido"),
                backgroundColor: Colors.blue,
              ),
              /*Divider(
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
              ),*/
            ])),
      ),
    );
  }

  void cargarProductosPedido() async {
    List<DocumentSnapshot> productos =
        await getListDocumentCollectionDocumentService(
            _user.email, "Pedidos", widget.document.documentID);
    if (productos != null) {
      setState(() {
        listDocuments = productos;
      });
    }
  }

  Widget _queyList(BuildContext context) {
    if (listDocuments != null) {
      return ListView(
          children: List.generate(listDocuments.length,
              (i) => new ListTileItem(index: i, listDocument: listDocuments)));
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

  void entregarPedido() async {
    DocumentSnapshot document = widget.document;
//Delivery
    Firestore.instance
        .collection("usuarios")
        .document(_user.email)
        .collection("Pedidos")
        .document(document.documentID)
        .setData({"PorEntregar": false}, merge: true);

    Firestore.instance
        .collection("usuarios")
        .document(_user.email)
        .collection("HistorialEntregas")
        .document(document.documentID)
        .setData(document.data);

    Firestore.instance
        .collection("usuarios")
        .document(_user.email)
        .collection("HistorialEntregas")
        .document(document.documentID)
        .setData({"PorEntregar": false}, merge: true);

    (await Firestore.instance
            .collection("usuarios")
            .document(_user.email)
            .collection("Pedidos")
            .document(document.documentID)
            .collection('Productos')
            .getDocuments())
        .documents
        .forEach((element) {
      Firestore.instance
          .collection("usuarios")
          .document(_user.email)
          .collection("HistorialEntregas")
          .document(document.documentID)
          .collection('Productos')
          .document(element.documentID)
          .setData(element.data);
    });
//Tienda
    (await Firestore.instance
            .collection("usuarios")
            .document(_user.email)
            .collection("Pedidos")
            .document(document.documentID)
            .collection("Productos")
            .getDocuments())
        .documents
        .forEach((element) {
      Firestore.instance
          .collection('usuarios')
          .document(document.data["Tienda"])
          .collection("HistorialVentas")
          .document(element.documentID)
          .setData(element.data);

      Firestore.instance
          .collection('usuarios')
          .document(document.data["Tienda"])
          .collection("HistorialVentas")
          .document(element.documentID)
          .setData({
        "day": DateTime.now().day.toString(),
        "month": DateTime.now().month.toString()
      }, merge: true);
    });
    //Cliente
    Firestore.instance
        .collection('usuarios')
        .document(document.data["Cliente"])
        .collection('HistorialCompras')
        .document(document.documentID)
        .setData(document.data);

    Firestore.instance
        .collection('usuarios')
        .document(document.data["Cliente"])
        .collection('HistorialCompras')
        .document(document.documentID)
        .setData({"PorEntregar": false}, merge: true);

    (await Firestore.instance
            .collection("usuarios")
            .document(_user.email)
            .collection("Pedidos")
            .document(document.documentID)
            .collection("Productos")
            .getDocuments())
        .documents
        .forEach((element) {
      Firestore.instance
          .collection('usuarios')
          .document(document.data["Cliente"])
          .collection('HistorialCompras')
          .document(document.documentID)
          .collection('Productos')
          .document(element.documentID)
          .setData(element.data);
    });
//eliminar pedidos
    Firestore.instance
        .collection('usuarios')
        .document(document.data["Cliente"])
        .collection("Pedidos")
        .document(document.documentID)
        .delete();
    Firestore.instance
        .collection('usuarios')
        .document(document.data["Tienda"])
        .collection('PedidosPendientes')
        .document(document.documentID)
        .delete();
    Firestore.instance
        .collection('usuarios')
        .document(_user.email)
        .collection('Pedidos')
        .document(document.documentID)
        .delete();

    sendEmail(document.data["Tienda"],
        "Se ha entregado un pedido por parte del Delivery: ${_user.email}.");
    sendEmail(document.data["Cliente"],
        "Su pedido de ${document.data["nombreTienda"]}, fue entregado satisfactoriamente por el Delivery: ${_user.email}.");
    sendEmail(_user.email,
        "Se entregó el pedido y ha sido notificado tanto al cliente: ${document.data["Cliente"]}, como a la tienda: ${document.data["Tienda"]}.");
  }

  void goToSeguimiento(BuildContext context, String uid) async {
    /*List<DocumentSnapshot> carritoDocument =
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
        }
      }

      for (x = 0; x < _saved.length; x++) {
        List<String> listCatego = List<String>.from(_user
            .getCarritoDeCompra()
            .getListProducto()
            .elementAt(x)
            .getCategoria());
        print(listCatego);
        for (int v = 0; v < listCatego.length; v++) {
          if (categorias.contains(listCatego.elementAt(v)) == false)
            categorias.add(listCatego.elementAt(v));
        }
      }

      String idTienda =
          _user.getCarritoDeCompra().getListProducto().first.getIdTienda();
      String nombreTienda =
          _user.getCarritoDeCompra().getListProducto().first.getNombreTienda();
      String horaPedido =
          "$format:${_user.getCarritoDeCompra().getListProducto().first.getIdTienda()}:${_user.getEmail()}";
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
        "Total Pagado": _totalCostoEnvio(costoDeEnvio(), idTienda),
        "Costo de Envío": costoDeEnvio(),
        "Tienda": idTienda,
        "Cliente": _user.email,
        "Categorias": categorias,
        "nombreTienda": nombreTienda,
        "lat": _user.getDireccion().getLatitud().toString(),
        "lng": _user.getDireccion().getLongitud().toString()
      });

      Firestore.instance
          .collection('usuarios')
          .document(idTienda)
          .collection('PedidosPendientes')
          .document(horaPedido)
          .setData({
        "Fecha": fecha.toString(),
        "PorAceptar": true,
        "PorEntregar": true,
        "Medio de Pago": medioDePago,
        "Total Pagado": _totalCostoEnvio(costoDeEnvio(), idTienda),
        "Costo de Envío": costoDeEnvio(),
        "Tienda": idTienda,
        "Cliente": _user.email,
        "Categorias": categorias,
        "nombreTienda": nombreTienda,
        "lat": _user.getDireccion().getLatitud().toString(),
        "lng": _user.getDireccion().getLongitud().toString()
      });

      for (x = 0; x < _saved.length; x++) {
        Firestore.instance
            .collection('usuarios')
            .document(uid)
            .collection('Pedidos')
            .document(horaPedido)
            .collection('Productos')
            .document(
                'Producto:$horaPedido:${carritoDocument.elementAt(x).documentID}')
            .setData(carritoDocument.elementAt(x).data);

        Firestore.instance
            .collection('usuarios')
            .document(idTienda)
            .collection('PedidosPendientes')
            .document(horaPedido)
            .collection('Productos')
            .document(
                'Producto:$horaPedido:${carritoDocument.elementAt(x).documentID}')
            .setData(carritoDocument.elementAt(x).data);
      }
      Pedido newPedido = new Pedido.carga(
          horaPedido,
          medioDePago,
          idTienda,
          _user.getEmail(),
          nombreTienda,
          costoEnvio,
          costoTotal,
          true,
          true,
          fecha,
          null,
          null,
          null,
          categorias,
          _user.getDireccion().getLatitud().toString(),
          _user.getDireccion().getLongitud().toString(),
          _user.getCarritoDeCompra());

      _user.setPedidoPendiente(newPedido);

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
      _deleted.add(_saved.first);
      _saved.clear();
    }
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Seguimiento()));*/
  }

  void goToDireccionVista(String id) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DireccionScreen(
                  id: id,
                )));
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
              child: new Text("Atrás"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                entregarPedido();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
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
  Future<void> sendEmail(String correo, String mensaje) async {
    String username = "diefpacientescronicos@gmail.com";
    String password = "Pacientescronicos13";
    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, "Aplicación DIEFP-C")
      ..recipients.add('$correo')
      //..ccRecipients.addAll( ['destCc1@example.com', 'destCc2@example.com'] )
      //..bccRecipients.add( Address( 'bccAddress@example.com' ) )
      ..subject = '${_user.getName()}.'
      //..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html = "<h1>$mensaje</h1>";
    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent. \n' + e.toString());
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }
}
