
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diefpc/app/app.dart';
import 'package:diefpc/models/producto.dart';
//import 'package:diefpc/app/app.dart';
import 'package:diefpc/screens/Menu.dart';
import 'package:diefpc/screens/home.dart';
import 'package:diefpc/screens/productosTienda.dart';
import 'package:diefpc/states/login_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dart_rut_validator/dart_rut_validator.dart' show RUTValidator;
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:diefpc/models/usuario.dart';
import 'package:diefpc/models/delivery.dart';
import 'package:diefpc/models/tienda.dart';
import '../main.dart';
import 'createDelivery1.dart';
import 'createTienda1.dart';


//import 'login.dart';

class CrearProducto extends StatefulWidget {
  @override
  _CrearProductoState createState() => _CrearProductoState();
}

class _CrearProductoState extends State<CrearProducto> {
  double screenHeight;
  Producto modelProducto = new Producto();
  final _formKey = GlobalKey<FormState>();
  FirebaseUser _user;
  // Set intial mode to login
  @override
  void initState() {
    super.initState( );
  }
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery
        .of( context )
        .size
        .height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            singUpCard(context),
            pageTitle(),
          ],
        ),
      ),
    );
  }

  Widget pageTitle(){
    return Container(
      margin: EdgeInsets.only( top: 50 ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.local_hospital,
            size: 48,
            color: Colors.red,
          ),
          Text(
            "DIEFP-C",
            style: TextStyle(
                fontSize: 34, color: Colors.blue, fontWeight: FontWeight.w400 ),
          )
        ],
      ),
    );
  }

  Widget singUpCard(BuildContext context) {
    _user = Provider.of<LoginState>(context).currentUser();
    //var isComplete = Provider.of<LoginState>(context).isComplete();
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only( top: screenHeight / 5 ),
              padding: EdgeInsets.only( left: 10, right: 10 ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular( 10 ),
                ),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all( 30.0 ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Agregar Producto",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          maxLength: 50,
                          validator: (value){
                            if(value.isEmpty){
                              return 'Por favor ingrese el nombre del producto';
                            }
                          },
                          decoration: InputDecoration(
                            labelText: "Nombre",
                          ),
                          onChanged: (String value){
                            modelProducto.nombre = value;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          maxLength: 50,
                          validator: (value){
                            if(value.isEmpty){
                              return 'Por favor ingrese el codigo';
                            }
                          },
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly],
                          decoration: InputDecoration(
                            labelText: "Codigo",
                          ),
                          onChanged: (String value){
                            modelProducto.codigo = value;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          maxLength: 9,
                          validator: (value){
                            if(value.isEmpty){
                              return 'Por favor ingrese el peso del producto';
                            }
                          },
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly],
                          decoration: InputDecoration(
                            labelText: "Peso en mg/u",
                          ),
                          onChanged: (String value){
                            modelProducto.peso = value;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          maxLength: 30,
                          validator: (value){
                            if(value.isEmpty){
                              return 'Por favor ingrese la cantidad de stock';
                            }
                          },
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly],
                          decoration: InputDecoration(
                            labelText: "Ingrese el stock",
                          ),
                          onChanged: (String value){
                            modelProducto.cantidad = value;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              child: Container( ),
                            ),
                            FlatButton(
                                child: Text( "Atrás" ),
                                color: Colors.blue,
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular( 15 ) ),
                                onPressed: () {
                                  Navigator.pop(context);
                                }
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            FlatButton(
                              child: Text( "Guardar" ),
                              color: Colors.blue,
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular( 15 ) ),
                              onPressed: () {
                                if(_formKey.currentState.validate()) {
                                    _createProducto(_user,modelProducto.cantidad,modelProducto.nombre,modelProducto.codigo, modelProducto.peso);
                                  }
                                  /*Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProductosTienda()));
                                Navigator.popAndPushNamed(
                                    context,'');*/
                                Navigator.pop(context);
                                }
                            ),
                          ],
                        ),
                      ],
                    ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: FlatButton(
                child: Text(
                  "Terminos y Condiciones",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                onPressed: () {},
              ),
            ),
          ],
        )
    );
  }

  void _createProducto(FirebaseUser _user, String cantidad, String nombre, String codigo, String peso){
    Firestore.instance
        .collection('usuarios')
        .document(_user.uid)
        .collection('Productos').document(codigo).setData({
      "Cantidad": cantidad,
      "Codigo": codigo,
      "Mg/u": peso,
      "Nombre": nombre,
    });
  }
  void goToHomeScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute( builder: (context) => HomeScreen( ) ) );
  }

  void goToRestart(BuildContext context){
    Provider.of<LoginState>(context).isComplete();
    Provider.of<LoginState>(context).logout();
    Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) =>MyApp()));
  }
}
