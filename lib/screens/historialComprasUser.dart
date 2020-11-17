import 'package:diefpc/Clases/Cliente.dart';
import 'package:diefpc/states/auth.dart';
import 'package:flutter/material.dart';
import 'package:diefpc/app/app.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'historialProductosUser.dart';

class HistorialCompras extends StatefulWidget {
  @override
  _HistorialComprasState createState() => _HistorialComprasState();
}

class _HistorialComprasState extends State<HistorialCompras> {
  Cliente _user;
  double screenlong;
  var isHistorialCompra;
  double screenHeight;
  @override
  Widget build(BuildContext context) {
    screenlong = MediaQuery.of(context).size.longestSide;
    screenHeight = MediaQuery.of(context).size.height;
    _user = Provider.of<AuthService>(context).currentUser();
    if (_user.getHistorialDeCompras() != null) {
      if (_user.getHistorialDeCompras().getListPedido().isNotEmpty) {
        isHistorialCompra = Expanded(
          child: Container(
            height: screenHeight / 1.5,
            child: Theme(
              data: ThemeData(
                highlightColor: Colors.blue, //Does not work
              ),
              child: Scrollbar(child: _queyList(context)),
            ),
          ),
        );
      } else
        isHistorialCompra = Text("Aún no compras ningún producto.");
    } else {
      isHistorialCompra = CircularProgressIndicator();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Historial Compras"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.list),
              tooltip: 'Configuración',
              onPressed: () {
                configMenu(context);
              }),
        ],
      ),
      body: Center(
        child: Container(
          //margin: EdgeInsets.only(top: screenHeight / 100),
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: <Widget>[
              /*TextFormField(
                maxLength: 20,
                decoration: InputDecoration(
                  labelText: "Nombre Completo",
                ),
                onChanged: (String value) {},
              ),*/
              isHistorialCompra,
            ],
          ),
        ),
      ),
    );
  }

  Widget _queyList(BuildContext context) {
    if (_user.getHistorialDeCompras() != null) {
      return ListView.builder(
          itemCount: _user.getHistorialDeCompras().getListPedido().length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) =>
              buildBody(context, index));
    } else {
      return Text("Aún no has comprado algun medicamento");
    }
  }

  Widget buildBody(BuildContext context, int index) {
    String fecha = DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.parse(_user
        .getHistorialDeCompras()
        .getListPedido()[index]
        .getFecha()
        .toString()));
    String idDocument =
        _user.getHistorialDeCompras().getListPedido()[index].getId();
    return Card(
        child: ListTile(
      leading: IconButton(
        icon: Icon(
          Icons.shop_two,
          size: 40,
        ),
        iconSize: 20,
        tooltip: 'Productos',
        onPressed: () {},
      ),
      title: Text("$fecha"),
      subtitle:
          Text(_user.getHistorialDeCompras().getListPedido()[index].getDatos()),
      trailing: FloatingActionButton(
        heroTag: "hero$index",
        child: Text("Ver"),
        onPressed: () {
          goToComprasHechas(
              context,
              _user
                  .getHistorialDeCompras()
                  .getListPedido()[index]
                  .getIdTienda(),
              idDocument,
              _user
                  .getHistorialDeCompras()
                  .getListPedido()[index]
                  .getTotalPagado()
                  .toString(),
              _user
                  .getHistorialDeCompras()
                  .getListPedido()[index]
                  .getCostoDeEnvio()
                  .toString());
        },
      ),
      isThreeLine: true,
    ));
  }

  void goToComprasHechas(BuildContext context, String idTienda,
      String idDocument, String totalPagado, String costoEnvio) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => new HistorialProductos(
                idTienda, idDocument, totalPagado, costoEnvio)));
  }
}
