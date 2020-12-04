import 'package:diefpc/Clases/Cliente.dart';
import 'package:diefpc/Clases/Producto.dart';
import 'package:diefpc/screens/producto.dart';
import 'package:diefpc/states/auth.dart';
import 'package:flutter/material.dart';
import 'package:diefpc/app/app.dart';
import 'package:provider/provider.dart';

class HistorialProductos extends StatefulWidget {
  String idTienda;
  String idDocument;
  String totalPagado;
  String costoEnvio;
  String delivery;
  HistorialProductos(String idTienda, String idDocument, String totalPagado,
      String costoEnvio, String delivery) {
    this.idTienda = idTienda;
    this.idDocument = idDocument;
    this.totalPagado = totalPagado;
    this.costoEnvio = costoEnvio;
    this.delivery = delivery;
  }
  @override
  _HistorialProductosState createState() => _HistorialProductosState();
}

class ListTileItem extends StatefulWidget {
  int index;
  String idDocument;
  ListTileItem({this.index, this.idDocument});
  @override
  _ListTileItemState createState() => new _ListTileItemState();
}

class _ListTileItemState extends State<ListTileItem> {
  Cliente _user;
  Producto listProducto;
  @override
  Widget build(BuildContext context) {
    Provider.of<AuthService>(context).actualizarHistorial();
    _user = Provider.of<AuthService>(context).currentUser();
    listProducto = _user
        .getHistorialDeCompras()
        .getPedido(widget.idDocument)
        .getListProducto()
        .getListProducto()
        .elementAt(widget.index);
    return ListTile(
      leading: IconButton(
        icon: Icon(
          Icons.shop_two,
          size: 40,
        ),
        iconSize: 20,
        tooltip: 'Productos',
        onPressed: () {},
      ),
      title: Text(listProducto.getNombre()),
      subtitle: Text(listProducto.getDatos()),
      trailing: Text("Total " +
          (listProducto.getCantidad() * listProducto.getPrecio()).toString()),
      isThreeLine: true,
    );
  }
}

class _HistorialProductosState extends State<HistorialProductos> {
  Cliente _user;
  double screenlong;
  double screenHeight;
  int costoTotal = 0;
  int count = 0;
  @override
  Widget build(BuildContext context) {
    screenlong = MediaQuery.of(context).size.longestSide;
    screenHeight = MediaQuery.of(context).size.height;
    Provider.of<AuthService>(context).actualizarHistorial();
    _user = Provider.of<AuthService>(context).currentUser();
    return Scaffold(
      appBar: AppBar(
        title: Text("Productos Comprados"),
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
        //margin: EdgeInsets.only(top: screenHeight / 100),
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                height: screenHeight / 1.5,
                child: Theme(
                  data: ThemeData(
                    highlightColor: Colors.blue, //Does not work
                  ),
                  child: Scrollbar(child: _queyList(context)),
                ),
              ),
            ),
            Text(
                "Delivery: ${widget.delivery}\nCosto de Envío: ${widget.costoEnvio}\nCosto Total: ${widget.totalPagado}",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue)),
          ],
        ),
      ),
    );
  }

  Widget _queyList(BuildContext context) {
    if (_user.getHistorialDeCompras().getPedido(widget.idDocument) != null) {
      return ListView(
          children: List.generate(
              _user
                  .getHistorialDeCompras()
                  .getPedido(widget.idDocument)
                  .getListProducto()
                  .getListProducto()
                  .length,
              (i) =>
                  new ListTileItem(index: i, idDocument: widget.idDocument)));
    } else {
      return Text("Ocurrió un error al mostrar los productos");
    }
  }

  void goToProducto(BuildContext context, String idProducto) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ProductoScreen(idProducto)));
  }
}
