import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diefpc/Clases/Cliente.dart';
import 'package:diefpc/Clases/Delivery.dart';
import 'package:diefpc/Clases/Direccion.dart';
import 'package:diefpc/Clases/ListDireccion.dart';
import 'package:diefpc/Clases/ListPedido.dart';
import 'package:diefpc/Clases/ListProducto.dart';
import 'package:diefpc/Clases/Pedido.dart';
import 'package:diefpc/Clases/Producto.dart';
import 'package:diefpc/Clases/Tienda.dart';
import 'package:diefpc/Clases/Usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:diefpc/documents/documents_service.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  SharedPreferences _prefs;
  FirebaseUser _user;
  var _usuario;

  DocumentSnapshot document;
  List<DocumentSnapshot> pedidosPendientes;
  List<DocumentSnapshot> listProducto;
  List<DocumentSnapshot> listPedido;
  List<DocumentSnapshot> listDireccion;
  List<DocumentSnapshot> tiendas;

  bool _loggedIn = false;
  bool _loading = true;
  bool _isCreated = false;
  bool _isLoadData = false;
  bool _isComplete = false;

  AuthService() {
    loginState();
  }

  bool isCreate() {
    createState();
    return _isCreated;
  }

  FirebaseUser usuarioFirebase() => _user;
  currentUser() => _usuario;
  List<DocumentSnapshot> getTiendas() => tiendas;
  DocumentSnapshot getDocument() => document;
  List<DocumentSnapshot> getPedidosPendientes() => pedidosPendientes;
  List<DocumentSnapshot> getProductos() => listProducto;
  List<DocumentSnapshot> getPedidos() => listPedido;
  List<DocumentSnapshot> getDirecciones() => listDireccion;

  bool isLoggedIn() => _loggedIn;
  bool isLoading() => _loading;
  bool isLoadData() => _isLoadData;
  bool isComplete() => _isComplete;

  void loginState() async {
    _prefs = await SharedPreferences.getInstance();
    if (_prefs.containsKey("isLoggedIn")) {
      _user = await _auth.currentUser();
      cargarDatosUser();
      _loggedIn = _user != null;
      _loading = false;
      notifyListeners();
    } else {
      _loading = false;
      notifyListeners();
    }
  }

  void createState() async {
    _prefs = await SharedPreferences.getInstance();
    if (_prefs.containsKey("isCreated")) {
      _user = await _auth.currentUser();
      _isCreated =
          (await getDataDocumentService(_user.email)).data["email"] != null;
      _loading = false;
      notifyListeners();
    } else {
      _loading = false;
      notifyListeners();
    }
  }

  Usuario _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? Usuario(email: user.email) : null;
  }

  Stream<Usuario> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  Future singInWithEmailAndPassword(String email, password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      _user = result.user;
      if (_user == null) {
        _loggedIn = false;
        _loading = false;
        notifyListeners();
      } else {
        _prefs.setBool("isLoggedIn", true);
        cargarDatosUser();
        _loggedIn = true;
        _loading = false;
        notifyListeners();
      }
      return _userFromFirebaseUser(_user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future cargarDatosUser() async {
    _isLoadData = false;
    _loading = true;
    notifyListeners();
    this.tiendas = await getListDocumentTiendasService();
    this.document = await getDataDocumentService(_user.email);
    notifyListeners();
    if (document.data["tipo"].compareTo("Cliente") == 0) {
      this.listProducto = await getListDocumentCarritoService(_user.email);
      this.listPedido = await getListDocumentPedidosService(_user.email);
      this.listDireccion = await getListDocumentDireccionService(_user.email);
      ListProducto carrito = crearListaProductos(listProducto);
      ListPedido pedidos = new ListPedido();
      if (listPedido != null) {
        List<Pedido> listaPedidos = new List<Pedido>();
        for (int i = 0; i < listPedido.length; i++) {
          List<DocumentSnapshot> listDocumentProducto =
              await getListDocumentProductosPedidoService(
                  _user.email, listPedido[i].documentID);
          Pedido pedido = Pedido.carga(
              listPedido[i].documentID,
              listPedido[i].data["Medio de Pago"],
              listPedido[i].data["Tienda"],
              listPedido[i].data[_user.email],
              listPedido[i].data["nombreTienda"],
              listPedido[i].data["Costo de Envío"],
              listPedido[i].data["Total Pagado"],
              listPedido[i].data["PorAceptar"],
              listPedido[i].data["PorEntregar"],
              DateTime.parse(listPedido[i].data["Fecha"]),
              listPedido[i].data["HoraEntrega"] == null
                  ? null
                  : DateTime.parse(listPedido[i].data["HoraEntrega"]),
              crearListaProductos(listDocumentProducto));
          listaPedidos.add(pedido);
        }
        pedidos = new ListPedido.carga(listaPedidos);
      }
      ListDireccion direcciones = crearListaDireccion(listDireccion);
      Cliente cliente = new Cliente.carga(
          document.data["Rut"],
          document.data["nombre"],
          document.data["tipo"],
          document.data["email"],
          document.data["password"],
          document.data["codigoVerificación"], //codigoVerificacion
          document.data["codigo"], //invitación
          document.data["Direccion"], //idDireccion
          direcciones, //listDireccion
          null, //historialCompra
          pedidos, //pedidosPendientes
          carrito); //carritoDeCompra
      _usuario = cliente;
      _prefs.setBool("isCreated", true);
    } else if (document.data["tipo"].compareTo("Delivery") == 0) {
      Delivery delivery = new Delivery.carga(
          document.data["Rut"],
          document.data["nombre"],
          document.data["tipo"],
          document.data["email"],
          document.data["password"],
          null, //codigoVerificacion
          document.data["codigo"],
          document.data["transporte"],
          document.data["numero"],
          null, //pedidosPorTomar
          null, //listPedidosEntregados
          null); //pedidoActual
      _usuario = delivery;
      _prefs.setBool("isCreated", true);
    } else {
      this.listProducto = await getListDocumentProductoService(_user.email);
      ListProducto productos = crearListaProductos(listProducto);
      Tienda tienda = new Tienda.carga(
          document.data["patente"],
          document.data["nombre"],
          document.data["tipo"],
          document.data["email"],
          document.data["password"],
          null, //codigoVerificacion
          null, //codigoDeInvitacion
          null, //direccion
          productos, //listProducto
          null, //listVenta
          null, //listPedidoPendiente
          null); //verificado
      _usuario = tienda;
      _prefs.setBool("isCreated", true);
    }
    _isComplete = true;
    _isLoadData = true;
    _loading = false;
    notifyListeners();
  }

  Future registerWithEmailAndPassword(String email, password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _user = result.user;
      return _userFromFirebaseUser(_user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      _prefs.clear();
      _loggedIn = false;
      notifyListeners();
      return _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> actualizarPendientes() async {
    this.listPedido = await getListDocumentPedidosService(_user.email);
    ListPedido pedidos = new ListPedido();
    if (listPedido != null) {
      List<Pedido> listaPedidos = new List<Pedido>();
      for (int i = 0; i < listPedido.length; i++) {
        List<DocumentSnapshot> listDocumentProducto =
            await getListDocumentProductosPedidoService(
                _user.email, listPedido[i].documentID);
        Pedido pedido = Pedido.carga(
            listPedido[i].documentID,
            listPedido[i].data["Medio de Pago"],
            listPedido[i].data["Tienda"],
            listPedido[i].data[_user.email],
            listPedido[i].data["nombreTienda"],
            listPedido[i].data["Costo de Envío"],
            listPedido[i].data["Total Pagado"],
            listPedido[i].data["PorAceptar"],
            listPedido[i].data["PorEntregar"],
            DateTime.parse(listPedido[i].data["Fecha"]),
            listPedido[i].data["HoraEntrega"] == null
                ? null
                : DateTime.parse(listPedido[i].data["HoraEntrega"]),
            crearListaProductos(listDocumentProducto));
        listaPedidos.add(pedido);
      }
      pedidos = new ListPedido.carga(listaPedidos);
    }
    _usuario.setPedidosPendientes(pedidos);
    notifyListeners();
  }

  Future<void> actualizarTiendas() async {
    tiendas = await getListDocumentTiendasService();
  }

  Future<void> actualizarProductosTienda(String id) async {
    listProducto = await getListDocumentProductoService(id);
  }

  ListProducto crearListaProductos(List<DocumentSnapshot> listDocument) {
    List<Producto> listProductos = new List<Producto>();
    int i;
    if (listDocument != null) {
      for (i = 0; i < listDocument.length; i++) {
        DocumentSnapshot document = listDocument[i];
        Producto producto = new Producto.carga(
            document.documentID,
            document.data["Codigo"],
            document.data["Tienda"],
            document.data["nombreTienda"],
            document.data["Nombre"],
            document.data["Categoria"],
            int.parse(document.data["Cantidad"]),
            int.parse(document.data["Precio"]),
            int.parse(document.data["Stock"]),
            int.parse(document.data["StockReservado"]),
            double.parse(document.data["Mg/u"]));
        listProductos.add(producto);
      }
    }
    return ListProducto.carga(listProductos);
  }

  ListDireccion crearListaDireccion(List<DocumentSnapshot> listDireccion) {
    List<Direccion> listDirecciones = new List<Direccion>();
    int i;
    if (listDireccion != null) {
      for (i = 0; i < listDireccion.length; i++) {
        DocumentSnapshot document = listDireccion[i];
        Direccion direccion = new Direccion.carga(
            document.documentID,
            document.data["calle"],
            document.data["depto"],
            document.data["ciudad"],
            document.data["provincia"],
            document.data["country"],
            document.data["region"],
            document.data["codigoPostal"],
            document.data["numero"],
            document.data["lat"],
            document.data["lng"]);
        listDirecciones.add(direccion);
      }
    }
    return ListDireccion.carga(listDirecciones);
  }
}
