import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diefpc/Clases/Delivery.dart';
//import 'package:diefpc/app/app.dart';
import 'package:diefpc/screens/home.dart';
import 'package:diefpc/states/login_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dart_rut_validator/dart_rut_validator.dart' show RUTValidator;
import 'package:provider/provider.dart';
import 'createDelivery2.dart';

//import 'login.dart';

TextEditingController _rutController = TextEditingController();

void onChangedApplyFormat(String text) {
  RUTValidator.formatFromTextController(_rutController);
}

class CreateDelivery1 extends StatefulWidget {
  @override
  _CreateDelivery1State createState() => _CreateDelivery1State();
}

class _CreateDelivery1State extends State<CreateDelivery1> {
  double screenHeight;
  Delivery modelDelivery = new Delivery();
  bool moto = false;
  bool automovil = false;
  bool bicicleta = false;
  final _formKey = GlobalKey<FormState>();
  FirebaseUser _user;
  // Set intial mode to login
  @override
  void initState() {
    super.initState();
    _rutController.clear();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
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

  Widget pageTitle() {
    return Container(
      margin: EdgeInsets.only(top: 50),
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
                fontSize: 34, color: Colors.blue, fontWeight: FontWeight.w400),
          )
        ],
      ),
    );
  }

  Widget singUpCard(BuildContext context) {
    _user = Provider.of<LoginState>(context).currentUser();
    // ignore: unused_local_variable
    var isComplete = Provider.of<LoginState>(context).isComplete();
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: screenHeight / 5),
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: _columnDelivery(context),
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
        ));
  }

  Widget _columnDelivery(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            "¿Qué transporte utiliza?",
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
        CheckboxListTile(
          title: Text('Motocicleta'),
          value: moto,
          activeColor: Colors.green,
          secondary: const Icon(Icons.motorcycle),
          onChanged: (bool newValue) {
            setState(() {
              moto = true;
              automovil = false;
              bicicleta = false;
              modelDelivery.setMedioDeTransporte("Motocicleta");
            });
          },
        ),
        SizedBox(
          height: 15,
        ),
        CheckboxListTile(
          title: Text('Automovil'),
          value: automovil,
          //activeTrackColor: Colors.lightGreenAccent,
          activeColor: Colors.green,
          secondary: const Icon(Icons.directions_car),
          onChanged: (bool newValue) {
            setState(() {
              automovil = true;
              moto = false;
              bicicleta = false;
              modelDelivery.setMedioDeTransporte("Automovil");
            });
          },
        ),
        SizedBox(
          height: 15,
        ),
        CheckboxListTile(
          title: Text('Bicicleta'),
          value: bicicleta,
          //activeTrackColor: Colors.lightGreenAccent,
          activeColor: Colors.green,
          secondary: const Icon(Icons.directions_bike),
          onChanged: (bool newValue) {
            setState(() {
              bicicleta = true;
              moto = false;
              automovil = false;
              modelDelivery.setMedioDeTransporte("Bicicleta");
            });
          },
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: Container(),
            ),
            FlatButton(
                child: Text("Atrás"),
                color: Colors.blue,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                onPressed: () {
                  Navigator.pop(context);
                }),
            SizedBox(
              width: 20,
            ),
            FlatButton(
              child: Text("Siguiente"),
              color: Colors.blue,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              onPressed: () {
                if (automovil == true || moto == true || bicicleta == true) {
                  _createDelivery(_user, modelDelivery.getMedioDeTransporte());
                  //Provider.of<LoginState>(context).isComplete();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateDelivery2()));
                } else
                  _showDialog();
              },
            ),
          ],
        ),
      ],
    );
  }

  void _createDelivery(FirebaseUser _user, String transporte) {
    Firestore.instance
        .collection('usuarios')
        .document(_user.uid)
        .updateData({"transporte": transporte});
  }

  void goToHomeScreen(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("No has seleccionado ninguna opción :/"),
          content: new Text(
              "Debes seleccionar un medio de transporte para poder realizar las entregas de los productos a tiempo."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
