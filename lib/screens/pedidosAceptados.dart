import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diefpc/Clases/Pedido.dart';
import 'package:diefpc/Clases/Tienda.dart';
import 'package:diefpc/screens/perfilDelivery.dart';
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

class PedidosAceptados extends StatefulWidget {
  @override
  _PedidosAceptadosState createState() => _PedidosAceptadosState();
}

class _PedidosAceptadosState extends State<PedidosAceptados> {
  double screenlong;
  double screenHeight;
  Widget isLoad;
  Widget verDelivery;
  DateFormat formatter = DateFormat('HH:mm');
  Tienda _user;
  var _saved = List<String>();
  var _usuarios = List<String>();
  final _formKey = GlobalKey<FormState>();
  var txt = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Provider.of<AuthService>(context).actualizarPedidosPendientes();
    _user = Provider.of<AuthService>(context).currentUser();
    screenlong = MediaQuery.of(context).size.longestSide;
    screenHeight = MediaQuery.of(context).size.height;
    if (_usuarios.length == 1) {
      verDelivery = FloatingActionButton.extended(
        heroTag: "boton2",
        onPressed: () {
          if (_usuarios.length != 0) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PerfilDelivery(
                          delivery: _usuarios.first,
                        )));
          } else
            _showAlert(context, "Debes elegir al menos 1 pedido");
        },
        label: Text("Ver Delivery"),
        backgroundColor: Colors.blue,
      );
    } else {
      verDelivery = FloatingActionButton.extended(
        heroTag: "boton2",
        onPressed: () {},
        label: Text("Ver Delivery"),
        backgroundColor: Colors.grey,
      );
    }
    if (_user.getListPedidosPendientes().getPedidosAceptados() == null) {
      isLoad = Center(child: CircularProgressIndicator());
    } else
      isLoad = Column(children: <Widget>[
        Expanded(
          child: Container(
            height: screenHeight / 1.35,
            child: Theme(
              data: ThemeData(
                highlightColor: Colors.blue, //Does not work
              ),
              child: Scrollbar(child: _queyList(context, _user.getEmail())),
            ),
          ),
        ),
        Row(children: <Widget>[
          Divider(
            indent: screenlong / 90,
          ),
          FloatingActionButton.extended(
            heroTag: "boton1",
            onPressed: () {
              if (_saved.length != 0)
                _showAlertAsignarPedido(context);
              else
                return _showAlert(context, "Debes elegir al menos 1 pedido");
            },
            label: Text("Asignar Delivery"),
            backgroundColor: Colors.green,
          ),
          Divider(
            indent: screenlong / 40,
          ),
          verDelivery,
        ]),
      ]);
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
      body: Container(
        margin: EdgeInsets.only(top: screenHeight / 100),
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: isLoad,
      ),
    );
  }

  TextStyle _styleText() {
    return TextStyle(
        fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black);
  }

  Widget _queyList(BuildContext context, String idTienda) {
    Provider.of<AuthService>(context).actualizarPedidosPendientes();
    _user = Provider.of<AuthService>(context).currentUser();
    if (_user.getListPedidosPendientes().getPedidosAceptados().length != 0) {
      return ListView.builder(
          itemCount:
              _user.getListPedidosPendientes().getPedidosAceptados().length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) =>
              buildBody(context, index));
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

  Widget buildBody(BuildContext context, int index) {
    if (_user
            .getListPedidosPendientes()
            .getPedidosAceptados()[index]
            .getIdUsuario() !=
        null) {
      return Container(
        //margin: EdgeInsets.only(top: screenHeight / 100),
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Card(
          child: ListTile(
            onLongPress: () {
              goToProductosPedido(
                  context,
                  _user
                      .getListPedidosPendientes()
                      .getPedidosAceptados()[index]);
            },
            leading: IconButton(
              icon: Icon(Icons.local_hospital),
              iconSize: 40,
              tooltip: 'Pedidos',
              onPressed: () {},
            ),
            title: Text(_user
                .getListPedidosPendientes()
                .getPedidosAceptados()[index]
                .getIdUsuario()),
            subtitle: Text("Hora: " +
                formatter.format(_user
                    .getListPedidosPendientes()
                    .getPedidosAceptados()[index]
                    .getFecha()) +
                "\n" +
                _user
                    .getListPedidosPendientes()
                    .getPedidosAceptados()[index]
                    .getDatosTienda()),
            trailing: _iconTravel(
                _user
                    .getListPedidosPendientes()
                    .getPedidosAceptados()[index]
                    .getId(),
                _user
                    .getListPedidosPendientes()
                    .getPedidosAceptados()[index]
                    .getDelivery()),
            isThreeLine: true,
          ),
        ),
      );
    } else
      return CircularProgressIndicator();
  }

  Column _iconTravel(String id, String idUsuario) {
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
                    _usuarios.remove(idUsuario);
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
                    if (idUsuario != null) _usuarios.add(idUsuario);
                    print(_usuarios.length);
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
    try {
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
      _usuarios.clear();
      _saved.clear();
      Provider.of<AuthService>(context).actualizarUser(_user);
    });
    return _showAlert(context, "Se aceptaron los pedidos");
  }

  void cancelarPedido(BuildContext context, Set<String> _saved,
      Set<String> _usuarios, String mensaje) async {
    int i;
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
    }
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
                child: Form(
                  key: _formKey,
                  child: new TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: txt,
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
                if (_formKey.currentState.validate()) {
                  print(txt.text);
                  asignarPedido(context, txt.text);
                  Navigator.pop(context);
                }
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
