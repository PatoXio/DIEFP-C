import 'package:diefpc/Clases/Cliente.dart';
import 'package:diefpc/Clases/ListPedido.dart';
import 'package:diefpc/app/app.dart';
import 'package:diefpc/screens/Menu.dart';
import 'package:diefpc/screens/productosPedido.dart';
import 'package:diefpc/states/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:analog_clock/analog_clock.dart';
import 'package:provider/provider.dart';

const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(42.747932, -71.167889);
const LatLng DEST_LOCATION = LatLng(37.335685, -122.0605916);

class Seguimiento extends StatefulWidget {
  @override
  _SeguimientoState createState() => _SeguimientoState();
}

class ListTileHistory extends StatefulWidget {
  int index;
  ListTileHistory({this.index});
  @override
  _ListTileHistoryState createState() => new _ListTileHistoryState();
}

class _ListTileHistoryState extends State<ListTileHistory> {
  double screenlong;
  String _tiempoDeEntrega;
  Cliente _user;
  DateFormat formatter = DateFormat('HH:mm');
  int count = 0;
  String _difTiempos;
  double screenHeight;
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
    Provider.of<AuthService>(context).actualizarPendientes();
    _user = Provider.of<AuthService>(context).currentUser();
    screenlong = MediaQuery.of(context).size.longestSide;
    screenHeight = MediaQuery.of(context).size.height;
    ListPedido listPedido = _user.getPedidosPendientes();
    DateTime horaActual = DateTime.now();

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
    if (listPedido.getListPedido().elementAt(widget.index).getPorAceptar() ==
        true) {
      _tiempoDeEntrega = "Su pedido se;está preparando";
      _difTiempos = "";
    } else {
      if (listPedido.getListPedido().elementAt(widget.index).getHoraEntrega() !=
          null) {
        _tiempoDeEntrega = "LLegará a las:;" +
            formatter
                .format(listPedido
                    .getListPedido()
                    .elementAt(widget.index)
                    .getHoraEntrega())
                .toString();
        if (listPedido
                .getListPedido()
                .elementAt(widget.index)
                .getHoraEntrega()
                .difference(horaActual)
                .inMinutes >
            0) {
          _difTiempos = "Quedan " +
              listPedido
                  .getListPedido()
                  .elementAt(widget.index)
                  .getHoraEntrega()
                  .difference(horaActual)
                  .inMinutes
                  .toString() +
              " minutos para la entrega de su pedido.";
        } else {
          _tiempoDeEntrega = "Su pedido;está por llegar";
          _difTiempos = "Quedan solo unos minutos";
        }
      } else {
        _tiempoDeEntrega = "Aún no se define;la hora de llegada";
        _difTiempos = "";
      }
    }
    if (listPedido.getListPedido().elementAt(widget.index).getPorEntregar() ==
        true) {
      return Card(
        child: Column(
          children: [
            Container(
                child: Column(children: [
              FloatingActionButton.extended(
                heroTag: "hero${widget.index}",
                label: Text("Pedido ${widget.index + 1}",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductosPedido(
                                pedido: listPedido
                                    .getListPedido()
                                    .elementAt(widget.index),
                              )));
                },
              ),
              /* Container(
                height: screenHeight / 3.5,
                child: Card(
                  //elevation: 5,
                  margin: EdgeInsets.all(10),
                  semanticContainer: true,
                  color: Colors.transparent,
                  child: GoogleMap(
                      myLocationEnabled: true,
                      compassEnabled: true,
                      tiltGesturesEnabled: false,
                      markers: _markers,
                      polylines: _polylines,
                      mapType: MapType.normal,
                      initialCameraPosition: initialCameraPosition,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                        // mi mapa ha terminado de ser creado;
                        // estoy listo para mostrar los pines en el mapa
                        showPinsOnMap();
                      }),
                ),
              ),*/
              Container(
                padding: EdgeInsets.only(left: 30, right: 30),
                child: Row(
                  children: [
                    Divider(
                      indent: screenlong / 38,
                    ),
                    Icon(
                      Icons.departure_board,
                      size: 30,
                      color: Colors.grey,
                    ),
                    Divider(
                      indent: screenlong / 60,
                    ),
                    Text("Enviando sus productos",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.blue)),
                  ],
                ),
              ),
              Container(
                height: screenHeight / 3.6,
                padding: EdgeInsets.only(left: 40),
                child: Theme(
                  data: ThemeData(
                    highlightColor: Colors.blue, //Does not work
                  ),
                  child: Scrollbar(
                    //isAlwaysShown: true,
                    child: Row(
                      children: [
                        AnalogClock(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 2.0, color: Colors.black),
                              color: Colors.transparent,
                              shape: BoxShape.circle),
                          width: 150,
                          isLive: true,
                          hourHandColor: Colors.black,
                          minuteHandColor: Colors.black,
                          showSecondHand: false,
                          numberColor: Colors.black87,
                          showNumbers: true,
                          textScaleFactor: 1.4,
                          showTicks: true,
                          showDigitalClock: false,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Divider(
                                height: screenHeight / 30,
                              ),
                              Text("Son las: ${formatter.format(horaActual)}"),
                              Divider(
                                height: screenHeight / 15,
                              ),
                              Text("${_tiempoDeEntrega.split(";")[0]}"),
                              Text("${_tiempoDeEntrega.split(";")[1]}"),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text("$_difTiempos",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue)),
                  ),
                ],
              )
            ])),
          ],
        ),
      );
    } else {
      return Container(
          child:
              Column(children: [Text("Pedido ${widget.index + 1} Entregado")]));
    }
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
}

class _SeguimientoState extends State<Seguimiento> {
  double screenlong;
  double screenHeight;
  Cliente _user;
  var isSeguimientoPedidos;
  String tiendaTest = "TiendaTest";
  @override
  Widget build(BuildContext context) {
    _user = Provider.of<AuthService>(context).currentUser();
    screenlong = MediaQuery.of(context).size.longestSide;
    screenHeight = MediaQuery.of(context).size.height;
    if (_user.getPedidosPendientes() != null) {
      if (_user.getPedidosPendientes().getListPedido().isNotEmpty) {
        isSeguimientoPedidos = Container(
          margin: EdgeInsets.only(top: screenHeight / 100),
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Scrollbar(
            child: _queryList(context),
          ),
        );
      } else {
        isSeguimientoPedidos = Text("No tienes pedidos pendientes.");
      }
    } else {
      isSeguimientoPedidos = CircularProgressIndicator();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedidos Seguidos"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.list),
              tooltip: 'Configuración',
              onPressed: () {
                configMenu(context);
              }),
        ],
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MenuScreen()),
            );
          },
        ),
      ),
      body: isSeguimientoPedidos,
    );
  }

  Widget _queryList(BuildContext context) {
    if (_user.getPedidosPendientes().getListPedido() != null) {
      int historialLength = _user.getPedidosPendientes().getListPedido().length;
      return ListView(
          children: List.generate(
              historialLength, (i) => new ListTileHistory(index: i)));
    } else {
      return Text(
        "No se poseen pedidos pendientes",
        style: TextStyle(
          color: Colors.red,
          fontSize: 28,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      );
    }
  }

  /* void setPolylines() async {   List<PointLatLng> result = await
  polylinePoints?.getRouteBetweenCoordinates(
      googleAPIKey,
      destinationLocation.latitude,
      destinationLocation.longitude,
      currentLocation.latitude,
      currentLocation.longitude);
  if(result.isNotEmpty){
    result.forEach((PointLatLng point){
      polylineCoordinates.add(
          LatLng(point.latitude,point.longitude)
      );
    });     setState(() {
      _polylines.add(Polyline(
          width: 5, // fije el ancho de las polylineas
          polylineId: PolylineId("poly"),
          color: Color.fromARGB(255, 40, 122, 198),
          points: polylineCoordinates
      ));
    });
  }
  }
  void goProductosTest(String test) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AnadirProductoCarrito(idTienda: tiendaTest)));
  }*/
}
