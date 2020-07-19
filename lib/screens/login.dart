import 'package:diefpc/states/login_state.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dart_rut_validator/dart_rut_validator.dart' show RUTValidator;
import 'package:provider/provider.dart';
import 'package:diefpc/models/usuario.dart';

TextEditingController _rutController = TextEditingController();

void onChangedApplyFormat(String text){
  RUTValidator.formatFromTextController(_rutController);
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double screenHeight;
  User model;
  var _user;
  // Set intial mode to login
  @override
  initState() {
    super.initState( );
    _rutController.clear( );
  }

  @override
  Widget build(BuildContext context) {
    _user = Provider.of<LoginState>(context).currentUser();
    screenHeight = MediaQuery
        .of( context )
        .size
        .height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            _user == null
                ? loginCard(context)
                : loginCard(context),
            pageTitle(),
          ],
        ),
      ),
    );
  }

  Widget pageTitle() {
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

  Widget loginCard(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only( top: screenHeight / 4 ),
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
                      "Login",
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
                  SizedBox(
                    height: 20,
                  ),
                  Consumer<LoginState>(
                    builder: (BuildContext context, LoginState value, Widget child){
                      if(value.isLoading()){
                        return CircularProgressIndicator();
                      }else return child;
                    },
                    child: FlatButton(
                      child: Text( "Entrar con una cuenta google" ),
                      color: Colors.blue,
                      textColor: Colors.white,
                      padding: EdgeInsets.only(
                          left: 38, right: 38, top: 15, bottom: 15 ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular( 5 ) ),
                      onPressed: () {
                        Provider.of<LoginState>(context).login();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
  Widget singUpCard(BuildContext context) {
    bool issSwitched = false;
    model.delivery = issSwitched;
    return Column(
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
                      "Crear Cuenta",
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
                    decoration: InputDecoration(
                      labelText: "Correo",
                    ),
                    onChanged: (String value) {
                      //  onSaved: (String value) {
                      model.correo = value;
                    },
                    //},
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Contraseña",
                    ),
                    onChanged: (String value) {
                      //onSaved: (String value){
                      model.contrasena = value;
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Debe tener al menos 5 caracteres",
                    style: TextStyle( color: Colors.blue ),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Nombre Completo",
                    ),
                    onChanged: (String value) {
                      //onSaved: (String value){
                      model.nombreCompleto = value;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _rutController,
                    validator: RUTValidator(
                        validationErrorText: "Ingrese un rut válido por favor" )
                        .validator,
                    decoration: InputDecoration(
                      labelText: "Rut",
                    ),
                    onChanged: (String value) {
                      RUTValidator.formatFromTextController( _rutController );
                      model.rut = value;
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SwitchListTile(
                    title: Text( '¿Usted es Delivery?' ),
                    value: issSwitched,
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                    secondary: const Icon( Icons.directions_bike ),
                    onChanged: (value) {
                      setState( () {
                        issSwitched = value;
                        model.delivery = value;
                      } );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: Container( ),
                      ),
                      FlatButton(
                        child: Text( "Registrarse" ),
                        color: Colors.blue,
                        textColor: Colors.white,
                        padding: EdgeInsets.only(
                            left: 38, right: 38, top: 15, bottom: 15 ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular( 5 ) ),
                        onPressed: () {
                          model.rut = RUTValidator.formatFromText(model.rut);
                          //if (_crearUsuario( ) == true) {
                           // _showConfirmado( );
                          //} else {
                         //   _showDesconfirmado();
                          //}
                        },
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
    );
  }
}
