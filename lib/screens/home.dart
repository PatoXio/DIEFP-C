import 'package:diefpc/screens/Menu.dart';
import 'package:diefpc/states/login_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:diefpc/app/app.dart';
import 'dart:core';
import 'package:provider/provider.dart';

import 'createScreen.dart';



class HomeScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  double screenHeight;
  String name;
  String elTiempo;

  @override
  Widget build(BuildContext context) {
    var _user = Provider.of<LoginState>(context).currentUser();
    var isComplete = Provider.of<LoginState>(context).isComplete();
    screenHeight = MediaQuery
        .of( context )
        .size
        .height;
    name = _user.displayName;
    elTiempo = _elTiempo();
    return Scaffold(
      //drawer: Text( 'Hola perro ql bastardo y la ctm uwu' ),
      appBar: AppBar(
        title: Text( '¡Bienvenido!' ),
        actions: <Widget>[
          IconButton( icon: Icon( Icons.list ),
              tooltip: 'Configuración',
              onPressed: () {
                configMenu( context );
              }
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 5,
          ),
          Container(
              margin: EdgeInsets.only( top: screenHeight / 100 ),
              padding: EdgeInsets.only( left: 10, right: 10 ),
              child:Card(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.account_box, size: 45,),
                          title: Text("Hola, ${name.split(" ")[0]}.",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text("$elTiempo",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold
                              )
                          ),
                        )
                      ]
                  )
              )
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if(isComplete == false){
              Navigator.push(
                  context,
                  MaterialPageRoute( builder: (context) => CreateScreen()));
            }else goToMenu(context);
          },
          label: Text( "Menú",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold
          ),)
      ),
    );
  }
    void goToMenu(BuildContext context) {
      Navigator.push(
          context,
          MaterialPageRoute( builder: (context) => MenuScreen( ) ) );
    }

    String _elTiempo(){
    DateTime now = DateTime.now();

    if(now.hour >= 6 && now.hour <=12){
      return "Buenos Dias";
    }else{
      if(now.hour >= 12 && now.hour <=19){
        return "Buenas Tardes";
      }else{
        if(now.hour >= 19 && now.hour <= 24){
          return "Buenas Noches";
        }else{
          if(now.hour < 6){
            return "!AL QUE MADRUGA DIOS LO AYUDA! \tRecuerda dormir temprano";
          }
        }
      }
    }
  }
}