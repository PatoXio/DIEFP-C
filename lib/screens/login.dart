import 'package:diefpc/app/app.dart';
import 'package:diefpc/screens/createScreen.dart';
import 'package:diefpc/screens/home.dart';
import 'package:diefpc/states/auth.dart';
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
  final AuthService _auth = AuthService();
  // Set intial mode to login
  @override
  initState() {
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
              "Terminos y Condiciones\n        Versión 1.0.0",
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
                  Consumer<AuthService>(
                      builder: (BuildContext context, AuthService value,
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
                              return null;
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
                                return 'Ingrese una contraseña valida';
                              } else if (value.length < 6) {
                                return "La contraseña debe poseer al menos 6 caracteres";
                              }
                              return null;
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
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    await Provider.of<AuthService>(context)
                                        .singInWithEmailAndPassword(
                                            correo, contrasenia);
                                    if (Provider.of<AuthService>(context)
                                            .isLoggedIn() ==
                                        false) {
                                      _showDialog();
                                    }
                                  }
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

  void goToHomeScreen(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  void goToMyApp(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Algo salió mal :C"),
          content: new Text(
              "El correo y/o la contraseña no es/son correctos.\nPor favor intente nuevamente."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                //Provider.of<LoginState>(context).isComplete();
                //Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
