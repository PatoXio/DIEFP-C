import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diefpc/Clases/Delivery.dart';
import 'package:diefpc/Clases/Pedido.dart';
import 'package:diefpc/screens/productosPedido.dart';
import 'package:diefpc/states/auth.dart';
import 'package:flutter/material.dart';
import 'package:diefpc/app/app.dart';
import 'package:flutter/services.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:provider/provider.dart';
import 'carrito.dart';
import 'package:intl/intl.dart';
import 'createProducto.dart';

class PedidosDisponibles extends StatefulWidget {
  @override
  _PedidosDisponiblesState createState() => _PedidosDisponiblesState();
}

class _PedidosDisponiblesState extends State<PedidosDisponibles> {
  double screenlong;
  double screenHeight;
  Widget isLoad;
  Widget verDelivery;
  DateFormat formatter = DateFormat('HH:mm');
  Delivery _user;
  Stream<QuerySnapshot> _stream;
  var _saved = List<String>();

  @override
  Widget build(BuildContext context) {
    _user = Provider.of<AuthService>(context).currentUser();
    screenlong = MediaQuery.of(context).size.longestSide;
    screenHeight = MediaQuery.of(context).size.height;
    _stream = Firestore.instance
        .collection('usuarios')
        .document(_user.email)
        .collection('Pedidos')
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedidos Aceptados"),
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
            return Column(
              children: [
                Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.only(top: screenHeight / 100),
                      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                      child: Theme(
                        data: ThemeData(
                          highlightColor: Colors.blue, //Does not work
                        ),
                        child: Scrollbar(
                          child: _queyList(context, snapshot),
                        ),
                      ),
                    )),
              ],
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
      return ListView.builder(
          itemCount: snapshot.data.documents.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) =>
              buildBody(context, index, snapshot.data.documents));
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
    if (listDocument[index].data["Cliente"] != null) {
      return Container(
        //margin: EdgeInsets.only(top: screenHeight / 100),
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Card(
          child: ListTile(
            onLongPress: () {
              /*goToProductosPedido(
                  context,
                  _user
                      .getListPedidosPendientes()
                      .getPedidosAceptados()[index]);*/
            },
            leading: IconButton(
              icon: Icon(Icons.local_hospital),
              iconSize: 40,
              tooltip: 'Pedidos',
              onPressed: () {},
            ),
            title: Text(listDocument[index].data["Cliente"]),
            subtitle: Text("Hora: " +
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
    } else
      return CircularProgressIndicator();
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

  void asignarPedido(BuildContext context, String delivery) async {
    int largo = _saved.length;
    int i;
    /*try {
      for (i = 0; i < largo; i++) {
        await Firestore.instance
            .collection('usuarios')
            .document(_user.getEmail())
            .collection('PedidosPendientes')
            .document(_saved.elementAt(i))
            .get()
            // ignore: missing_return
            .then((ds) async {
          Firestore.instance
              .collection("usuarios")
              .document(_user.getEmail())
              .collection("PedidosPendientes")
              .document(ds.documentID)
              .setData({"Delivery": delivery}, merge: true);

          await Firestore.instance
              .collection('usuarios')
              .document(delivery)
              .get()
              .then((deli) async {
            if (deli.data["tipo"].compareTo("Delivery") == 0) {
              if (_user.getPedidoPendiente(ds.documentID) != null) {
                if (_user.getPedidoPendiente(ds.documentID).getDelivery() !=
                    null) {
                  String delive =
                      _user.getPedidoPendiente(ds.documentID).getDelivery();
                  Firestore.instance
                      .collection('usuarios')
                      .document(delive)
                      .collection('Pedidos')
                      .document(ds.documentID)
                      .delete();
                  _user.getListPedidosPendientes().getPedidosAceptados()
                      // ignore: missing_return
                      .where((element) {
                    if (element.getId().compareTo(ds.documentID) == 0) {
                      element.setDelivery(null);
                    }
                  });
                  sendEmail(
                      delivery, "El pedido se ha reasignado a otro delivery");
                }
              }

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
                      .document(_user.getEmail())
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
        sendEmail(delivery,
            "Se ha añadido un nuevo pedido a su lista, por favor revise su aplicación DIEFP-C en la seccion de Pedidos");
        _user.getListPedidosPendientes().getPedidosAceptados().where((element) {
          if (element.getId().compareTo(_saved.elementAt(i)) == 0) {
            element.setDelivery(delivery);
          }
        });
      }
    } catch (error) {
      return _showAlert(context, 'Ocurrió un error al aceptar los pedidos');
    }
    setState(() {
      _saved.clear();
      Provider.of<AuthService>(context).actualizarUser(_user);
    });*/
    return _showAlert(context, "Se aceptaron los pedidos");
  }

  void cancelarPedido(BuildContext context, Set<String> _saved,
      Set<String> _usuarios, String mensaje) async {
    /*int i;
    int largo = _saved.length;
    for (i = 0; i < largo; i++) {
      Firestore.instance
          .collection('usuarios')
          .document(_user.getEmail())
          .collection('PedidosPendientes')
          .document(_saved.elementAt(i))
          .delete();
      _user.getListPedidosPendientes().getPedidosAceptados().removeWhere(
          (element) => element.getId().compareTo(_saved.elementAt(i)) == 0);

      Firestore.instance
          .collection('usuarios')
          .document(_usuarios.elementAt(i))
          .collection('Pedidos')
          .document(_saved.elementAt(i))
          .delete();
      sendEmail(_usuarios.elementAt(i), mensaje);

      setState(() {
        _usuarios.clear();
        _saved.clear();
        Provider.of<AuthService>(context).actualizarUser(_user);
      });
    }*/
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

  void _showAlertPedidoCancelado(BuildContext context, List<String> _saved) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text('Ingrese el motivo de la cancelación'),
          content: new Row(
            children: [
              new Expanded(
                  child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Motivo:', hintText: 'Ej: No tenemos stock'),
                onChanged: (value) {},
              ))
            ],
          ),
          actions: [
            FlatButton(
              child: Text('Atrás'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('Enviar notificación'),
              onPressed: () {
                //cancelarPedido(context, _saved, _usuarios, mensaje);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showAlertAsignarPedido(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text('Se asignaran ${_saved.length} pedido(s).'),
          content: new Row(
            children: [
              new Expanded(
                child: new TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null) {
                      return "Debe ingresar el correo del Delivery";
                    } else if (value.contains('@') == false) {
                      return "Debe ingresar un correo válido";
                    } else {}
                  },
                  autofocus: true,
                  decoration: new InputDecoration(
                      labelText: 'Correo del Delivery',
                      hintText: 'Ej: ejemplo@mail.com'),
                ),
              ),
            ],
          ),
          actions: [
            FlatButton(
              child: Text('Atrás'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('Aceptar Pedido'),
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
    String username = "patricio.igtr@gmail.com";
    String password = "Raideon133";
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
