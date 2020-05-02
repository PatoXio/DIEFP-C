import 'package:flutter/material.dart';
import 'package:diefpc/screens/carrito.dart';
import 'package:diefpc/app/app.dart';
import 'package:diefpc/screens/buscarLocales.dart';


/*class CarritoScreen extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => CarritoScreen( ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}*/

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
  /*Widget _buildImageColumn() => Container(
    decoration: BoxDecoration(
      color: Colors.black26,
    ),
    child: Column(
      children: [
        _buildImageRow(1),
        _buildImageRow(3),
      ],
    ),
  );
  Widget _buildImageRow(int imageIndex) => Row(
    children: [
      _buildDecoratedImage(imageIndex),
      _buildDecoratedImage(imageIndex + 1),
    ],
  );
  Widget _buildDecoratedImage(int imageIndex) => Expanded(
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(width: 10, color: Colors.black38),
        borderRadius: const BorderRadius.all(const Radius.circular(100)),
      ),
      margin: const EdgeInsets.all(20),
      child: Image.asset('images/pic$imageIndex.jpg'),
      //child: Text('Hola'),
    ),
  );*/
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