import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diefpc/Clases/Cliente.dart';
import 'package:diefpc/Clases/Direccion.dart';
import 'package:diefpc/Maps/adressSearch.dart';
import 'package:diefpc/Maps/place_service.dart';
import 'package:diefpc/screens/home.dart';
import 'package:diefpc/states/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CrearDireccion extends StatefulWidget {
  @override
  _CrearDireccionState createState() => _CrearDireccionState();
}

class _CrearDireccionState extends State<CrearDireccion> {
  double screenHeight;
  Direccion direccion = new Direccion();
  final _controller = TextEditingController();

  Cliente _user;

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _user = Provider.of<AuthService>(context).currentUser();
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Nueva Dirección",
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
                          final placeDetails =
                              await PlaceApiProvider(sessionToken)
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
                          direccion
                              .setId(_user.getDireccionIdLibre()); //por revisar
                        }
                      },
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
                        child: Text("Guardar"),
                        color: Colors.blue,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        onPressed: () {
                          if (direccion.getId() != null) {
                            _user.setDireccion(direccion);
                            if (_user.getIdDireccion() == null) {
                              _user.setIdDireccion(direccion.getId());
                              actualizarIdDireccion(direccion);
                              Provider.of<AuthService>(context).setDireccion();
                            }
                            _createDireccion(direccion, _user.getEmail());
                            Provider.of<AuthService>(context)
                                .actualizarUser(_user);
                            Navigator.pop(context);
                          } else
                            _showAlert("Debe añadir una direccion válida");
                        }),
                  ],
                ),
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
      ),
    );
  }

  void _showAlert(String notify) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Aviso"),
          content: new Text(notify),
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

  void _showDireccionAgregada() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Se a agregó la nueva dirección"),
          content: new Text(
              "Ahora podrás seleccionar la nueva dereccion en tu menú para tus próximos pedidos."),
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
      "lat": direccion.getLatitud(),
      "lng": direccion.getLongitud()
    });
  }

  void actualizarIdDireccion(Direccion direccion) {
    Firestore.instance
        .collection("usuarios")
        .document(_user.getEmail())
        .setData({"Direccion": direccion.getId()}, merge: true);
  }

  void goToHomeScreen(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }
}
