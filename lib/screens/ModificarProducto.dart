
import 'dart:io';

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

class ModificarProducto extends StatelessWidget {
  double screenHeight;
  Producto modelProducto = new Producto();
  DocumentSnapshot producto;
  final _formKey = GlobalKey<FormState>();
  FirebaseUser _user;
  // Set intial mode to login
  @override
  Widget build(BuildContext context) {
    _user = Provider.of<LoginState>(context).currentUser();
    producto = Provider.of<LoginState>(context).getProducto();
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
          ),
        ],
      ),
    );
  }

  Widget singUpCard(BuildContext context){
    return Center(
      child: Form(
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
                      child: Consumer(
                        builder: (BuildContext context, LoginState value, Widget child){
                          if(producto.data == null){
                            return CircularProgressIndicator();
                          }else return child;
                        },
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
                              initialValue: producto.data["Nombre"],
                              validator: (value){
                                if(value.isEmpty || producto.data["Nombre"].toString().compareTo(value)==0){
                                  modelProducto.nombre = producto.data["Nombre"];
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
                              enabled: false,
                              initialValue: producto.data["Codigo"],
                              validator: (value){
                                if(value.isEmpty || producto.data["Codigo"].toString().compareTo(value.toString())==0){
                                  modelProducto.codigo = producto.data["Codigo"].toString();
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
                              initialValue: producto.data["Mg/u"],
                              validator: (value){
                                if(value.isEmpty || producto.data["Mg/u"].toString().compareTo(value.toString())==0){
                                  modelProducto.peso = producto.data["Mg/u"].toString();
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
                              maxLength: 9,
                              initialValue: producto.data["Precio"],
                              validator: (value){
                                if(value.isEmpty || producto.data["Precio"].toString().compareTo(value.toString())==0){
                                  modelProducto.precio = producto.data["Precio"].toString();
                                }
                              },
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter.digitsOnly],
                              decoration: InputDecoration(
                                labelText: "Precio en pesos",
                              ),
                              onChanged: (String value){
                                modelProducto.precio = value;
                              },
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              maxLength: 30,
                              initialValue: producto.data["Stock"],
                              validator: (value){
                                if(value.isEmpty || producto.data["Stock"].toString().compareTo(value.toString())==0){
                                  modelProducto.cantidad = producto.data["Stock"].toString();
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
                                      Provider.of<LoginState>(context).borrarProducto();
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
                                        _createProducto(_user,modelProducto.cantidad,modelProducto.nombre,modelProducto.codigo, modelProducto.peso, modelProducto.precio);
                                      }
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
      ),
    );
  }

  void _createProducto(FirebaseUser _user, String cantidad, String nombre, String codigo, String peso, String precio){

    Firestore.instance
        .collection('usuarios')
        .document(_user.uid).path;
    Firestore.instance
        .collection('usuarios')
        .document(_user.uid)
        .collection('Productos')
        .document(codigo)
        .setData({
      "Stock": cantidad,
      "Codigo": codigo,
      "Mg/u": peso,
      "Nombre": nombre,
      "Precio": precio,
      "Tienda": _user.uid,
    });
  }
  void goToHomeScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute( builder: (context) => HomeScreen( ) ) );
  }
}
