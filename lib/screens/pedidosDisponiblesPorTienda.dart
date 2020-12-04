import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diefpc/Clases/Delivery.dart';
import 'package:diefpc/Clases/Pedido.dart';
import 'package:diefpc/screens/entregarPedidos.dart';
import 'package:diefpc/screens/productosPedido.dart';
import 'package:diefpc/states/auth.dart';
import 'package:flutter/material.dart';
import 'package:diefpc/app/app.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:provider/provider.dart';
import 'carrito.dart';
import 'package:intl/intl.dart';
import 'createProducto.dart';
import 'direccionVista.dart';

class PedidosDisponibles extends StatefulWidget {
  String id;
  PedidosDisponibles({this.id}) {
    this.id = id;
  }
  @override
  _PedidosDisponiblesState createState() => _PedidosDisponiblesState();
}

class _PedidosDisponiblesState extends State<PedidosDisponibles> {
  double screenlong;
  double screenHeight;
  Widget isLoad;
  Query _query;
  Widget verDelivery;
  DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
  Delivery _user;
  Stream<QuerySnapshot> _stream;
  var _saved = List<String>();

  @override
  Widget build(BuildContext context) {
    _user = Provider.of<AuthService>(context).currentUser();
    screenlong = MediaQuery.of(context).size.longestSide;
    screenHeight = MediaQuery.of(context).size.height;
    print(widget.id);
    _query = Firestore.instance
        .collection('usuarios')
        .document(widget.id)
        .collection('PedidosPendientes')
        .where("PorAceptar", isEqualTo: false)
        .orderBy("Fecha", descending: false);
    _stream = _query.snapshots();
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedidos Disponibles"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.list),
              tooltip: 'Configuración',
              onPressed: () {
                configMenu(context);
              }),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _stream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Container(
              margin: EdgeInsets.only(top: screenHeight / 100),
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Column(
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                        child: Theme(
                          data: ThemeData(
                            highlightColor: Colors.blue, //Does not work
                          ),
                          child: Scrollbar(
                            child: _queyList(context, snapshot),
                          ),
                        ),
                      )),
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    child: FloatingActionButton.extended(
                      heroTag: "boton2",
                      onPressed: () {
                        if (_saved.isNotEmpty) {
                          asignarPedidos(context, _user.email);
                          goToEntregarPedidos(context);
                        } else
                          _showAlert(
                              context, "Debes seleccionar al menos 1 pedido.");
                      },
                      label:
                          Text("Tomar Pedidos", style: TextStyle(fontSize: 20)),
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  TextStyle _styleText() {
    return TextStyle(
        fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black);
  }

  Widget _queyList(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.data.documents.length != 0) {
      List<DocumentSnapshot> listDocument = new List<DocumentSnapshot>();
      for (int i = 0; i < snapshot.data.documents.length; i++) {
        if (snapshot.data.documents[i].data["Delivery"] == null) {
          listDocument.add(snapshot.data.documents[i]);
        }
      }
      if (listDocument.length > 0) {
        return ListView.builder(
            itemCount: listDocument.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) =>
                buildBody(context, index, listDocument));
      } else {
        Text(
          "La tienda no posee Pedidos Pendientes",
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
        "La tienda no posee Pedidos Pendientes",
        style: TextStyle(
          color: Colors.red,
          fontSize: 28,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      );
    }
  }

  Widget buildBody(
      BuildContext context, int index, List<DocumentSnapshot> listDocument) {
    if (listDocument[index].data["Delivery"] == null) {
      return Container(
        //margin: EdgeInsets.only(top: screenHeight / 100),
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Card(
          child: ListTile(
            onLongPress: () {
              goToDireccion(context, listDocument[index].data["Cliente"]);
            },
            leading: IconButton(
              icon: Icon(Icons.local_hospital),
              iconSize: 40,
              tooltip: 'Pedidos',
              onPressed: () {},
            ),
            title: Text(listDocument[index].data["Cliente"]),
            subtitle: Text("Fecha: " +
                formatter
                    .format(DateTime.parse(listDocument[index].data["Fecha"])) +
                "\n" +
                "Total: " +
                listDocument[index].data["Total Pagado"].toString() +
                "\n" +
                "Pago: " +
                listDocument[index].data["Medio de Pago"]),
            trailing: _iconTravel(listDocument[index].documentID),
            isThreeLine: true,
          ),
        ),
      );
    }
  }

  Column _iconTravel(String id) {
    final alreadySaved = _saved.contains(id);
    if (alreadySaved) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Seleccionar"),
          Expanded(
            child: IconButton(
                icon: Icon(Icons.indeterminate_check_box),
                color: Colors.red,
                iconSize: 20,
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
                iconSize: 20,
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

  void goToCreateProducto(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CrearProducto()));
  }

  void asignarPedidos(BuildContext context, String delivery) async {
    int largo = _saved.length;
    int i;
    try {
      for (i = 0; i < largo; i++) {
        await Firestore.instance
            .collection('usuarios')
            .document(widget.id)
            .collection('PedidosPendientes')
            .document(_saved.elementAt(i))
            .get()
            // ignore: missing_return
            .then((ds) async {
          Firestore.instance
              .collection("usuarios")
              .document(widget.id)
              .collection("PedidosPendientes")
              .document(ds.documentID)
              .setData({"Delivery": delivery}, merge: true);

          await Firestore.instance
              .collection('usuarios')
              .document(delivery)
              .get()
              .then((deli) async {
            if (deli.data["tipo"].compareTo("Delivery") == 0) {
              Firestore.instance
                  .collection('usuarios')
                  .document(delivery)
                  .collection('Pedidos')
                  .document(ds.documentID)
                  .setData(ds.data);
              Firestore.instance
                  .collection('usuarios')
                  .document(delivery)
                  .collection('Pedidos')
                  .document(ds.documentID)
                  .setData({"Delivery": delivery}, merge: true);

              (await Firestore.instance
                      .collection('usuarios')
                      .document(widget.id)
                      .collection('PedidosPendientes')
                      .document(_saved.elementAt(i))
                      .collection('Productos')
                      .getDocuments())
                  .documents
                  .forEach((element) {
                Firestore.instance
                    .collection('usuarios')
                    .document(delivery)
                    .collection('Pedidos')
                    .document(ds.documentID)
                    .collection('Productos')
                    .document(element.documentID)
                    .setData(element.data);
              });
            }
          });
        });
        sendEmail(widget.id,
            "El Delivery $delivery se ha asignado los siguientes pedidos: ${_saved.toList().map((e) => "-" + e + "-")}, por favor revise su aplicación DIEFP-C, en caso de no poder asignarle tales pedidos, puede ingresar a los pedidos aceptados y reasignar o eliminar el pedido");
      }
    } catch (error) {
      return _showAlert(context, 'Ocurrió un error al aceptar los pedidos');
    }
    setState(() {
      _saved.clear();
      Provider.of<AuthService>(context).actualizarUser(_user);
    });
    return _showAlert(context, "Se aceptaron los pedidos");
  }

  void goToCarrito(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CarritoCompras()));
  }

  void goToProductosPedido(BuildContext context, Pedido pedido) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductosPedido(
                  pedido: pedido,
                )));
  }

  void goToDireccion(BuildContext context, String id) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DireccionScreen(id: id)));
  }

  void goToEntregarPedidos(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => EntregarPedidos()));
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
