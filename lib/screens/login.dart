import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diefpc/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:dart_rut_validator/dart_rut_validator.dart' show RUTValidator;
import 'package:diefpc/models/usuario.dart' show User;

enum AuthMode { LOGIN, SINGUP }

TextEditingController _rutController = TextEditingController();

void onChangedApplyFormat(String text){
  RUTValidator.formatFromTextController(_rutController);
}

class LoginScreen extends StatefulWidget {
  //const LoginScreen({Key key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>( );
  User model = User( );
  double screenHeight;
  String rut;
  String contrasena;

  // Set intial mode to login
  @override
  initState() {
    super.initState( );
    _rutController.clear( );
  }

  AuthMode _authMode = AuthMode.LOGIN;

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
            lowerHalf( context ),
            _authMode == AuthMode.LOGIN
                ? loginCard( context )
                : singUpCard( context ),
            pageTitle( ),
          ],
        ),
      ),
    );
  }

  Widget pageTitle() {
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

  Widget loginCard(BuildContext context) {
    return Column(
      key: _formkey,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only( top: screenHeight / 4 ),
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
                      "Ingrese sus datos",
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
                    controller: _rutController,
                    decoration: InputDecoration(
                        labelText: "Rut:" ),
                    onChanged: (String value) {
                      RUTValidator.formatFromTextController( _rutController );
                      rut = value;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: "Contraseña:" ),
                    onChanged: (String value) {
                      contrasena = value;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () {},
                        child: Text( "¿Olvidaste tu\ncontraseña?",
                          style: TextStyle(
                              color: Colors.blue
                          ), ),
                      ),
                      Expanded(
                        child: Container( ),
                      ),
                      FlatButton(
                        child: Text( "Entrar" ),
                        color: Colors.blue,
                        textColor: Colors.white,
                        padding: EdgeInsets.only(
                            left: 38, right: 38, top: 15, bottom: 15 ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular( 5 ) ),
                        onPressed: () {
                          rut = RUTValidator.formatFromText(rut);
                          print(existeUsuario());
                          //if (existeUsuario() == true) {
                            //Navigator.push(
                             //   context,
                              //  MaterialPageRoute(
                               //     builder: (context) => HomeScreen( id: rut ) ) );
                          //}//else{noExisteUsuario();}
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Text(
              "¿No tiene cuenta?",
              style: TextStyle( color: Colors.grey ),
            ),
            FlatButton(
              onPressed: () {
                setState( () {
                  _authMode = AuthMode.SINGUP;
                } );
              },
              textColor: Colors.blue,
              child: Text( "Crear Cuenta" ),
            )
          ],
        )
      ],
    );
  }

  Widget singUpCard(BuildContext context) {
    bool issSwitched = false;
    model.delivery = issSwitched;
    return Column(
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
                      "Crear Cuenta",
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
                      labelText: "Correo",
                    ),
                    onChanged: (String value) {
                      //  onSaved: (String value) {
                      model.correo = value;
                    },
                    //},
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Contraseña",
                    ),
                    onChanged: (String value) {
                      //onSaved: (String value){
                      model.contrasena = value;
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Debe tener al menos 5 caracteres",
                    style: TextStyle( color: Colors.blue ),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Nombre Completo",
                    ),
                    onChanged: (String value) {
                      //onSaved: (String value){
                      model.nombreCompleto = value;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _rutController,
                    validator: RUTValidator(
                        validationErrorText: "Ingrese un rut válido por favor" )
                        .validator,
                    decoration: InputDecoration(
                      labelText: "Rut",
                    ),
                    onChanged: (String value) {
                      RUTValidator.formatFromTextController( _rutController );
                      model.rut = value;
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SwitchListTile(
                    title: Text( '¿Usted es Delivery?' ),
                    value: issSwitched,
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                    secondary: const Icon( Icons.directions_bike ),
                    onChanged: (value) {
                      setState( () {
                        issSwitched = value;
                        model.delivery = value;
                      } );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: Container( ),
                      ),
                      FlatButton(
                        child: Text( "Registrarse" ),
                        color: Colors.blue,
                        textColor: Colors.white,
                        padding: EdgeInsets.only(
                            left: 38, right: 38, top: 15, bottom: 15 ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular( 5 ) ),
                        onPressed: () {
                          model.rut = RUTValidator.formatFromText(model.rut);
                          if (_crearUsuario( ) == true) {
                            _showConfirmado( );
                          } else {
                            _showDesconfirmado();
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
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Text(
              "¿Ya tienes una cuenta?",
              style: TextStyle( color: Colors.blue ),
            ),
            FlatButton(
              onPressed: () {
                setState( () {
                  _authMode = AuthMode.LOGIN;
                } );
              },
              textColor: Colors.black87,
              child: Text( "Ingresar",
                style: TextStyle( color: Colors.blue ), ),
            )
          ],
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
    );
  }

  Widget lowerHalf(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: screenHeight / 2,
        color: Colors.white,
      ),
    );
  }

  void _showConfirmado() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text( 'Cuenta Creada' ),
            content: Text( 'Cuenta creada con exito' ),
            actions: <Widget>[
              FlatButton(
                child: Text( 'Iniciar Sesión' ),
                onPressed: () {
                  setState( () {
                    _authMode = AuthMode.LOGIN;
                  } );
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomeScreen( id: model.rut ) ) );
                },
              )
            ],
          );
        } );
  }

  bool existeUsuario(){
    String rutv, contv;
    bool flag;

    Firestore.instance
        .collection( 'usuarios' )
        .document(rut)
        .get()
        .then( (DocumentSnapshot ds) {
      rutv = ds["Rut"];
      contv = ds["Contraseña"];
      if(rutv != null && contv != null) {
        if ((rut.compareTo( rutv ) == 0) &&
            (contrasena.compareTo( contv ) == 0)) {
          return true;
        }
      }else return false;
    });
  }

  bool _crearUsuario() {
    String rut = null;
    Firestore.instance
        .collection( 'usuarios' )
        .document('2.082.672-64')
        .get( )
        .then( (DocumentSnapshot ds) {
      rut = ds["Rut"];
    } );
    if (rut == null) {
      Firestore.instance.collection( 'usuarios' ).document( model.rut )
          .setData( {
        'Admin': false,
        'Contraseña': model.contrasena,
        'Correo': model.correo,
        'Delivery': model.delivery,
        'Nombre': model.nombreCompleto,
        'Rut': model.rut,
        'Tienda': model.tienda
      } );
      return true;
    } else {
      return false;
    }
  }

  void _showDesconfirmado() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text( 'Error' ),
            content: Text( 'No se pudo crear la cuenta, quizás ya existe' ),
            actions: <Widget>[
              FlatButton(
                child: Text( 'ok' ),
                onPressed: () {
                  Navigator.of( context ).pop( );
                },
              )
            ],
          );
        } );
  }
  void noExisteUsuario(){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text( 'Error' ),
            content: Text( 'No se encontró el Rut o la contraseña es erronea' ),
            actions: <Widget>[
              FlatButton(
                child: Text( 'ok' ),
                onPressed: () {
                  Navigator.of( context ).pop( );
                },
              )
            ],
          );
        } );
  }
}





/*class LoginScreen extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => LoginScreen(),
    );
  }

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  GlobalKey<FormState> _key = GlobalKey();

  RegExp emailRegExp = new RegExp(r'^\w+[\w-\.]*\@\w+((-\w+)|(\w*))\.[a-z]{2,3}$');
  RegExp contRegExp = new RegExp(r'^([1-zA-Z0-1@.\s]{1,255})$');
  String _correo;
  String _contrasena;
  var mensaje = '';

  bool _logueado = false;

  initState() {
    super.initState();

    Firestore.instance.collection('usuarios').document('19617161-4')
        .setData({
      'Nombre': 'Patricio Ignacio Torres Rojas',
      'Rut': '19.617.161-4',
      'Edad': 22,
      'Correo': 'patricio.igtr@gmail.com',
      'Contraseña': 'Pato123',
      'Admin': false,
      'Delivery': false,
      'Tienda': false
    });

    controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    controller.forward();
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Center(child: SingleChildScrollView(child: _logueado ? HomeScreen(mensaje: mensaje) : loginForm())),
    );
  }

  Widget loginForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedLogo(animation: animation),
          ],
        ),
        Container(
          width: 300.0, //size.width * .6,
          child: Form(
            key: _key,
            child: Column(
              children: <Widget>[
                TextFormField(
                  /*validator: (text) {
                    if (text.length == 0) {
                      return "Este campo correo es requerido";
                    } else if (!emailRegExp.hasMatch(text)) {
                      return "El formato para correo no es correcto";
                    }
                    return null;
                  },*/
                  keyboardType: TextInputType.emailAddress,
                  maxLength: 50,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Ingrese su Correo',
                    labelText: 'Correo',
                    counterText: '',
                    icon:
                    Icon(Icons.email, size: 32.0, color: Colors.blue[800]),
                  ),
                  onSaved: (text) => _correo = text,
                ),
                TextFormField(
                  validator: (text) {
                    if (text.length == 0) {
                      return "Este campo contraseña es requerido";
                    } else if (text.length <= 5) {
                      return "Su contraseña debe sernal menos de 5\ncaracteres";
                    } else if (!contRegExp.hasMatch(text)) {
                      return "El formato para contraseña no es correcto";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  maxLength: 20,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Ingrese su Contraseña',
                    labelText: 'Contraseña',
                    counterText: '',
                    icon: Icon(Icons.lock, size: 32.0, color: Colors.blue[800]),
                  ),
                  onSaved: (text) => _contrasena = text,
                ),
                IconButton(
                  onPressed: () {
                    if (_key.currentState.validate()) {
                      _key.currentState.save();
                      /*setState(() {
                        _logueado = true;
                      });*/
                      mensaje = '$_correo/$_contrasena';
//                      Una forma correcta de llamar a otra pantalla
                      Navigator.of(context).push(HomeScreen.route(mensaje));
                    }
                  },
                  icon: Icon(
                    Icons.arrow_forward,
                    size: 42.0,
                    color: Colors.blue[800],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class AnimatedLogo extends AnimatedWidget {
  // Maneja los Tween estáticos debido a que estos no cambian.
  static final _opacityTween = Tween<double>(begin: 0.1, end: 1.0);
  static final _sizeTween = Tween<double>(begin: 0.0, end: 150.0);

  AnimatedLogo({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Opacity(
      opacity: _opacityTween.evaluate(animation),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        height: _sizeTween.evaluate(animation), // Aumenta la altura
        width: _sizeTween.evaluate(animation), // Aumenta el ancho
        child: FlutterLogo(),
      ),
    );
  }
}*/
