/*import 'package:diefpc/app/app.dart';
import 'package:diefpc/screens/home.dart';
import 'package:diefpc/states/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String text = "Cargando Datos Del Usuario...";

  @override
  Widget build(BuildContext context) {
    var value = Provider.of<AuthService>(context);
    // ignore: missing_return
    if (value.isLoggedIn() == true) {
      if (value.isLoadingData() == false) {
        value.cargarDatosUser();
      } else {
        goToHomeScreen(context);
        //return Text("Datos Cargados");
      }
    } else {
      value.signOut();
      goToMyApp(context);
      //return Text("Error al cargar los Datos");
    }
    return Material(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 100.0,
          ),
          Flexible(
            flex: 2,
            child: SafeArea(
              child: FractionallySizedBox(
                widthFactor: 0.7,
                //child: Image.asset('assets/argelbejarano.png'),
              ),
            ),
          ),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
        ],
      ),
    );
  }

  void goToHomeScreen(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  void goToMyApp(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
  }
}
*/
