import 'package:diefpc/states/login_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CambioCorreoScreen extends StatefulWidget{
  @override
  _CambioCorreoScreenState createState() => _CambioCorreoScreenState();
}

class _CambioCorreoScreenState extends State<CambioCorreoScreen> {
  final _formKey = GlobalKey<FormState>();
  FirebaseUser user;
  double screenHeight;
  String nuevoCorr;
  String confCorr;

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
                          "Cambio de Correo",
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
                          labelText: "Nuevo Correo",
                        ),
                        onChanged: (String value){
                          nuevoCorr = value;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Confirmar Correo",
                        ),
                        onChanged: (String value){
                          confCorr = value;
                        },
                        validator: (String value){
                          if(value != nuevoCorr){
                            return "Los Correos deben ser iguales";
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
                            child: Text( "Cambiar Correo" ),
                            color: Colors.blue,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular( 15 ) ),
                            onPressed: () {
                              if(_formKey.currentState.validate()){
                                _changeCorreo(confCorr);
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
  Future<String> _changeCorreo(String correo) async{
    //Create an instance of the current user.
    user = await FirebaseAuth.instance.currentUser();

    //Pass in the password to updatePassword.
    user.updateEmail(correo).then((_){
      return "El correo se cambio con exito";
    }).catchError((error){
      return "El correo no se pudo cambiar:" + error.toString();
      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    });
  }
}