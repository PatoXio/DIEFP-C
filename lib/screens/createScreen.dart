import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diefpc/Clases/Cliente.dart';
import 'package:diefpc/Clases/Delivery.dart';
import 'package:diefpc/Clases/Direccion.dart';
import 'package:diefpc/Clases/Tienda.dart';
import 'package:diefpc/Clases/Usuario.dart';
import 'package:diefpc/app/app.dart';
import 'package:diefpc/screens/home.dart';
import 'package:diefpc/states/auth.dart';
import 'package:diefpc/states/login_state.dart';
import 'package:flutter/material.dart';
import 'package:dart_rut_validator/dart_rut_validator.dart' show RUTValidator;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:diefpc/Maps/place_service.dart';
import 'package:diefpc/Maps/adressSearch.dart';

TextEditingController _rutController = TextEditingController();

class CreateScreen extends StatefulWidget {
  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  double screenHeight;
  Cliente model = new Cliente();
  Delivery modelDelivery = new Delivery();
  Tienda modelTienda = new Tienda();
  Direccion direccion = new Direccion();
  bool isSwitchDelivery = false;
  bool isSwitchTienda = false;
  bool checkBoxValue = true;
  bool moto = false;
  bool automovil = false;
  bool bicicleta = false;
  final _controller = TextEditingController();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Set intial mode to login
  @override
  void initState() {
    _rutController.clear();
    super.initState();
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
    bool isCreate = Provider.of<AuthService>(context).isCreate();
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
                  child: _column(context, isCreate),
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

  // ignore: missing_return
  Widget _column(BuildContext context, bool isCreate) {
    if (isCreate == false) {
      if (checkBoxValue == true) return _columnUser(context);
      if (isSwitchDelivery == true) return _columnDelivery(context);
      if (isSwitchTienda == true) return _columnTienda(context);
    }
  }

  Widget _columnDelivery(BuildContext context) {
    return Column(
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
        CheckboxListTile(
          title: Text('¿Usted es un Usuario Común?'),
          value: checkBoxValue,
          activeColor: Colors.green,
          secondary: const Icon(Icons.supervised_user_circle),
          onChanged: (bool newValue) {
            checkBoxValue = true;
            isSwitchDelivery = false;
            isSwitchTienda = false;
          },
        ),
        SizedBox(
          height: 15,
        ),
        CheckboxListTile(
          title: Text('¿Usted es Delivery?'),
          value: isSwitchDelivery,
          activeColor: Colors.green,
          secondary: const Icon(Icons.directions_bike),
          onChanged: (bool newValue) {
            isSwitchDelivery = true;
            isSwitchTienda = false;
            checkBoxValue = false;
            //if (isSwitchDelivery == false) checkBoxValue = true;
          },
        ),
        SizedBox(
          height: 15,
        ),
        CheckboxListTile(
          title: Text('¿Usted es una Farmacia?'),
          value: isSwitchTienda,
          activeColor: Colors.green,
          secondary: const Icon(Icons.local_hospital),
          onChanged: (bool newValue) {
            isSwitchTienda = true;
            isSwitchDelivery = false;
            checkBoxValue = false;
            //if (isSwitchTienda == false) checkBoxValue = true;
          },
        ),
        SizedBox(
          height: 15,
        ),
        TextFormField(
          maxLength: 50,
          validator: (String value) {
            if (value.isEmpty) {
              return 'Ingrese un correo valido';
            }
            return null;
          },
          decoration: InputDecoration(
            labelText: "Correo",
          ),
          onChanged: (String value) {
            modelDelivery.setEmail(value);
          },
        ),
        SizedBox(
          height: 15,
        ),
        TextFormField(
          obscureText: true,
          maxLength: 50,
          validator: (String value) {
            if (value.isEmpty) {
              return 'Ingrese una contraseña valida';
            }
            return null;
          },
          decoration: InputDecoration(
            labelText: "Contraseña",
          ),
          onChanged: (String value) {
            modelDelivery.setPassword(value);
          },
        ),
        SizedBox(
          height: 15,
        ),
        TextFormField(
          obscureText: true,
          maxLength: 10,
          validator: (String value) {
            if (value.isEmpty) {
              return 'Debe ingresar una contraseña';
            } else if (modelDelivery.getPassword() == null) {
              return 'Debe ingresar una contraseña valida\nen el parametro anterior';
            } else if (value.compareTo(modelDelivery.getPassword()) != 0) {
              return 'La contraseña no coincide';
            }
            return null;
          },
          decoration: InputDecoration(
            labelText: "Confirmar Contraseña",
          ),
        ),
        SizedBox(
          height: 15,
        ),
        TextFormField(
          maxLength: 50,
          validator: (value) {
            if (value.isEmpty) {
              return 'Ingrese su nombre completo';
            }
            return null;
          },
          decoration: InputDecoration(
            labelText: "Nombre Completo",
          ),
          onChanged: (String value) {
            modelDelivery.setName(value);
          },
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
          onChanged: (String value) {
            modelDelivery.setRut(value);
          },
          validator: RUTValidator(validationErrorText: 'Ingrese un RUT válido')
              .validator,
        ),
        SizedBox(
          height: 15,
        ),
        TextFormField(
          maxLength: 9,
          validator: (value) {
            if (value.isEmpty) {
              return 'Ingrese su número de celular';
            }
            return null;
          },
          decoration: InputDecoration(
            labelText: "Número Celular sin el '+56'",
          ),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            WhitelistingTextInputFormatter.digitsOnly
          ],
          onChanged: (String value) {
            modelDelivery.setTelefono(value);
          },
        ),
        SizedBox(
          height: 15,
        ),
        TextFormField(
          maxLength: 15,
          decoration: InputDecoration(
            labelText: "Código de invitación (Opcional)",
          ),
          onChanged: (String value) {
            modelDelivery.setCodigoDeInvitacion(value);
          },
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
            moto = true;
            automovil = false;
            bicicleta = false;
            modelDelivery.setMedioDeTransporte("Motocicleta");
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
            automovil = true;
            moto = false;
            bicicleta = false;
            modelDelivery.setMedioDeTransporte("Automovil");
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
            bicicleta = true;
            moto = false;
            automovil = false;
            modelDelivery.setMedioDeTransporte("Bicicleta");
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
              child: Text("Completar\nRegistro"),
              color: Colors.blue,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              onPressed: () async {
                RUTValidator.formatFromTextController(_rutController);
                modelDelivery.setRut(_rutController.value.text);
                if (_formKey.currentState.validate()) {
                  if (isSwitchDelivery == true &&
                      modelDelivery.getMedioDeTransporte() != null) {
                    dynamic result = await _auth.registerWithEmailAndPassword(
                        modelDelivery.getEmail(), modelDelivery.getPassword());
                    if (result == null) {
                      _showDialogEmailError();
                    } else {
                      _createDelivery(
                          modelDelivery.getEmail(),
                          modelDelivery.getPassword(),
                          modelDelivery.getName(),
                          modelDelivery.getRut(),
                          modelDelivery.getTelefono(),
                          modelDelivery.getCodigoDeInvitacion(),
                          modelDelivery.getMedioDeTransporte());
                      /*Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateDelivery2(email: modelDelivery.getEmail())));*/
                      _showDialog();
                    }
                  } else
                    _showDialogTransporte();
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _columnTienda(BuildContext context) {
    return Column(
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
        CheckboxListTile(
          title: Text('¿Usted es un Usuario Común?'),
          value: checkBoxValue,
          activeColor: Colors.green,
          secondary: const Icon(Icons.supervised_user_circle),
          onChanged: (bool newValue) {
            checkBoxValue = true;
            isSwitchDelivery = false;
            isSwitchTienda = false;
          },
        ),
        SizedBox(
          height: 15,
        ),
        CheckboxListTile(
          title: Text('¿Usted es Delivery?'),
          value: isSwitchDelivery,
          activeColor: Colors.green,
          secondary: const Icon(Icons.directions_bike),
          onChanged: (bool newValue) {
            isSwitchDelivery = true;
            isSwitchTienda = false;
            checkBoxValue = false;
            //if (isSwitchDelivery == false) checkBoxValue = true;
          },
        ),
        SizedBox(
          height: 15,
        ),
        CheckboxListTile(
          title: Text('¿Usted es una Farmacia?'),
          value: isSwitchTienda,
          activeColor: Colors.green,
          secondary: const Icon(Icons.local_hospital),
          onChanged: (bool newValue) {
            isSwitchTienda = true;
            isSwitchDelivery = false;
            checkBoxValue = false;
            //if (isSwitchTienda == false) checkBoxValue = true;
          },
        ),
        SizedBox(
          height: 15,
        ),
        TextFormField(
          maxLength: 50,
          validator: (String value) {
            if (value.isEmpty) {
              return 'Ingrese un nombre';
            } else if (value.length < 5) {
              return "El nobmre es demasiado corto";
            }
            return null;
          },
          decoration: InputDecoration(
            labelText: "Nombre Completo",
          ),
          onChanged: (String value) {
            modelTienda.setName(value);
          },
        ),
        SizedBox(
          height: 15,
        ),
        TextFormField(
          maxLength: 50,
          validator: (String value) {
            if (value.isEmpty) {
              return 'Ingrese un correo valido';
            }
            return null;
          },
          decoration: InputDecoration(
            labelText: "Correo",
          ),
          onChanged: (String value) {
            modelTienda.setEmail(value);
          },
        ),
        SizedBox(
          height: 15,
        ),
        TextFormField(
          maxLength: 50,
          obscureText: true,
          validator: (value) {
            if (value.isEmpty) {
              return 'Ingrese una contraseña valida';
            } else if (value.length < 6) {
              return "Debe poseer al menos 6 caracteres";
            }
          },
          decoration: InputDecoration(
            labelText: "Contraseña",
          ),
          onChanged: (String value) {
            modelTienda.setPassword(value);
          },
        ),
        SizedBox(
          height: 15,
        ),
        TextFormField(
          maxLength: 20,
          obscureText: true,
          validator: (value) {
            if (value.isEmpty) {
              return 'Debe ingresar una contraseña';
            } else if (value.compareTo(modelTienda.getPassword()) != 0)
              return 'La contraseña no coincide';
          },
          decoration: InputDecoration(
            labelText: "Confirmar Contraseña",
          ),
        ),
        SizedBox(
          height: 15,
        ),
        TextFormField(
          maxLength: 12,
          decoration: InputDecoration(
            labelText: "Patente",
          ),
          onChanged: (String value) {
            modelTienda.setPatente(value);
          },
          validator: (value) {
            if (value.isEmpty) {
              return 'Ingrese una patente';
            } else if (value.length < 5) {
              return "La patente no es válida";
            }
          },
        ),
        SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: _controller,
          readOnly: true,
          decoration: InputDecoration(
            labelText: "Ingrese su dirección",
          ),
          onTap: () async {
            final sessionToken = Uuid().v4();
            final Suggestion result = await showSearch(
              context: context,
              delegate: AddressSearch(sessionToken),
            );
            if (result != null) {
              final placeDetails = await PlaceApiProvider(sessionToken)
                  .getPlaceDetailFromId(result.placeId);
              _controller.text = result.description;
              direccion.setNumero(placeDetails.streetNumber);
              direccion.setCalle(placeDetails.street);
              direccion.setCiudad(placeDetails.city);
              direccion.setCodigoPostal(placeDetails.zipCode);
              direccion.setLat(placeDetails.lat);
              direccion.setLng(placeDetails.lng);
              direccion.setRegion(placeDetails.region);
              direccion.setProvincia(placeDetails.provincia);
              direccion.setPais(placeDetails.country);
              direccion.setId(0);
              modelTienda.setDireccion(direccion);
            }
          },
          validator: (value) {
            if (value.isEmpty) {
              return "Ingrese una dirección Valida";
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
              child: Text("Confirmar Registro"),
              color: Colors.blue,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  if (isSwitchTienda == true) {
                    dynamic resultEmail =
                        await _auth.registerWithEmailAndPassword(
                            modelTienda.getEmail(), modelTienda.getPassword());
                    if (resultEmail == null) {
                      _showDialogEmailError();
                    } else {
                      _createTienda(
                          modelTienda.getName(),
                          modelTienda.getEmail(),
                          modelTienda.getPassword(),
                          modelTienda.getPatente(),
                          direccion);
                      _showDialog();
                      /*Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CreateTienda1(modelTienda.getEmail())));*/
                    }
                  }
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _columnUser(BuildContext context) {
    return Column(
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
        CheckboxListTile(
          title: Text('¿Usted es un Usuario Común?'),
          value: checkBoxValue,
          activeColor: Colors.green,
          secondary: const Icon(Icons.supervised_user_circle),
          onChanged: (bool newValue) {
            checkBoxValue = true;
            isSwitchDelivery = false;
            isSwitchTienda = false;
          },
        ),
        SizedBox(
          height: 15,
        ),
        CheckboxListTile(
          title: Text('¿Usted es Delivery?'),
          value: isSwitchDelivery,
          activeColor: Colors.green,
          secondary: const Icon(Icons.directions_bike),
          onChanged: (bool newValue) {
            isSwitchDelivery = true;
            isSwitchTienda = false;
            checkBoxValue = false;
            //if (isSwitchDelivery == false) checkBoxValue = true;
          },
        ),
        SizedBox(
          height: 15,
        ),
        CheckboxListTile(
          title: Text('¿Usted es una Farmacia?'),
          value: isSwitchTienda,
          activeColor: Colors.green,
          secondary: const Icon(Icons.local_hospital),
          onChanged: (bool newValue) {
            isSwitchTienda = true;
            isSwitchDelivery = false;
            checkBoxValue = false;
            //if (isSwitchTienda == false) checkBoxValue = true;
          },
        ),
        SizedBox(
          height: 15,
        ),
        TextFormField(
          maxLength: 20,
          validator: (value) {
            if (value.isEmpty) {
              return 'Ingrese su nombre completo';
            }
          },
          decoration: InputDecoration(
            labelText: "Nombre Completo",
          ),
          onChanged: (String value) {
            model.setName(value);
          },
        ),
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
            model.setEmail(value);
          },
        ),
        SizedBox(
          height: 15,
        ),
        TextFormField(
          maxLength: 10,
          obscureText: true,
          validator: (value) {
            if (value.isEmpty) {
              return 'Debe ingresar una contraseña';
            } else if (value.length < 6)
              return 'La contraseña debe contener al menos\n6 caracteres';
          },
          decoration: InputDecoration(
            labelText: "Contraseña",
          ),
          onChanged: (String value) {
            model.setPassword(value);
          },
        ),
        SizedBox(
          height: 15,
        ),
        TextFormField(
          maxLength: 10,
          obscureText: true,
          validator: (String value) {
            if (value.isEmpty) {
              return 'Debe ingresar una contraseña';
            } else if (model.getPassword() == null) {
              return 'Debe ingresar una contraseña valida\nen el parametro anterior';
            } else if (value.compareTo(model.getPassword()) != 0) {
              print(model.getPassword());
              return 'La contraseña no coincide';
            }
          },
          decoration: InputDecoration(
            labelText: "Confirmar contraseña",
          ),
        ),
        TextFormField(
          maxLength: 12,
          decoration: InputDecoration(
            labelText: "Rut",
          ),
          controller: _rutController,
          onChanged: (String value) {
            model.setRut(value);
          },
          validator: RUTValidator(validationErrorText: 'Ingrese un RUT válido')
              .validator,
        ),
        SizedBox(
          height: 15,
        ),
        TextFormField(
          maxLength: 12,
          decoration: InputDecoration(
            labelText: "Codigo de Invitación",
          ),
          onChanged: (String value) {
            model.setCodigoDeInvitacion(value);
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
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  RUTValidator.formatFromTextController(_rutController);
                  model.setRut(_rutController.value.text);
                  if (checkBoxValue == true) {
                    Usuario result = await _auth.registerWithEmailAndPassword(
                        model.getEmail(), model.getPassword());
                    if (result == null) {
                      _showDialogEmailError();
                    } else {
                      _createUser(
                          model.getEmail(),
                          model.getPassword(),
                          model.getRut(),
                          model.getName(),
                          model.getCodigoDeInvitacion());
                      _showDialog();
                    }
                  }
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  void _showDialogEmailError() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Este correo ya está en uso o no es correcto"),
          content: new Text("Ingresa un correo válido."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                //Provider.of<LoginState>(context).isComplete();
                //Navigator.pop(context);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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
          content: new Text("Ahora podrás iniciar sesión."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                //Provider.of<LoginState>(context).isComplete();
                //Navigator.pop(context);
                _auth.signOut();
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => MyApp()));
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialogTransporte() {
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

  void _createTienda(
      String name, email, password, patente, Direccion direccion) {
    Firestore.instance.collection('usuarios').document(email).setData({
      "nombre": name,
      "email": email,
      "password": password,
      "patente": patente,
      "tipo": "Tienda",
    });
    _createDireccion(direccion, email);
  }

  void _createDireccion(Direccion direccion, String email) {
    Firestore.instance
        .collection('usuarios')
        .document(email)
        .collection('Direccion')
        .document(direccion.getId().toString())
        .setData({
      "calle": direccion.getCalle(),
      "depto": direccion.getDepto(),
      "ciudad": direccion.getCiudad(),
      "provincia": direccion.getProvincia(),
      "country": direccion.getCountry(),
      "region": direccion.getRegion(),
      "codigoPostal": direccion.getCodigoPostal(),
      "numero": direccion.getNumero(),
      "LatLng": direccion.getLatLng(),
      "lat": direccion.getLatitud(),
      "lng": direccion.getLongitud()
    });
  }

  void _createUser(
      String email, String password, String rut, String nombre, String codigo) {
    Firestore.instance.collection('usuarios').document(email).setData({
      "nombre": nombre,
      "email": email,
      "password": password,
      "Rut": rut,
      "codigo": codigo,
      "tipo": "Cliente",
    });
  }

  void _createDelivery(String email, String password, String name, String rut,
      String telefono, String codigo, String transporte) {
    Firestore.instance.collection('usuarios').document(email).setData({
      "nombre": name,
      "email": email,
      "Rut": rut,
      "numero": telefono,
      "codigo": codigo,
      "transporte": transporte,
      "tipo": "Delivery",
    });
  }

  void goToHomeScreen(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  void goToRestart(BuildContext context) {
    Provider.of<LoginState>(context).isComplete();
    Provider.of<LoginState>(context).logout();
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => MyApp()));
  }

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }
}
