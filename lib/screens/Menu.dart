import 'package:diefpc/screens/home.dart';
import 'package:diefpc/screens/seguimientoCompra.dart';
import 'package:diefpc/states/auth.dart';
import 'package:flutter/material.dart';
import 'package:diefpc/screens/carrito.dart';
import 'package:diefpc/app/app.dart';
import 'package:diefpc/screens/buscarLocales.dart';
import 'package:provider/provider.dart';

import 'historialComprasUser.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  double screenHeight;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
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
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: screenHeight / 100),
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Card(
              child: ListTile(
                leading: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  iconSize: 40,
                  tooltip: 'Carrito',
                  onPressed: () {
                    goToCarrito(context);
                  },
                ),
                title: Text('Carrito de Compras'),
                subtitle: Text(
                    'Aquí puedes ver todas las compras que llevas antes de pagar'),
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
                  icon: Icon(Icons.local_hospital),
                  iconSize: 40,
                  tooltip: 'Locales',
                  onPressed: () {
                    Provider.of<AuthService>(context).actualizarTiendas();
                    goToLocales(context);
                  },
                ),
                title: Text('Menú Locales'),
                subtitle: Text('Aquí puedes ver todos los locales cercanos'),
                //trailing: Icon(Icons.more_vert),
                isThreeLine: true,
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
                  tooltip: 'Historial',
                  onPressed: () {
                    goToHistorialCompras(context);
                  },
                ),
                title: Text('Historial de Compras'),
                subtitle: Text(
                    'Aquí puedes ver todas las compras que llevas antes de pagar'),
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
                  tooltip: 'Seguimiento',
                  onPressed: () {
                    goToSeguimiento(context);
                  },
                ),
                title: Text('Seguimiento Compras'),
                subtitle:
                    Text('Aquí puedes ver los pedidos que vienen en camino'),
                /*trailing: Icon(Icons.more_vert),
                // isThreeLine: true,*/
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void goToSeguimiento(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => Seguimiento()));
}

void goToCarrito(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => CarritoCompras()));
}

void goToLocales(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => LocalesScreen()));
}

void goToHistorialCompras(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => HistorialCompras()));
}
