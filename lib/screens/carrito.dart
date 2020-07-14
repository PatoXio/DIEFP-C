//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diefpc/states/login_state.dart';
import 'package:flutter/material.dart';
import 'package:diefpc/app/app.dart';
import 'package:provider/provider.dart';

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
class CarritoCompras extends StatefulWidget{
  @override
  _CarritoComprasState createState() => _CarritoComprasState();
}

class _CarritoComprasState extends State<CarritoCompras>{
  final _saved = Set<String>();
  double screenlong;
  double screenHeight;
  final _select = Set<String>();

  @override
  Widget build(BuildContext context) {
    screenlong = MediaQuery.of(context).size.longestSide;
    screenlong = MediaQuery.of(context).size.height;
    Provider.of<LoginState>(context).actualizarCarrito();
    final ScrollController _scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        title: Text("Carrito de Pedidos"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list),
              tooltip: 'Configuración',
              onPressed: (){
                configMenu(context);
              }
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(top: screenHeight / 100),
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Column(
              children: <Widget> [
                Row(
                  children: <Widget> [
                    Divider(
                      indent: screenlong / 65,
                    ),
                    Card(
                      color: Colors.blue,
                        child:
                        Text(" Productos ",
                            style: _styleText(),
                        )),
                    Divider(
                      indent: screenlong / 4.6,
                    ),
                    Card(
                        color: Colors.blue,
                        child:
                        Text(" Seleccionar ",
                            style: _styleText())),
                  ],
                ),
                  Container(
                    height: screenHeight / 1.3,
                    child: Card(
                      elevation: 5,
                      margin: EdgeInsets.all(10),
                      semanticContainer: true,
                      color: Colors.transparent,
                      child: Theme(
                        data: ThemeData(
                        highlightColor: Colors.blue, //Does not work
                        ),
                        child: Scrollbar(
                            child:
                            _queyList(context)
                        ),
                      ),
                    ),
                  ),
                Row(
                    children: <Widget> [
                      FloatingActionButton.extended(
                        onPressed: () {
                          //borrarDelCarrito();
                          },
                        label: Text("Eliminar", style: TextStyle(fontSize: 20)),
                        backgroundColor: Colors.red,
                      ),
                      Divider(
                        indent: screenlong / 7,
                      ),
                      FloatingActionButton.extended(
                        onPressed: () {
                        },
                        label: Text("Comprar", style: TextStyle(fontSize: 20)),
                        backgroundColor: Colors.blue,
                      ),
                    ]
                ),
              ],
            ),
          ),
    );
  }

  IconButton _iconTravel(String id) {
    final alreadySaved = _saved.contains(id);
    if(alreadySaved)
      return IconButton(
        icon: Icon(Icons.indeterminate_check_box),
        color: Colors.red,
        iconSize: 20,
        tooltip: 'Deleter', onPressed: (){
          _saved.remove(id);
      });
    else
      return IconButton(
        icon: Icon(Icons.check_box_outline_blank),
          iconSize: 20,
        tooltip: 'Checker', onPressed: (){
          _saved.add(id);
      });
  }

  TextStyle _styleText(){
    return TextStyle(fontSize: 15,fontWeight: FontWeight.bold, color: Colors.white);
  }

  Widget _queyList(BuildContext context) {
    bool selected = false;
    var listDocuments = Provider.of<LoginState>(context).getCarrito();
    if (listDocuments != null) {
      return ListView.builder(
          itemCount: listDocuments.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) => buildBody(context, index)
      );
    } else{
      return Text("No posees productos en tu carrito");
    }
  }
  Widget buildBody(BuildContext context, int index) {
    var listDocuments = Provider.of<LoginState>(context).getCarrito();
    return Card(
        child:
        ListTile(
          leading: IconButton(
            icon: Icon(Icons.local_hospital),
            iconSize: 40,
            tooltip: 'Productos', onPressed: () {
          },
          ),
          title: Text(listDocuments[index].data["Nombre"]),
          subtitle: TextProducto(context, listDocuments[index].data.keys.toList(), listDocuments[index].data.values.toList()),
          trailing: _iconTravel(listDocuments[index].documentID),
          isThreeLine: true,
        ),
    );
  }
  // ignore: non_constant_identifier_names
  Widget TextProducto(BuildContext context, List listaKeys, List listaValues){
    int i = 0;
    String info;
    if (listaKeys!=null){
      while(i<listaKeys.length){
        if(i==1){
          info = "${listaKeys[i].toString()}: ${listaValues[i].toString()}";
        }
        if(i>1){
          info = info + "\n${listaKeys[i].toString()}: ${listaValues[i].toString()}";
        }
        i=i+1;
      }
    }else
      info = "Este producto no posee datos";
    return Text("$info");
  }
}