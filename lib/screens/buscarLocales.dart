import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diefpc/app/app.dart';
import 'package:diefpc/screens/anadirProductoCarrito.dart';
import 'package:diefpc/states/auth.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:maps_toolkit/maps_toolkit.dart' as mp;

const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(42.747932, -71.167889);
const LatLng DEST_LOCATION = LatLng(37.335685, -122.0605916);

class LocalesScreen extends StatefulWidget {
  @override
  _LocalesScreenState createState() => _LocalesScreenState();
}

class _LocalesScreenState extends State<LocalesScreen> {
  String tiendaTest = "TiendaTest";
  double screenlong;
  double screenHeight;
  Map<String, double> distancia = new Map<String, double>();
  List<DocumentSnapshot> _query;
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set<Marker>();
// para mis rutas dibujadas en el mapa
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints;
  String googleAPIKey = 'AIzaSyDgxiJ5v8gB1Qil9NbS1aVLOCaJtwFKlmA';
// para mis marcadores personalizados
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;
// la ubicación inicial del usuario y la ubicación actual
// a medida que se mueve
  LocationData currentLocation;
// una referencia a la ubicación de destino
  LocationData destinationLocation;
// envoltorio alrededor de la API de ubicación
  Location location;
  @override
  void initState() {
    super.initState();

    // crea una instancia de Location
    location = new Location();
    polylinePoints = PolylinePoints();

    // suscribirse a los cambios en la ubicación del usuario
    // "escuchando" el evento onLocationChanged de la ubicación
    location.onLocationChanged.listen((LocationData cLoc) {
      // cLoc contiene el lat y el largo del
      // posición del usuario actual en tiempo real,
      // así que nos aferramos a eso
      currentLocation = cLoc;
      updatePinOnMap();
    });
    // establecer pines marcadores personalizados
    setSourceAndDestinationIcons();
// establece la ubicación inicial
    setInitialLocation();
  }

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/driving_pin.png');

    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/destination_map_marker.png');
  }

  void setInitialLocation() async {
    // establece la ubicación inicial tirando del usuario
    // ubicación actual de getLocation () de la ubicación
    currentLocation = await location.getLocation();

    // destino codificado para este ejemplo
    destinationLocation = LocationData.fromMap({
      "latitude": DEST_LOCATION.latitude,
      "longitude": DEST_LOCATION.longitude
    });
  }

  @override
  Widget build(BuildContext context) {
    _query = Provider.of<AuthService>(context).getTiendas();
    screenlong = MediaQuery.of(context).size.longestSide;
    screenHeight = MediaQuery.of(context).size.height;
    Provider.of<AuthService>(context).actualizarTiendas();
    CameraPosition initialCameraPosition = CameraPosition(
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING,
        target: SOURCE_LOCATION);
    if (currentLocation != null) {
      initialCameraPosition = CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: CAMERA_ZOOM,
          tilt: CAMERA_TILT,
          bearing: CAMERA_BEARING);
    }

    return Consumer(
        builder: (BuildContext context, AuthService state, Widget child) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Tiendas"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.list),
                tooltip: 'Configuración',
                onPressed: () {
                  configMenu(context);
                }),
          ],
        ),
        body: Container(
          margin: EdgeInsets.only(top: screenHeight / 100),
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: <Widget>[
              Container(
                height: screenHeight / 3,
                child: Card(
                  //elevation: 5,
                  margin: EdgeInsets.all(10),
                  semanticContainer: false,
                  color: Colors.transparent,
                  child: GoogleMap(
                      myLocationEnabled: true,
                      //compassEnabled: false,
                      //tiltGesturesEnabled: false,
                      //markers: _markers,
                      //polylines: _polylines,
                      mapType: MapType.normal,
                      initialCameraPosition: initialCameraPosition,
                      onMapCreated: (GoogleMapController controller) {
                        //_controller.complete(controller);
                        // mi mapa ha terminado de ser creado;
                        // estoy listo para mostrar los pines en el mapa
                        //showPinsOnMap();
                      }),
                ),
              ),
              Expanded(
                child: Container(
                  height: screenHeight / 2.6,
                  child: Card(
                    //elevation: 10,
                    margin: EdgeInsets.all(10),
                    semanticContainer: true,
                    //color: Colors.transparent,
                    child: Theme(
                      data: ThemeData(
                        highlightColor: Colors.blue, //Does not work
                      ),
                      child: Scrollbar(child: _queyList(context)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _queyList(BuildContext context) {
    if (_query != null) {
      if (_query.isNotEmpty) {
        return ListView.builder(
            itemCount: _query.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) =>
                buildBody(context, index));
      } else {
        return Text(
          "No posees productos en tu carrito",
          style: TextStyle(
            color: Colors.red,
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        );
      }
    } else {
      return Text(
        "No posees productos en tu carrito",
        style: TextStyle(
          color: Colors.red,
          fontSize: 28,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      );
    }
  }

  Widget buildBody(BuildContext context, int index) {
    if (currentLocation == null) {
      Future.delayed(Duration(seconds: 5),
          () => obtenerDistancia(_query[index].documentID));
    } else
      obtenerDistancia(_query[index].documentID);

    return Card(
      child: ListTile(
        dense: true,
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
              "https://firebasestorage.googleapis.com/v0/b/diefp-c.appspot.com/o/528-5286415_doge-dogge-strong-buff-meme-shitpost-nobackground-swole.png?alt=media&token=aeacea8d-2419-40bf-b220-ba7fcc5f2ac1"),
        ),
        title: Text(_query[index].data["nombre"]),
        subtitle: Text(
            "${distancia == null ? "Calculando..." : distancia[_query[index].documentID] == null ? "Calculando..." : distancia[_query[index].documentID].round() > 1000 ? "A ${(distancia[_query[index].documentID] / 1000).round()} kilometros" : "A ${distancia[_query[index].documentID].round()} metros"}"),
        trailing: FloatingActionButton.extended(
            heroTag: "hero+${_query[index].data["email"]}",
            onPressed: () {
              goProductosTest(
                  _query[index].documentID, _query[index].data["nombre"]);
            },
            label: Text("Ver")),
        isThreeLine: true,
      ),
    );
  }

  void obtenerDistancia(String codigo) async {
    mp.LatLng latLng =
        new mp.LatLng(currentLocation.latitude, currentLocation.longitude);
    DocumentSnapshot document = await Firestore.instance
        .collection('usuarios')
        .document(codigo)
        .collection("Direccion")
        .document("0")
        .get();
    double dist = mp.SphericalUtil.computeDistanceBetween(
        latLng, mp.LatLng(document.data["lat"], document.data["lng"]));
    setState(() {
      if (distancia == null) {
        distancia.putIfAbsent(codigo, () => dist);
      } else if (distancia.containsKey(codigo) == false) {
        distancia.putIfAbsent(codigo, () => dist);
      }
    });
  }

  void showPinsOnMap() {
// obtener un LatLng para la ubicación de origen
    // del objeto LocationData currentLocation

    var pinPosition =
        LatLng(currentLocation.latitude, currentLocation.longitude);
    // obtener un LatLng del objeto LocationData
    var destPosition =
        LatLng(destinationLocation.latitude, destinationLocation.longitude);
    // agrega el pin de ubicación de origen inicial
    _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: pinPosition,
        icon: sourceIcon));
    // pin de destino
    _markers.add(Marker(
        markerId: MarkerId('destPin'),
        position: destPosition,
        icon: destinationIcon));
    // establece las líneas de ruta en el mapa desde el origen hasta   el destino
    // para más información sigue este tutorial
    //setPolylines();
  }

  void updatePinOnMap() async {
    // crea una nueva instancia de CameraPosition
    // cada vez que cambia la ubicación, entonces la cámara
    // sigue el pin mientras se mueve con una animación
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
// haz esto dentro de setState () para que se notifique a Flutter
    // que se debe actualizar un widget

    setState(() {
      //controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
      // updated position
      var pinPosition =
          LatLng(currentLocation.latitude, currentLocation.longitude);

      // el truco es eliminar el marcador (por id)
      // y agregarlo nuevamente en la ubicación actualizada
      _markers.removeWhere((m) => m.markerId.toString() == 'sourcePin');
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          position: pinPosition, // posición actualizada
          icon: sourceIcon));
    });
  }

  void goProductosTest(String idTienda, nombreTienda) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AnadirProductoCarrito(
                idTienda: idTienda, nombre: nombreTienda)));
  }
}
