import 'package:flutter/material.dart';
import 'package:diefpc/screens/carrito.dart';

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
      ),
      body:       ListView(
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
              title: Text('Menu Carrito'),
              subtitle: Text('Aquí puedes ver todas las compras que llevas antes de pagar'),
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