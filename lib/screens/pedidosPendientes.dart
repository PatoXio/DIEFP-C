import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diefpc/Clases/Pedido.dart';
import 'package:diefpc/Clases/Tienda.dart';
import 'package:diefpc/screens/productosPedido.dart';
import 'package:diefpc/states/auth.dart';
import 'package:flutter/material.dart';
import 'package:diefpc/app/app.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:provider/provider.dart';
import 'carrito.dart';
import 'createProducto.dart';

class PedidosPendientes extends StatefulWidget {
  @override
  _PedidosPendientesState createState() => _PedidosPendientesState();
}

class _PedidosPendientesState extends State<PedidosPendientes> {
  double screenlong;

  double screenHeight;

  Tienda _user;

  var _saved = Set<String>();

  var _usuarios = Set<String>();

  @override
  Widget build(BuildContext context) {
    Provider.of<AuthService>(context).actualizarPedidosPendientes();
    _user = Provider.of<AuthService>(context).currentUser();
    screenlong = MediaQuery.of(context).size.longestSide;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedidos Pendientes"),
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
                  aceptarPedido(context, _saved, _usuarios);
                else
                  return _showAlert(context, "Debes elegir al menos 1 pedido");
              },
              label: Text("Aceptar Pedidos"),
              backgroundColor: Colors.blue,
            ),
            Divider(
              indent: screenlong / 60,
            ),
            FloatingActionButton.extended(
              heroTag: "boton2",
              onPressed: () {
                if (_saved.length != 0) {
                  _showAlertPedidoCancelado(context, _saved, _usuarios);
                } else
                  return _showAlert(context, "Debes elegir al menos 1 pedido");
              },
              label: Text("Cancelar Pedido"),
              backgroundColor: Colors.red,
            ),
          ]),
        ]),
      ),
    );
  }

  TextStyle _styleText() {
    return TextStyle(
        fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black);
  }

  Widget _queyList(BuildContext context, String idTienda) {
    if (_user.getListPedidosPendientes().getListPedido().length != 0) {
      return ListView.builder(
          itemCount: _user.getListPedidosPendientes().getListPedido().length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) => buildBody(context,
              index, _user.getListPedidosPendientes().getListPedido()));
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

  Widget buildBody(BuildContext context, int index, List<Pedido> listPedido) {
    double screenHeight = MediaQuery.of(context).size.height;
    if (listPedido[index].getIdUsuario() == null)
      return CircularProgressIndicator();
    return Container(
      margin: EdgeInsets.only(top: screenHeight / 1000),
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Card(
        child: ListTile(
          onLongPress: () {
            goToProductosPedido(context, listPedido[index]);
          },
          leading: IconButton(
            icon: Icon(Icons.local_hospital),
            iconSize: 40,
            tooltip: 'Pedidos',
            onPressed: () {},
          ),
          title: Text(listPedido[index].getIdUsuario().split("@")[0]),
          subtitle: Text(listPedido[index].getDatosTienda()),
          trailing: _iconTravel(
              listPedido[index].getId(), listPedido[index].getIdUsuario()),
          isThreeLine: true,
        ),
      ),
    );
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
                    _usuarios.add(idUsuario);
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

  void aceptarPedido(BuildContext context, Set<String> _saved, var _user) {
    int largo = _saved.length;
    int i;
    try {
      for (i = 0; i < largo; i++) {
        Firestore.instance
            .collection('usuarios')
            .document(_user.getEmail())
            .collection('PedidosPendientes')
            .document(_saved.elementAt(i))
            .get()
            // ignore: missing_return
            .then((DocumentSnapshot ds) {
          Firestore.instance
              .collection('usuarios')
              .document(_user.getEmail())
              .collection('ComprasRealizadas')
              .add(ds.data);
        });
      }
      _saved.clear();
    } catch (error) {
      return _showAlert(context, 'Ocurrió un error al aceptar los pedidos');
    }
    return _showAlert(context, "Se aceptaron los pedidos");
  }

  void cancelarPedido(BuildContext context, Set<String> _saved,
      Set<String> _usuarios, String mensaje) {
    int i;
    int largo = _saved.length;
    for (i = 0; i < largo; i++) {
      Firestore.instance
          .collection('usuarios')
          .document(_user.getEmail())
          .collection('PedidosPendientes')
          .document(_saved.elementAt(i))
          .delete();
      _user.getListPedidosPendientes().getListPedido().removeWhere(
          (element) => element.getId().compareTo(_saved.elementAt(i)) == 0);

      Firestore.instance
          .collection('usuarios')
          .document(_usuarios.elementAt(i))
          .collection('Pedidos')
          .document(_saved.elementAt(i))
          .delete();
      sendEmail(_usuarios.elementAt(i), mensaje);
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

  void _showAlertPedidoCancelado(
      BuildContext context, Set<String> _saved, Set<String> _usuarios) {
    // flutter defined function
    String mensaje;
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
                onChanged: (value) {
                  mensaje = value;
                },
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
                cancelarPedido(context, _saved, _usuarios, mensaje);
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
      ..from = Address(username, "Aplicación Diefp-c")
      ..recipients.add('$correo')
      //..ccRecipients.addAll( ['destCc1@example.com', 'destCc2@example.com'] )
      //..bccRecipients.add( Address( 'bccAddress@example.com' ) )
      ..subject = '${_user.getName()} ha tenido que cancelar su pedido.'
      //..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html =
          "<h1>Motivo: $mensaje</h1>\n<p>Esperemos no tener más inconvenientes y resolver los problemas lo más pronto posible</p>\n<p>De antemano, muchas gracias por su comprensión</p>";
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
