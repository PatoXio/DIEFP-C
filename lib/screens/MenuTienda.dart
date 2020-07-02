import 'package:diefpc/screens/productosTienda.dart';
import 'package:flutter/material.dart';
import 'package:diefpc/screens/carrito.dart';
import 'package:diefpc/app/app.dart';
import 'package:diefpc/screens/buscarLocales.dart';

class MenuScreenTienda extends StatefulWidget {
  @override
  _MenuScreenTiendaState createState() => _MenuScreenTiendaState();
}

class _MenuScreenTiendaState extends State<MenuScreenTienda> {
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
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: screenHeight / 100),
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Card(
              child:
              ListTile(
                leading: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  iconSize: 40,
                  tooltip: 'Pedidos',
                  onPressed: () {
                  },
                ),
                title: Text('Pedidos Pendientes'),
                subtitle: Text(
                    'Aquí puedes ver todos los pedidos pendientes'),
                /*trailing: Icon(Icons.more_vert),
                // isThreeLine: true,*/
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: screenHeight / 100),
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Card(
              child:
              ListTile(
                leading: IconButton(
                  icon: Icon(Icons.store_mall_directory),
                  iconSize: 40,
                  tooltip: 'Bodega',
                  onPressed: () {
                    goToProductos(context);
                  },
                ),
                title: Text('Bodega'),
                subtitle: Text(
                    'Aquí puedes ver todos los productos disponibles en la tienda'),
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
                    icon: Icon(Icons.history),
                    iconSize: 40,
                    tooltip: 'Locales',
                    onPressed: () {
                      goToLocales(context);
                    },
                  ),
                  title: Text('Menú Locales'),
                  subtitle: Text('Aquí puedes ver todos los locales cercanos'),
                  //trailing: Icon(Icons.more_vert),
                  isThreeLine: true,
                ),
              ))
        ],
      ),
    );
  }
}

void goToProductos(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => ProductosTienda()));
}

void goToLocales(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => LocalesScreen()));
}
