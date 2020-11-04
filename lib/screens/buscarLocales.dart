import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diefpc/app/app.dart';
import 'package:diefpc/states/auth.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'anadirProductoCarrito.dart';

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
  Stream<QuerySnapshot> _query;
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
      _query = Provider.of<AuthService>(context).getTiendas();
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
                      child: Scrollbar(
                        //isAlwaysShown: true,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: _query,
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError)
                              return new Text('Error: ${snapshot.error}');
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return CircularProgressIndicator();
                              default:
                                return new ListView(
                                  children: snapshot.data.documents
                                      .map((DocumentSnapshot document) {
                                    return Card(
                                      child: new ListTile(
                                        title:
                                            new Text(document.data['nombre']),
                                        subtitle: new Text(
                                            "Distancia: ${obtenerDistancia(document.data['nombre'], document.data['nombre'])}"),
                                        trailing: FloatingActionButton.extended(
                                            heroTag:
                                                "hero+${document.data["email"]}",
                                            onPressed: () {
                                              goProductosTest(
                                                  document.documentID);
                                            },
                                            label: Text("Ver")),
                                      ),
                                    );
                                  }).toList(),
                                );
                            }
                          },
                        ),
                      ),
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

  String obtenerDistancia(double x, y) {
    double dist = ((currentLocation.longitude - x) * 2 +
            (currentLocation.latitude - y) * 2) *
        0.5;
    return dist.toString();
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

  void goProductosTest(String tienda) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AnadirProcutoCarrito(idTienda: tienda)));
  }
}
