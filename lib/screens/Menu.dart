import 'package:flutter/material.dart';
import 'package:diefpc/screens/carrito.dart';
import 'package:diefpc/app/app.dart';
import 'package:diefpc/screens/buscarLocales.dart';

class MenuScreen extends StatefulWidget{
  final String id;
  MenuScreen({Key key, @required this.id}) : super(key: key);
  @override
  _MenuScreenState createState() => _MenuScreenState(id);
}

class _MenuScreenState extends State<MenuScreen> {
  _MenuScreenState(String id);
  String get id => this.id;

  @override
  Widget build(BuildContext context) {
    String rut = id;
    return Scaffold(
      appBar: AppBar(
        title: Text("Estás en el Menú"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list),
              tooltip: 'Configuración',
              onPressed: (){
                configMenu(context);
              }
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Card(
            child: ListTile(
              leading: IconButton(icon: Icon(Icons.shopping_cart),
                iconSize: 40,
                tooltip: 'Carrito',
                onPressed: (){
                  goToCarrito(context);
                },
              ),
              title: Text('Menú Carrito'),
              subtitle: Text('Aquí puedes ver todas las compras que llevas antes de pagar'),
              //trailing: Icon(Icons.more_vert),
              isThreeLine: true,
            ),
          ),
          Card(
            child: ListTile(
              leading: IconButton(icon: Icon(Icons.local_hospital),
                iconSize: 40,
                tooltip: 'Locales',
                onPressed: (){
                  goToLocales(context);
                },
              ),
              title: Text('Menú Locales'),
              subtitle: Text('Aquí puedes ver todos los locales cercanos'),
              //trailing: Icon(Icons.more_vert),
              isThreeLine: true,
            ),
          )
        ],
      ),
    );
  }
}
void goToCarrito(BuildContext context){
  Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CarritoCompras()));
}
void goToLocales(BuildContext context){
  Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LocalesScreen()));
}