import 'package:diefpc/states/login_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CambioContrasenaScreen extends StatefulWidget{
  @override
  _CambioContrasenaScreenState createState() => _CambioContrasenaScreenState();
}

class _CambioContrasenaScreenState extends State<CambioContrasenaScreen> {
  final _formKey = GlobalKey<FormState>();
  FirebaseUser user;
  double screenHeight;
  String nuevaPass;
  String confPass;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery
        .of( context )
        .size
        .height;
    user = Provider.of<LoginState>(context).currentUser();
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
                          "Cambio de Contraseña",
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
                        maxLength: 8,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Nueva Contraseña",
                        ),
                        onChanged: (String value){
                          nuevaPass = value;
                        },
                      ),
                      TextFormField(
                        maxLength: 8,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Confirmar Contraseña",
                        ),
                        onChanged: (String value){
                          confPass = value;
                        },
                        validator: (String value){
                          if(value != nuevaPass){
                            return "Las Contraseñas deben ser iguales";
                          }else return null;
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
                            child: Text( "Cambiar Contraseña" ),
                            color: Colors.blue,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular( 15 ) ),
                            onPressed: () {
                              if(_formKey.currentState.validate()){
                                _changePassword(confPass);
                              }
                            },
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          FlatButton(
                            child: Text( "Atras" ),
                            color: Colors.blue,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular( 15 ) ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }
  // ignore: missing_return
  Future<String> _changePassword(String password) async{
    //Create an instance of the current user.
    user = await FirebaseAuth.instance.currentUser();

    //Pass in the password to updatePassword.
    user.updatePassword(password).then((_){
      return "La contraseña se cambio con exito";
    }).catchError((error){
      return "La contraseña no se pudo cambiar:" + error.toString();
      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    });
  }
}