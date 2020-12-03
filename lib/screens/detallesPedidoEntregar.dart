import 'package:diefpc/Clases/Delivery.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diefpc/documents/documents_service.dart';
import 'package:diefpc/screens/direccionVista.dart';
import 'package:diefpc/screens/home.dart';
import 'package:diefpc/states/auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:diefpc/app/app.dart';
import 'package:flutter/services.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:provider/provider.dart';

import 'entregarPedidos.dart';

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
  final _formKey = GlobalKey<FormState>();
  var txt = TextEditingController();
  DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

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
              Row(
                children: [
                  FloatingActionButton.extended(
                    heroTag: "1",
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    onPressed: () {
                      _showAlertAsignarPedido(context);
                    },
                    icon: Icon(Icons.timelapse),
                    label: Text('Modificar\nEntrega'),
                  ),
                  Divider(
                    indent: screenlong / 12,
                  ),
                  FloatingActionButton.extended(
                    heroTag: "2",
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    onPressed: () {
                      goToDireccionVista(widget.document.data["Cliente"]);
                    },
                    icon: Icon(Icons.directions),
                    label: Text('Ver Direccion'),
                  ),
                ],
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
                  _showAlertConfirmar(context,
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
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showAlertConfirmar(BuildContext context, String notify) {
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

  void _showAlertAsignarPedido(BuildContext context) {
    // flutter defined function
    String hora;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(
              'Hora de entrega: ${widget.document.data["HoraEntrega"] != null ? widget.document.data["HoraEntrega"] + " del" : "Debe asignarle una hora de entrega al pedido al"} pedido.'),
          content: Form(
            key: _formKey,
            child: Container(
              height: screenHeight / 2,
              child: SingleChildScrollView(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                  validator: (value) {
                    if (value == null)
                      return "Debe ingresar horas y minutos";
                    else if (value.length < 4)
                      return "Por favor ingrese 4 digitos";
                    else if (int.parse(value[0] + value[1]) >= 24)
                      return "El pedido no puede demorarse\nmás de un día para su entrega";
                    else if (int.parse(value[2] + value[3]) >= 60)
                      return "Siga el formato de los minutos\nMiuntos < 60";
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      hora = value;
                      print(hora);
                    });
                  },
                  maxLength: 4,
                  autofocus: true,
                  decoration: new InputDecoration(
                      labelText: 'Horas y minutos sin el ":" -> 0130 = 01:30',
                      hintText:
                          'Ej: 0130 -> Llegará a las ${formatter.format(DateTime.now().add(Duration(hours: 1, minutes: 30)))}'),
                ),
              ),
            ),
          ),
          actions: [
            FlatButton(
              child: Text('Atrás'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('Aceptar Cambio'),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  print(txt.text);
                  asignarHora(context, hora);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EntregarPedidos()));
                }
              },
            ),
          ],
        );
      },
    );
  }

  void asignarHora(BuildContext context, String hora) async {
    int horas;
    int minutos;
    String delivery = widget.document.data["Delivery"];
    String tienda = widget.document.data["Tienda"];
    horas = int.parse(hora[0] + hora[1]);
    minutos = int.parse(hora[2] + hora[3]);
    try {
      await Firestore.instance
          .collection('usuarios')
          .document(tienda)
          .collection('PedidosPendientes')
          .document(widget.document.documentID)
          .get()
          // ignore: missing_return
          .then((ds) async {
        Firestore.instance
            .collection("usuarios")
            .document(tienda)
            .collection("PedidosPendientes")
            .document(ds.documentID)
            .setData({
          "HoraEntrega": formatter.format(
              DateTime.now().add(Duration(hours: horas, minutes: minutos))),
        }, merge: true);

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
                .delete();

            sendEmail(delivery,
                "Se está cambiando la hora al pedido ${widget.document.documentID}, en caso de no aparecer en su lista, contactese con la tienda");

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
                .setData({
              "HoraEntrega": formatter.format(
                  DateTime.now().add(Duration(hours: horas, minutes: minutos))),
            }, merge: true);

            Firestore.instance
                .collection('usuarios')
                .document(ds.data["Cliente"])
                .collection('Pedidos')
                .document(ds.documentID)
                .setData({
              "HoraEntrega": formatter.format(
                  DateTime.now().add(Duration(hours: horas, minutes: minutos))),
            }, merge: true);

            (await Firestore.instance
                    .collection('usuarios')
                    .document(_user.getEmail())
                    .collection('PedidosPendientes')
                    .document(widget.document.documentID)
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
          "Se ha modificado la hora de entrega del pedido ${widget.document.documentID}, por favor revise su aplicación DIEFP-C en la seccion de Pedidos");
    } catch (error) {
      return _showAlert(
          context, 'Ocurrió un error al cambiar la hora de entrega');
    }
    return _showAlert(context, "Se cambio la hora de entrega");
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
