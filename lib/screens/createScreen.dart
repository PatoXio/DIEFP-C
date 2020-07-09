
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diefpc/app/app.dart';
//import 'package:diefpc/app/app.dart';
import 'package:diefpc/screens/Menu.dart';
import 'package:diefpc/screens/home.dart';
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

TextEditingController _rutController = TextEditingController();

class CreateScreen extends StatefulWidget {
  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  double screenHeight;
  User model = new User();
  Delivery modelDelivery = new Delivery();
  Tienda modelTienda = new Tienda();
  bool isSwitchDelivery = false;
  bool isSwitchTienda = false;
  bool checkBoxValue = true;
  final _formKey = GlobalKey<FormState>();
  FirebaseUser _user;
  // Set intial mode to login
  @override
  void initState() {
    _rutController.clear();
    super.initState( );
  }
  @override
  Widget build(BuildContext context) {
    Provider.of<LoginState>(context).isComplete();
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
    var isComplete = Provider.of<LoginState>(context).isComplete();
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
                    child: _column(context, isComplete),
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

  Widget _column(BuildContext context, bool isComplete){
    if(isComplete == false) {
      if (checkBoxValue == true)
        return _columnUser( context );
      if (isSwitchDelivery == true)
        return _columnDelivery( context );
      if (isSwitchTienda == true)
        return _columnTienda( context );
    }else
      goBack(context);
  }

  Widget _columnDelivery(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Completar datos importantes",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      /*  SizedBox(
          height: 15,
        ),
     TextFormField(
          maxLength: 12,
          decoration: InputDecoration(
            labelText: "Rut",
          ),
          controller: _rutController,
          onChanged: (String value){
            modelDelivery.rut = value;
          },
          validator: RUTValidator(validationErrorText: 'Ingrese un RUT válido').validator,
        ),*/
        SizedBox(
          height: 15,
        ),
        TextFormField(
          maxLength: 50,
          validator: (value){
            if(value.isEmpty){
              return 'Por favor ingrese su nombre completo';
            }
          },
          decoration: InputDecoration(
            labelText: "Nombre Completo",
          ),
          onChanged: (String value){
            modelDelivery.nombreCompleto = value;
          },
        ),
        SizedBox(
          height: 15,
        ),
        TextFormField(
          maxLength: 9,
          validator: (value){
            if(value.isEmpty){
              return 'Por favor ingrese su número de celular';
            }
          },
          decoration: InputDecoration(
            labelText: "Número Celular sin el '+56'",
          ),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            WhitelistingTextInputFormatter.digitsOnly],
          onChanged: (String value){
            modelDelivery.numero = value;
          },
        ),
        SizedBox(
          height: 15,
        ),
        TextFormField(
          maxLength: 30,
          validator: (value){
            if(value.isEmpty){
              return 'Por favor ingrese su ciudad';
            }
          },
          decoration: InputDecoration(
            labelText: "Ingrese su ciudad",
          ),
          onChanged: (String value){
            modelDelivery.ciudad = value;
          },
        ),
        SizedBox(
          height: 15,
        ),
        TextFormField(
          maxLength: 15,
          decoration: InputDecoration(
            labelText: "Código de invitación (Opcional",
          ),
          onChanged: (String value){
            modelDelivery.codigoInvitacion = value;
          },
        ),
        CheckboxListTile(
          title: Text('¿Usted es un Usuario Común?'),
          value: checkBoxValue,
          activeColor: Colors.green,
          secondary: const Icon( Icons.supervised_user_circle ),
          onChanged: (bool newValue){
            setState(() {
              checkBoxValue = true;
              isSwitchDelivery = false;
              isSwitchTienda = false;
            });
          },
        )
        ,
        SizedBox(
          height: 15,
        ),
        SwitchListTile(
          title: Text( '¿Usted es Delivery?' ),
          value: isSwitchDelivery,
          activeTrackColor: Colors.lightGreenAccent,
          activeColor: Colors.green,
          secondary: const Icon( Icons.directions_bike ),
          onChanged: (bool newValue) {
            setState((){
              isSwitchDelivery = newValue;
              isSwitchTienda = false;
              checkBoxValue = false;
              if(isSwitchDelivery == false) checkBoxValue = true;
            } );
          },
        ),
        SizedBox(
          height: 15,
        ),
        SwitchListTile(
          title: Text( '¿Usted es una Farmacia?' ),
          value: isSwitchTienda,
          activeTrackColor: Colors.lightGreenAccent,
          activeColor: Colors.green,
          secondary: const Icon( Icons.local_hospital ),
          onChanged: (bool newValue) {
            setState((){
              isSwitchTienda = newValue;
              isSwitchDelivery = false;
              checkBoxValue = false;
              if(isSwitchTienda == false) checkBoxValue = true;
            } );
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
              child: Text( "Siguiente" ),
              color: Colors.blue,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular( 15 ) ),
              onPressed: () {
                RUTValidator.formatFromTextController(_rutController);
                //modelDelivery.rut = _rutController.value.text;
                if(_formKey.currentState.validate()) {
                  if (isSwitchDelivery == true) {
                    _createDelivery(
                        _user,
                        isSwitchDelivery,
                        isSwitchTienda,
                        //modelDelivery.rut,
                        modelDelivery.numero,
                        modelDelivery.ciudad,
                        modelDelivery.codigoInvitacion,
                        modelDelivery.nombreCompleto );
                  }
                  //Provider.of<LoginState>(context).isComplete();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateDelivery1( ) ) );
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _columnTienda(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Completar datos importantes",
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
          maxLength: 12,
          decoration: InputDecoration(
            labelText: "Patente",
          ),
          onChanged: (String value){
            modelTienda.patente = value;
          },
          validator: (value){
            if(value.isEmpty || (value != null && value.length <5)){
              return 'Por favor ingrese una patente de 5 o + digitos';
            }
          },
        ),
        CheckboxListTile(
          title: Text('¿Usted es un Usuario Común?'),
          value: checkBoxValue,
          activeColor: Colors.green,
          secondary: const Icon( Icons.supervised_user_circle ),
          onChanged: (bool newValue){
            setState(() {
              checkBoxValue = true;
              isSwitchDelivery = false;
              isSwitchTienda = false;
            });
          },
        )
        ,
        SizedBox(
          height: 15,
        ),
        SwitchListTile(
          title: Text( '¿Usted es Delivery?' ),
          value: isSwitchDelivery,
          activeTrackColor: Colors.lightGreenAccent,
          activeColor: Colors.green,
          secondary: const Icon( Icons.directions_bike ),
          onChanged: (bool newValue) {
            setState((){
              isSwitchDelivery = newValue;
              isSwitchTienda = false;
              checkBoxValue = false;
              if(isSwitchDelivery == false) checkBoxValue = true;
            } );
          },
        ),
        SizedBox(
          height: 15,
        ),
        SwitchListTile(
          title: Text( '¿Usted es una Farmacia?' ),
          value: isSwitchTienda,
          activeTrackColor: Colors.lightGreenAccent,
          activeColor: Colors.green,
          secondary: const Icon( Icons.local_hospital ),
          onChanged: (bool newValue) {
            setState((){
              isSwitchTienda = newValue;
              isSwitchDelivery = false;
              checkBoxValue = false;
              if(isSwitchTienda == false) checkBoxValue = true;
            } );
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
              child: Text( "Siguiente" ),
              color: Colors.blue,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular( 15 ) ),
              onPressed: () {
                if(_formKey.currentState.validate()){
                  if(_user.email.compareTo("patricio.igtr@gmail.com")==0)
                    _createAdmin(_user, modelTienda.patente, isSwitchDelivery, isSwitchTienda);
                  else
                  if(isSwitchTienda == true){
                    _createTienda(_user, modelTienda.patente, isSwitchDelivery, isSwitchTienda);
                  }
                  Provider.of<LoginState>(context).isComplete();
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>CreateTienda1()));
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _columnUser(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Completar datos importantes",
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
          maxLength: 12,
          decoration: InputDecoration(
            labelText: "Rut",
          ),
          controller: _rutController,
          onChanged: (String value){
            model.rut = value;
          },
          validator: RUTValidator(validationErrorText: 'Ingrese un RUT válido').validator,
        ),
        CheckboxListTile(
          title: Text('¿Usted es un Usuario Común?'),
          value: checkBoxValue,
          activeColor: Colors.green,
          secondary: const Icon( Icons.supervised_user_circle ),
          onChanged: (bool newValue){
            setState(() {
              checkBoxValue = true;
              isSwitchDelivery = false;
              isSwitchTienda = false;
            });
          },
        )
        ,
        SizedBox(
          height: 15,
        ),
        SwitchListTile(
          title: Text( '¿Usted es Delivery?' ),
          value: isSwitchDelivery,
          activeTrackColor: Colors.lightGreenAccent,
          activeColor: Colors.green,
          secondary: const Icon( Icons.directions_bike ),
          onChanged: (bool newValue) {
            setState((){
              isSwitchDelivery = newValue;
              isSwitchTienda = false;
              checkBoxValue = false;
              if(isSwitchDelivery == false) checkBoxValue = true;
            } );
          },
        ),
        SizedBox(
          height: 15,
        ),
        SwitchListTile(
          title: Text( '¿Usted es una Farmacia?' ),
          value: isSwitchTienda,
          activeTrackColor: Colors.lightGreenAccent,
          activeColor: Colors.green,
          secondary: const Icon( Icons.local_hospital ),
          onChanged: (bool newValue) {
            setState((){
              isSwitchTienda = newValue;
              isSwitchDelivery = false;
              checkBoxValue = false;
              if(isSwitchTienda == false) checkBoxValue = true;
            } );
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
              child: Text( "Completar\n\tRegistro" ),
              color: Colors.blue,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular( 15 ) ),
              onPressed: () {
                if(_formKey.currentState.validate()){
                  RUTValidator.formatFromTextController(_rutController);
                  model.rut = _rutController.value.text;
                  if(_user.email.compareTo("patricio.igtr@gmail.com")==0)
                    _createAdmin(_user, model.rut, isSwitchDelivery, isSwitchTienda);
                  else
                  if(checkBoxValue == true){
                    _createUser(_user, model.rut, isSwitchDelivery, isSwitchTienda);
                  }
                  _showDialog();
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Cuenta registrada"),
          content: new Text("Deberás volver a iniciar sesión."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                //Provider.of<LoginState>(context).isComplete();
                //Navigator.pop(context);
                Provider.of<LoginState>(context).logout();
                Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (context) =>MyApp()));
              },
            ),
          ],
        );
      },
    );
  }

  void _createTienda(FirebaseUser _user, String patente, bool delivery, bool tienda){
    Firestore.instance
        .collection('usuarios')
        .document(_user.uid)
        .updateData({
      "nombre": _user.displayName,
      "email": _user.email,
      "Patente": patente,
      "Delivery": delivery,
      "Tienda": tienda,
      "Admin": false,
    });
  }

  void _createUser(FirebaseUser _user, String rut, bool delivery, bool tienda){
    Firestore.instance
        .collection('usuarios')
        .document(_user.uid)
        .updateData({
      "nombre": _user.displayName,
      "email": _user.email,
      "Rut": rut,
      "Delivery": delivery,
      "Tienda": tienda,
      "Admin": false,
    });
  }

  void _createDelivery(FirebaseUser _user, bool delivery, bool tienda, /*String rut,*/String numero, String ciudad, String codigo, String nombreCompleto){
    Firestore.instance
        .collection('usuarios')
        .document(_user.uid)
        .updateData({
      "nombre": _user.displayName,
      "nombreApp": nombreCompleto,
      "email": _user.email,
     // "Rut": rut,
      "numero": numero,
      "ciudad": ciudad,
      "codigo": codigo,
      "Delivery": delivery,
      "Tienda": tienda,
      "Admin": false,
    });
  }
  void _createAdmin(FirebaseUser _user, String rut, bool delivery, bool tienda){
    Firestore.instance
        .collection('usuarios')
        .document(_user.uid)
        .updateData({
      "nombre": _user.displayName,
      "email": _user.email,
      "Rut": rut,
      "Delivery": delivery,
      "Tienda": tienda,
      "Admin": true,
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

  void goBack(BuildContext context){
    Navigator.pop(context);
  }
}
