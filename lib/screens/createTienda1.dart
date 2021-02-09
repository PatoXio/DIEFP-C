import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diefpc/Clases/Tienda.dart';
import 'package:diefpc/app/app.dart';
import 'package:diefpc/screens/home.dart';
import 'package:diefpc/states/login_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dart_rut_validator/dart_rut_validator.dart' show RUTValidator;
import 'package:mailer/smtp_server.dart';
import 'package:provider/provider.dart';
import 'package:mailer/mailer.dart';

TextEditingController _rutController = TextEditingController();

void onChangedApplyFormat(String text) {
  RUTValidator.formatFromTextController(_rutController);
}

class CreateTienda1 extends StatefulWidget {
  CreateTienda1(String email);

  @override
  _CreateTienda1State createState() => _CreateTienda1State();
}

class _CreateTienda1State extends State<CreateTienda1> {
  double screenHeight;
  Tienda modelTienda = new Tienda();
  int codigoVerificacion;
  final _formKey = GlobalKey<FormState>();
  // Set intial mode to login
  @override
  void initState() {
    super.initState();
    codigoVerificacion = random();
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
                  child: _columnTienda(context),
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

  Widget _columnTienda(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Complementar Datos importantes",
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
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Ingrese al link para enviar los documentos necesarios",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Align(
          alignment: Alignment.topLeft,
          child: RaisedButton(
            onPressed: () {
              //sendEmail(codigoVerificacion, _user.email);
              _showAlert();
            },
            child: Text(
                "Debido a que deben probarlo por los casos de prueba, al presionar se les enviara un correo sin necesidad de entrar a la página y validar sus documentos"),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Ingrese el código de verificación que le llegara a su correo",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        TextFormField(
          maxLength: 50,
          decoration: InputDecoration(
            labelText: "Código",
          ),
          onChanged: (String value) {
            modelTienda.setCodigoDeVerificacion(value);
          },
          validator: (value) {
            if (value != (codigoVerificacion.toString())) {
              return 'Por favor ingrese su Código de\nverificación correctamente';
            }
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
              child: Text("Completar\n\tRegistro"),
              color: Colors.blue,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              onPressed: () {
                /*if (_formKey.currentState.validate()) {
                  _createTienda(_user, modelTienda.getCodigoDeVerificacion(),
                      '11111111-2');
                  _showDialog();
                }*/
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
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => MyApp()));
              },
            ),
          ],
        );
      },
    );
  }

  void _createTienda(FirebaseUser _user, String codigo, String rut) {
    Firestore.instance
        .collection('usuarios')
        .document(_user.uid)
        .updateData({"codigoVerificacion": codigo, "Rut": rut});
  }

  void goToHomeScreen(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  int random() {
    var rng = new Random();
    return rng.nextInt(100000000);
  }

  Future<void> sendEmail(int codigoVerificacion, String correo) async {
    String username = "diefpacientescronicos@gmail.com";
    String password = "";
    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'Aplicación DIEFP-C')
      ..recipients.add('$correo')
      //..ccRecipients.addAll( ['destCc1@example.com', 'destCc2@example.com'] )
      //..bccRecipients.add( Address( 'bccAddress@example.com' ) )
      ..subject = 'Hola, Te enviamos tu codigo de verificación'
      //..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html =
          "<h1>Código de Verificación</h1>\n<p>Tu código es: $codigoVerificacion</p>";
    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  void _showAlert() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Email enviado"),
          content:
              new Text("Se ha enviado el código de verificación a su correo."),
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
}
