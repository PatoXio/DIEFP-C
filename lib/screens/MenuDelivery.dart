import 'package:diefpc/Clases/Usuario.dart';
import 'package:diefpc/screens/entregarPedidos.dart';
import 'package:diefpc/screens/historialEntregasDelivery.dart';
import 'package:diefpc/screens/home.dart';
import 'package:diefpc/screens/preAsignarPedidos.dart';
import 'package:diefpc/states/auth.dart';
import 'package:flutter/material.dart';
import 'package:diefpc/app/app.dart';
import 'package:provider/provider.dart';

class MenuScreenDelivery extends StatefulWidget {
  @override
  _MenuScreenDeliveryState createState() => _MenuScreenDeliveryState();
}

class _MenuScreenDeliveryState extends State<MenuScreenDelivery> {
  double screenHeight;
  Usuario _user;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    _user = Provider.of<AuthService>(context).currentUser();
    return Scaffold(
      appBar: AppBar(
        title: Text("Estás en el Menú"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.list),
              tooltip: 'Configuración',
              onPressed: () {
                configMenu(context);
              }),
        ],
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: screenHeight / 100),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: screenHeight / 100),
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Card(
                  child: ListTile(
                    leading: IconButton(
                      icon: Icon(Icons.shopping_cart),
                      iconSize: 40,
                      tooltip: 'Pedidos Disponibles',
                      onPressed: () {
                        goToBuscarPedidos(context);
                      },
                    ),
                    title: Text('Pedidos Disponibles'),
                    subtitle: Text(
                        'Aquí puedes ver los pedidos disponibles a tu alrededor.'),
                    /*trailing: Icon(Icons.more_vert),
                    // isThreeLine: true,*/
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: screenHeight / 100),
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Card(
                  child: ListTile(
                    leading: IconButton(
                      icon: Icon(Icons.access_time),
                      iconSize: 40,
                      tooltip: 'Historial de Entregas',
                      onPressed: () {
                        goToHistorialCompras(context, _user.email);
                      },
                    ),
                    title: Text('Historial de Entregas'),
                    subtitle: Text(
                        'Aquí puedes ver todas las entregas que has realizado.'),
                    /*trailing: Icon(Icons.more_vert),
                    // isThreeLine: true,*/
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: screenHeight / 100),
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Card(
                  child: ListTile(
                    leading: IconButton(
                      icon: Icon(Icons.map),
                      iconSize: 40,
                      tooltip: 'Entregar Pedido',
                      onPressed: () {
                        goToSeguimiento(context);
                      },
                    ),
                    title: Text('Entregar Pedido'),
                    subtitle: Text(
                        'Aquí puedes ver las entregas aceptadas y su orden de entrega.'),
                    /*trailing: Icon(Icons.more_vert),
                    // isThreeLine: true,*/
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void goToBuscarPedidos(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => BuscarPedidosScreen()));
}

void goToSeguimiento(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => EntregarPedidos()));
}

void goToHistorialCompras(BuildContext context, String id) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => EntregasPedido(id: id)));
}
