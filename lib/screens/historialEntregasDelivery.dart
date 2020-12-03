import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diefpc/Clases/Delivery.dart';
import 'package:diefpc/Clases/ListProducto.dart';
import 'package:diefpc/Clases/Pedido.dart';
import 'package:diefpc/Clases/Producto.dart';
import 'package:diefpc/documents/documents_service.dart';
import 'package:diefpc/screens/entregarPedidos.dart';
import 'package:diefpc/screens/productosPedido.dart';
import 'package:diefpc/states/auth.dart';
import 'package:flutter/material.dart';
import 'package:diefpc/app/app.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class EntregasPedido extends StatefulWidget {
  String id;
  EntregasPedido({this.id}) {
    this.id = id;
  }
  @override
  _EntregasPedidoState createState() => _EntregasPedidoState();
}

class _EntregasPedidoState extends State<EntregasPedido> {
  double screenlong;
  double screenHeight;
  Widget isLoad;
  DateFormat formatter = DateFormat('dd-MM-yyyy HH:mm');
  Delivery _user;
  Stream<QuerySnapshot> _stream;

  @override
  Widget build(BuildContext context) {
    _user = Provider.of<AuthService>(context).currentUser();
    screenlong = MediaQuery.of(context).size.longestSide;
    screenHeight = MediaQuery.of(context).size.height;
    _stream = Firestore.instance
        .collection('usuarios')
        .document(_user.email)
        .collection("HistorialEntregas")
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        title: Text("Historial Entregas"),
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
    if (snapshot.data.documents != null) {
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
    return Container(
      //margin: EdgeInsets.only(top: screenHeight / 100),
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Card(
        child: ListTile(
          onLongPress: () {
            goToProductosPedido(context, listDocument[index]);
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
          isThreeLine: true,
        ),
      ),
    );
  }

  Future<void> goToProductosPedido(
      BuildContext context, DocumentSnapshot listPedido) async {
    List<DocumentSnapshot> listDocumentProducto =
        await getListDocumentCollectionDocumentService(
            _user.email, "HistorialEntregas", listPedido.documentID);
    Pedido pedido = Pedido.carga(
        listPedido.documentID,
        listPedido.data["Medio de Pago"],
        listPedido.data["Tienda"],
        listPedido.data["Cliente"].split("@")[0],
        listPedido.data["nombreTienda"],
        listPedido.data["Costo de Envío"],
        listPedido.data["Total Pagado"],
        listPedido.data["PorAceptar"],
        listPedido.data["PorEntregar"],
        DateTime.parse(listPedido.data["Fecha"]),
        listPedido.data["HoraEntrega"] == null
            ? null
            : DateTime.parse(listPedido.data["HoraEntrega"]),
        listPedido.data["Delivery"],
        listPedido.data["Preparacion"],
        List<String>.from(listPedido.data["Categorias"]),
        listPedido.data["lat"],
        listPedido.data["lng"],
        crearListaProductos(listDocumentProducto));
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductosPedido(
                  pedido: pedido,
                )));
  }

  ListProducto crearListaProductos(List<DocumentSnapshot> listDocument) {
    List<Producto> listProductos = new List<Producto>();
    int i;
    if (listDocument != null) {
      for (i = 0; i < listDocument.length; i++) {
        DocumentSnapshot document = listDocument[i];
        Producto producto = new Producto.carga(
            document.documentID,
            document.data["Codigo"],
            document.data["Tienda"],
            document.data["nombreTienda"],
            document.data["Nombre"],
            document.data["Categoria"],
            int.parse(document.data["Cantidad"]),
            int.parse(document.data["Precio"]),
            int.parse(document.data["Stock"]),
            int.parse(document.data["StockReservado"]),
            double.parse(document.data["Mg/u"]));
        listProductos.add(producto);
      }
    }
    return ListProducto.carga(listProductos);
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
}
