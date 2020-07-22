import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diefpc/states/login_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:diefpc/app/app.dart';
import 'package:provider/provider.dart';
import 'ComprarCarrito.dart';

class CarritoCompras extends StatefulWidget{
  @override
  _CarritoComprasState createState() => _CarritoComprasState();
}

class _CarritoComprasState extends State<CarritoCompras>{
  final _saved = Set<String>();
  FirebaseUser _user;
  List<DocumentSnapshot> listDocuments;
  double screenlong;
  double screenHeight;
  @override
  Widget build(BuildContext context) {
    screenlong = MediaQuery.of(context).size.longestSide;
    screenHeight = MediaQuery.of(context).size.height;
    Provider.of<LoginState>(context).actualizarCarrito();
    listDocuments = Provider.of<LoginState>(context).getCarrito();
    _user = Provider.of<LoginState>(context).currentUser();
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
                //elevation: 5,
                margin: EdgeInsets.all(10),
                semanticContainer: true,
                //color: Colors.transparent,
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
                    heroTag: "boton1",
                    onPressed: () {
                      borrarDelCarrito(_saved, _user);
                    },
                    label: Text("Eliminar", style: TextStyle(fontSize: 20)),
                    backgroundColor: Colors.red,
                  ),
                  Divider(
                    indent: screenlong / 7,
                  ),
                  FloatingActionButton.extended(
                    heroTag: "boton2",
                    onPressed: () {
                      if(listDocuments.length>0) {
                        goToComprarCarrito( context );
                      }else
                        return _showAlert("Deben haber productos para comprar.");
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
      if (alreadySaved) {
        return IconButton(
            icon: Icon( Icons.indeterminate_check_box ),
            color: Colors.red,
            iconSize: 20,
            tooltip: 'Deleter',
            onPressed: () {
              _saved.remove( id );
            } );
      } else {
        return IconButton(
            icon: Icon( Icons.check_box_outline_blank ),
            iconSize: 20,
            tooltip: 'Checker', onPressed: () {
          _saved.add( id );
        } );
      }
  }

  TextStyle _styleText(){
    return TextStyle(fontSize: 15,fontWeight: FontWeight.bold, color: Colors.white);
  }


  Widget _queyList(BuildContext context) {
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
    revisarCarrrito(listDocuments,_user.uid);
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
    String info = '';
    if (listaKeys!=null){
      while(i<listaKeys.length){
        if (listaKeys[i].toString( ).compareTo( "Tienda" ) != 0) {
          if (i == 1) {
            info = "${listaKeys[i].toString( )}: ${listaValues[i].toString( )}\n";
          }
          if (i > 1) {
            info = info +"${listaKeys[i].toString( )}: ${listaValues[i].toString( )}\n";
          }
        }
        i=i+1;
      }
    }else
      info = "Este producto no posee datos";
    return Text("$info");
  }

  void borrarDelCarrito(Set<String> _saved, FirebaseUser _user){
    int largo = _saved.length;
    int i;
    print(largo);
    if(largo != 0) {
      try {
        for (i = 0; i < largo; i++) {
          Firestore.instance
              .collection( 'usuarios' )
              .document( _user.uid )
              .collection( 'Carrito' )
              .document( _saved.elementAt( i ) )
              .delete( );
        }
        _saved.clear( );
      } catch (error) {
        return _showAlert( 'Ocurrió un error al borrar los productos.' );
      }
      return _showAlert( "Se borraron los productos." );
    }else
      return _showAlert("Debes seleccionar un producto para eliminarlo.");
  }
  void _showAlert(String notify) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Aviso"),
          content: new Text(notify),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
  void goToComprarCarrito(BuildContext context){
    Navigator.push(
        context,
        MaterialPageRoute( builder: (context) => ComprarCarrito()));
  }

  void revisarCarrrito(List<DocumentSnapshot> listDocuments, String uid) {
    int length;
    int i;
    if(listDocuments.length > 0){
      length = listDocuments.length;
      for(i=0;i<length;i++){
        if(listDocuments.elementAt(i).data["Cantidad"] == null){
          Firestore.instance
              .collection('usuarios')
              .document(uid)
              .collection('Carrito')
              .document(listDocuments.elementAt(i).documentID)
              .updateData({"Cantidad": '1'});
        }
      }
    }
  }
}