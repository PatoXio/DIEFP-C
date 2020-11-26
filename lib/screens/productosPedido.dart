import 'package:diefpc/Clases/Pedido.dart';
import 'package:diefpc/Clases/Producto.dart';
import 'package:diefpc/screens/producto.dart';
import 'package:flutter/material.dart';
import 'package:diefpc/app/app.dart';
import 'package:intl/intl.dart';

class ProductosPedido extends StatefulWidget {
  Pedido pedido;
  ProductosPedido({this.pedido});
  @override
  _ProductosPedidoState createState() => _ProductosPedidoState();
}

class ListTileItem extends StatefulWidget {
  int index;
  List<Producto> listProducto;
  ListTileItem({this.index, this.listProducto});
  @override
  _ListTileItemState createState() => new _ListTileItemState();
}

class _ListTileItemState extends State<ListTileItem> {
  Producto producto;
  @override
  Widget build(BuildContext context) {
    producto = widget.listProducto.elementAt(widget.index);
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
      title: Text(producto.getNombre()),
      subtitle: Text(producto.getDatosAlComprar() +
          "\nCantidad: " +
          producto.getCantidad().toString() +
          "\nCódigo: " +
          producto.getCodigo()),
      trailing: Text("Total " +
          (producto.getCantidad() * producto.getPrecio()).toString()),
      isThreeLine: true,
    );
  }
}

class _ProductosPedidoState extends State<ProductosPedido> {
  double screenlong;
  double screenHeight;
  DateFormat formatter = DateFormat('HH:mm');
  int costoTotal = 0;
  int count = 0;
  @override
  Widget build(BuildContext context) {
    screenlong = MediaQuery.of(context).size.longestSide;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Productos del Pedido\n${widget.pedido.getIdUsuario()}"),
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
                "Delivery: ${widget.pedido.getDelivery() == null ? "No Asignado" : widget.pedido.getDelivery()}"
                "\nCosto de Envío: ${widget.pedido.getCostoDeEnvio()}"
                "\nCosto Total: ${widget.pedido.getTotalPagado()}",
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
    if (widget.pedido != null) {
      return ListView(
          children: List.generate(
              widget.pedido.getListProducto().getListProducto().length,
              (i) => new ListTileItem(
                    index: i,
                    listProducto:
                        widget.pedido.getListProducto().getListProducto(),
                  )));
    } else {
      return Text("Ocurrió un error al mostrar los productos");
    }
  }

  void goToProducto(BuildContext context, String idProducto) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ProductoScreen(idProducto)));
  }
}
