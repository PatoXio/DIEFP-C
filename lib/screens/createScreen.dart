import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:diefpc/app/app.dart';
import 'package:diefpc/screens/Menu.dart';
import 'package:diefpc/screens/home.dart';
import 'package:diefpc/states/login_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dart_rut_validator/dart_rut_validator.dart' show RUTValidator;
import 'package:provider/provider.dart';
import 'package:diefpc/models/usuario.dart';

//import 'login.dart';

TextEditingController _rutController = TextEditingController();

void onChangedApplyFormat(String text){
  RUTValidator.formatFromTextController(_rutController);
}

class CreateScreen extends StatefulWidget {
  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  double screenHeight;
  User model = new User();
  bool isSwitchDelivery = false;
  bool isSwitchTienda = false;
  final _formKey = GlobalKey<FormState>();
  FirebaseUser _user;
  // Set intial mode to login
  @override
  void initState() {
    super.initState( );
    _rutController.clear( );
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
                  child: Consumer<LoginState>(
                    // ignore: missing_return
                    builder: (BuildContext context, LoginState value, child){
                      if(value.isLoading())
                        return CircularProgressIndicator();
                      else
                        if(isComplete == false)
                          return child;
                        else
                          goToMenu(context);
                    },
                    child: Column(
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
                            onChangedApplyFormat(value);
                            model.rut = value;
                            },
                          validator: RUTValidator(validationErrorText: 'Ingrese un RUT válido').validator,
                        ),
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
                                  model.rut = RUTValidator.formatFromText(model.rut);
                                  if(_user.email.compareTo("patricio.igtr@gmail.com")==0)
                                    _createAdmin(_user, model.rut, isSwitchDelivery, isSwitchTienda);
                                  else
                                    if(isSwitchDelivery == false && isSwitchTienda == false){
                                      _createUser(_user, model.rut, isSwitchDelivery, isSwitchTienda);
                                    }
                                  Provider.of<LoginState>(context).isComplete();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>HomeScreen()));
                                }
                              },
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
    );
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
  void goToMenu(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute( builder: (context) => MenuScreen( ) ) );
  }
}
