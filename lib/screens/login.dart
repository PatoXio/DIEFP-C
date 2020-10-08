import 'package:diefpc/Clases/Usuario.dart';
import 'package:diefpc/screens/createScreen.dart';
import 'package:diefpc/states/login_state.dart';
import 'package:flutter/material.dart';
import 'package:dart_rut_validator/dart_rut_validator.dart' show RUTValidator;
import 'package:provider/provider.dart';

TextEditingController _rutController = TextEditingController();

void onChangedApplyFormat(String text) {
  RUTValidator.formatFromTextController(_rutController);
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double screenHeight;
  String contrasenia;
  String correo;
  final _formKey = GlobalKey<FormState>();
  var _user;
  // Set intial mode to login
  @override
  initState() {
    super.initState();
    _rutController.clear();
  }

  @override
  Widget build(BuildContext context) {
    _user = Provider.of<LoginState>(context).currentUser();
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            loginCard(context),
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

  Widget loginCard(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(children: <Widget>[
        _colum(context),
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
      ]),
    );
  }

  Widget _colum(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: screenHeight / 4),
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
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
                      builder: (BuildContext context, LoginState value,
                          Widget child) {
                        if (value.isLoading()) {
                          return CircularProgressIndicator();
                        } else
                          return child;
                      },
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Por favor ingrese un correo valido';
                              }
                            },
                            decoration: InputDecoration(
                              labelText: "Correo",
                            ),
                            onChanged: (String value) {
                              correo = value;
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            obscureText: true,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Por favor ingrese una contraseña valida';
                              }
                            },
                            decoration: InputDecoration(
                              labelText: "Contraseña",
                            ),
                            onChanged: (String value) {
                              contrasenia = value;
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          ButtonBar(
                            children: <Widget>[
                              FlatButton(
                                child: Text('Registrarse'),
                                color: Colors.blue,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CreateScreen()));
                                },
                              ),
                              SizedBox(
                                width: 80,
                              ),
                              FlatButton(
                                child: Text('Ingresar'),
                                color: Colors.blue,
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {}
                                },
                              ),
                            ],
                          ),
                        ],
                      )),
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
}
