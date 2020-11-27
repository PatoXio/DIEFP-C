import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diefpc/Clases/Delivery.dart';
import 'package:diefpc/app/app.dart';
import 'package:diefpc/screens/detallesPedidoEntregar.dart';
import 'package:diefpc/screens/pedidosDisponiblesPorTienda.dart';
import 'package:diefpc/states/auth.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:maps_toolkit/maps_toolkit.dart' as mp;

const double CAMERA_ZOOM = 12;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(42.747932, -71.167889);
const LatLng DEST_LOCATION = LatLng(37.335685, -122.0605916);

class EntregarPedidos extends StatefulWidget {
  @override
  _EntregarPedidosScreenState createState() => _EntregarPedidosScreenState();
}

class _EntregarPedidosScreenState extends State<EntregarPedidos> {
  String tiendaTest = "TiendaTest";
  double screenlong;
  double screenHeight;
  int area;
  String selected;
  Widget tienditas;
  Map<String, double> distancia = new Map<String, double>();
  Map<String, int> pedidos = new Map<String, int>();
  Stream<QuerySnapshot> _stream;
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = HashSet<Marker>();
  Delivery _user;
// para mis rutas dibujadas en el mapa
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints;
  String googleAPIKey = 'AIzaSyDgxiJ5v8gB1Qil9NbS1aVLOCaJtwFKlmA';
// para mis marcadores personalizados
  BitmapDescriptor sourceIcon;
  List<DocumentSnapshot> newListDocument;
  BitmapDescriptor destinationIcon;
  Widget listLoad;
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
    _user = Provider.of<AuthService>(context).currentUser();
    _stream = Firestore.instance
        .collection('usuarios')
        .document(_user.email)
        .collection("Pedidos")
        .snapshots();

    screenlong = MediaQuery.of(context).size.longestSide;
    screenHeight = MediaQuery.of(context).size.height;
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

    return Scaffold(
        appBar: AppBar(
          title: Text("Pedidos por Entregar"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.list),
                tooltip: 'Configuración',
                onPressed: () {
                  configMenu(context);
                }),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _stream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Container(
              //margin: EdgeInsets.only(top: screenHeight / 50),
              //padding: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: <Widget>[
                  Container(
                    height: screenHeight / 2,
                    child: GoogleMap(
                        myLocationEnabled: true,
                        compassEnabled: true,
                        zoomGesturesEnabled: true,
                        tiltGesturesEnabled: false,
                        markers: _markers,
                        //polylines: _polylines,
                        mapType: MapType.normal,
                        initialCameraPosition: initialCameraPosition,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                          // mi mapa ha terminado de ser creado;
                          // estoy listo para mostrar los pines en el mapa
                          //showPinsOnMap(newListDocument);
                        }),
                  ),
                  Expanded(
                    child: Container(
                      height: screenHeight / 2.6,
                      child: Card(
                        //elevation: 10,
                        //margin: EdgeInsets.all(10),
                        semanticContainer: true,
                        //color: Colors.transparent,
                        child: Theme(
                          data: ThemeData(
                            highlightColor: Colors.blue, //Does not work
                          ),
                          child: Scrollbar(child: _queyList(context, snapshot)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }

  Widget _queyList(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.data != null) {
      obtenerDistancia(snapshot.data.documents);

      return ListView.builder(
          itemCount: snapshot.data.documents.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) =>
              buildBody(context, index, snapshot.data.documents));
    } else {
      return Text(
        "No hay pedidos por entregar",
        style: TextStyle(
          color: Colors.red,
          fontSize: 28,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      );
    }
  }

  Widget buildBody(
      BuildContext context, int index, List<DocumentSnapshot> listDocument) {
    if (selected != null) {
      if (selected.compareTo(listDocument[index].documentID) == 0) {
        tienditas = Container(
          decoration: new BoxDecoration(color: Colors.green[50]),
          child: ListTile(
            dense: true,
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://firebasestorage.googleapis.com/v0/b/diefp-c.appspot.com/o/528-5286415_doge-dogge-strong-buff-meme-shitpost-nobackground-swole.png?alt=media&token=aeacea8d-2419-40bf-b220-ba7fcc5f2ac1"),
            ),
            title: Text(listDocument[index].data["Cliente"]),
            subtitle: Text(
                "${distancia == null ? "Calculando..." : distancia[listDocument[index].documentID] == null ? "Calculando..." : distancia[listDocument[index].documentID].round() > 1000 ? "A ${(distancia[listDocument[index].documentID] / 1000).round()} kilometros" : "A ${distancia[listDocument[index].documentID].round()} metros"}" +
                    "\nTotal: ${listDocument[index].data["Total Pagado"]}"),
            trailing: Column(
              children: [
                FloatingActionButton.extended(
                    heroTag:
                        "hero+${listDocument[index].data["Cliente"]}+${listDocument[index].data["Fecha"]}+${listDocument[index].data["Total Pagado"]}}",
                    onPressed: () {
                      goDetallesPedido(listDocument[index]);
                    },
                    label: Text("Detalles")),
              ],
            ),
            isThreeLine: true,
          ),
        );
      } else {
        tienditas = ListTile(
          dense: true,
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
                "https://firebasestorage.googleapis.com/v0/b/diefp-c.appspot.com/o/528-5286415_doge-dogge-strong-buff-meme-shitpost-nobackground-swole.png?alt=media&token=aeacea8d-2419-40bf-b220-ba7fcc5f2ac1"),
          ),
          title: Text(listDocument[index].data["Cliente"]),
          subtitle: Text(
              "${distancia == null ? "Calculando..." : distancia[listDocument[index].documentID] == null ? "Calculando..." : distancia[listDocument[index].documentID].round() > 1000 ? "A ${(distancia[listDocument[index].documentID] / 1000).round()} kilometros" : "A ${distancia[listDocument[index].documentID].round()} metros"}" +
                  "\nTotal: ${listDocument[index].data["Total Pagado"]}"),
          trailing: Column(
            children: [
              FloatingActionButton.extended(
                  heroTag:
                      "hero+${listDocument[index].data["Cliente"]}+${listDocument[index].data["Fecha"]}+${listDocument[index].data["Total Pagado"]}}",
                  onPressed: () {
                    goDetallesPedido(listDocument[index]);
                  },
                  label: Text("Detalles")),
            ],
          ),
          isThreeLine: true,
        );
      }
    } else {
      tienditas = ListTile(
        dense: true,
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
              "https://firebasestorage.googleapis.com/v0/b/diefp-c.appspot.com/o/528-5286415_doge-dogge-strong-buff-meme-shitpost-nobackground-swole.png?alt=media&token=aeacea8d-2419-40bf-b220-ba7fcc5f2ac1"),
        ),
        title: Text(listDocument[index].data["Cliente"]),
        subtitle: Text(
            "${distancia == null ? "Calculando..." : distancia[listDocument[index].documentID] == null ? "Calculando..." : distancia[listDocument[index].documentID].round() > 1000 ? "A ${(distancia[listDocument[index].documentID] / 1000).round()} kilometros" : "A ${distancia[listDocument[index].documentID].round()} metros"}" +
                "\nTotal: ${listDocument[index].data["Total Pagado"]}"),
        trailing: Column(
          children: [
            FloatingActionButton.extended(
                heroTag:
                    "hero+${listDocument[index].data["Cliente"]}+${listDocument[index].data["Fecha"]}+${listDocument[index].data["Total Pagado"]}}",
                onPressed: () {
                  goDetallesPedido(listDocument[index]);
                },
                label: Text("Detalles")),
          ],
        ),
        isThreeLine: true,
      );
    }
    return Card(
      child: tienditas,
    );
  }

  void obtenerDistancia(
      List<DocumentSnapshot> listDocument /*String codigo*/) async {
    if (currentLocation != null) {
      Map<String, double> distan = Map<String, double>();
      mp.LatLng latLng =
          new mp.LatLng(currentLocation.latitude, currentLocation.longitude);

      for (int i = 0; i < listDocument.length; i++) {
        double dist = mp.SphericalUtil.computeDistanceBetween(
            latLng,
            mp.LatLng(double.parse(listDocument[i].data["lat"]),
                double.parse(listDocument[i].data["lng"])));

        if (distan.isEmpty) {
          setMarker(
              LatLng(double.parse(listDocument[i].data["lat"]),
                  double.parse(listDocument[i].data["lng"])),
              listDocument[i].data["Cliente"],
              listDocument[i].documentID);
        } else {
          if (distan.containsKey(listDocument[i].documentID) == false) {
            setMarker(
                LatLng(double.parse(listDocument[i].data["lat"]),
                    double.parse(listDocument[i].data["lng"])),
                listDocument[i].data["Cliente"],
                listDocument[i].documentID);
          }
        }
        if (distan == null) {
          distan.putIfAbsent(listDocument[i].documentID, () => dist);
        } else if (distan.containsKey(listDocument[i].documentID) == false) {
          distan.putIfAbsent(listDocument[i].documentID, () => dist);
        }
      }
      setState(() {
        distancia = distan;
      });
    }
  }

  void setMarker(LatLng point, String nombre, String id) async {
    if (this.mounted) {
      setState(() {
        _markers.add(Marker(
            markerId: MarkerId(id),
            position: point,
            onTap: () {
              setState(() {
                selected = id;
              });
            },
            icon: BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(title: nombre)));
      });
    }
  }

  /*void showPinsOnMap(List<DocumentSnapshot> listDocument) async {
// obtener un LatLng para la ubicación de origen
    // del objeto LocationData currentLocation

    for (int i = 0; i < listDocument.length; i++) {
      DocumentSnapshot direccion = await Firestore.instance
          .collection('usuarios')
          .document(listDocument[i].documentID)
          .collection('Direccion')
          .document('0')
          .get();

      var pinPosition = LatLng(direccion.data["lat"], direccion.data["lng"]);

      setState(() {
        _markers.add(Marker(
            markerId: MarkerId('id:${listDocument[i].documentID}'),
            position: pinPosition,
            icon: sourceIcon));
      });

      //print("marcador: " + marker.toString());
    }
    // establece las líneas de ruta en el mapa desde el origen hasta   el destino
    // para más información sigue este tutorial
    //setPolylines();
  }*/

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
      _markers.removeWhere((m) => m.markerId.toString() == _user.email);
      _markers.add(Marker(
          markerId: MarkerId(_user.email),
          position: pinPosition, // posición actualizada
          icon: sourceIcon));
    });
  }

  void _showAlert(BuildContext context, String notify) {
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
                /*Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AnadirProductoCarrito(
                            idTienda: widget.idTienda, nombre: widget.nombre)));
              */
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void goPedidosTienda(String idTienda) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PedidosDisponibles(id: idTienda)));
  }

  void goDetallesPedido(DocumentSnapshot document) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetallesPedidoEntregar(document: document)));
  }
}
