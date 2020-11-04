import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginState with ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _nombreTienda;
  SharedPreferences _prefs;
  DocumentSnapshot document;
  DocumentSnapshot _producto;
  FirebaseUser _user;
  List<DocumentSnapshot> _carrito;
  List<DocumentSnapshot> _productos;
  Stream<QuerySnapshot> _tiendas;
  List<DocumentSnapshot> _productosTienda;
  List<DocumentSnapshot> _historial;
  List<DocumentSnapshot> _historialPendiente;
  List<DocumentSnapshot> _pedidosPendientes;
  List<DocumentSnapshot> _historialProductos;

  String _rol = 'Normal';
  bool _isComplete = false;
  bool _isCreate = false;
  bool _loggedIn = false;
  bool _loading = true;

  /*LoginState() {
    loginState();
  }*/

  bool isCreate() => _isCreate;

  bool isLoggedIn() => _loggedIn;

  bool isLoading() => _loading;

  String getRol() => _rol;

  FirebaseUser currentUser() => _user;

  DocumentSnapshot getDocument() => document;

  DocumentSnapshot getProducto() => _producto;

  List<DocumentSnapshot> getCarrito() => _carrito;

  String getNombreTienda() => _nombreTienda;

  List<DocumentSnapshot> getHistorial() => _historial;

  List<DocumentSnapshot> getProductos() => _productos;

  Stream<QuerySnapshot> getTiendas() => _tiendas;

  List<DocumentSnapshot> getProductosTienda() => _productosTienda;

  List<DocumentSnapshot> getHistorialPendientes() => _historialPendiente;

  List<DocumentSnapshot> getPedidosPendientes() => _pedidosPendientes;

  List<DocumentSnapshot> getHistorialProductos() => _historialProductos;

  bool isComplete() {
    createState();
    return _isComplete;
  }

  Future<void> nombreTienda(String idTienda) async {
    DocumentSnapshot snapshot = await Firestore.instance
        .collection('usuarios')
        .document(idTienda)
        .get();
    _nombreTienda = snapshot.data["nombre"];
  }

  Future<void> actualizarHistorialProductos(String idDocument) async {
    _historialProductos = await _getListDocumentHistorialProductos(idDocument);
  }

  Future<void> actualizarHistorial() async {
    _historial = await _getListDocumentHistorial(_user.uid);
    _historialPendiente = await _getListDocumentHistorialPendientes(_user.uid);
  }

  Future<void> actualizarPendientes() async {
    _pedidosPendientes = await _getListDocumentPedidosPendientes(_user.uid);
  }

  Future<void> actualizarTiendas() async {
    _tiendas = await _getListDocumentTiendas();
  }

  Future<void> actualizarCarrito() async {
    _carrito = await _getListDocumentCarrito(_user.uid);
  }

  Future<void> actualizarProductos() async {
    _productos = await _getListDocumentProducto(_user.uid);
  }

  Future<void> actualizarProducto(String id) async {
    _producto = await _getDocumentSnapshot(id);
  }

  Future<void> verProductosTienda(String id) async {
    _productosTienda = await _getListDocumentProducto(id);
  }

  void login() async {
    _loading = true;
    _producto = null;
    notifyListeners();

    _user = await _handleSignIn();
    if (_user != null) {
      _prefs.setBool("isLoggedIn", true);
      _loggedIn = true;
      _loading = false;
      notifyListeners();
      _loading = true;
      notifyListeners();
      document = await _getDocument(_user.uid);
      if (!document.exists) {
        _loading = true;
        _createUser(_user);
        _isCreate = true;
        _loading = false;
        notifyListeners();
      } else {
        _isCreate = true;
        _loading = false;
        notifyListeners();
      }
    } else {
      _loggedIn = false;
      _loading = false;
      notifyListeners();
    }
    if (document.data["Rut"] != null) {
      _prefs.setBool("isCreated", true);
      _isComplete = true;
      _loading = true;
      _carrito = await _getListDocumentCarrito(_user.uid);
      _rol = await _getRol(_user.uid, _rol);
      _productos = await _getListDocumentProducto(_user.uid);
      _historial = await _getListDocumentHistorial(_user.uid);
      _historialPendiente =
          await _getListDocumentHistorialPendientes(_user.uid);
      _pedidosPendientes = await _getListDocumentPedidosPendientes(_user.uid);
      _loading = false;
      notifyListeners();
    }
  }

  void logout() {
    _prefs.clear();
    _googleSignIn.signOut();
    _loggedIn = false;
    notifyListeners();
  }

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    return user;
  }

  void _createUser(FirebaseUser _user) {
    Firestore.instance.collection('usuarios').document(_user.uid).setData({
      "nombre": _user.displayName,
      "email": _user.email,
    });
  }

  Future<DocumentSnapshot> _getDocument(String id) async {
    DocumentSnapshot document;
    document =
        await Firestore.instance.collection("usuarios").document(id).get();

    return document;
  }

  Future<Stream<QuerySnapshot>> _getListDocumentTiendas() async {
    Stream<QuerySnapshot> listDocument;
    listDocument = await Firestore.instance
        .collection('usuarios')
        .where("tipo", isEqualTo: "Tienda")
        .snapshots();

    return listDocument;
  }

  Future<String> _getRol(String uid, String _rol) async {
    DocumentSnapshot document = await _getDocument(uid);
    if (document.data["Delivery"] == true)
      return "Delivery";
    else if (document.data["Tienda"] == true)
      return "Tienda";
    else
      return _rol;
  }

  Future<List<DocumentSnapshot>> _getListDocumentCarrito(String id) async {
    List<DocumentSnapshot> listDocument;
    listDocument = (await Firestore.instance
            .collection("usuarios")
            .document(id)
            .collection("Carrito")
            .getDocuments())
        .documents;

    return listDocument;
  }

  Future<List<DocumentSnapshot>> _getListDocumentProducto(String id) async {
    List<DocumentSnapshot> listDocument;
    listDocument = (await Firestore.instance
            .collection("usuarios")
            .document(id)
            .collection("Productos")
            .getDocuments())
        .documents;

    return listDocument;
  }

  Future<DocumentSnapshot> _getDocumentSnapshot(String id) async {
    Future<DocumentSnapshot> Document;
    Document = (await Firestore.instance
            .collection("usuarios")
            .document(_user.uid)
            .collection("Productos")
            .document(id))
        .get();

    return Document;
  }

  Future<List<DocumentSnapshot>> _getListDocumentHistorial(String id) async {
    List<DocumentSnapshot> listDocument;
    listDocument = (await Firestore.instance
            .collection("usuarios")
            .document(id)
            .collection("Historial")
            .getDocuments())
        .documents;

    return listDocument;
  }

  Future<List<DocumentSnapshot>> _getListDocumentHistorialProductos(
      String idDocument) async {
    List<DocumentSnapshot> listDocument;
    listDocument = (await Firestore.instance
            .collection("usuarios")
            .document(_user.uid)
            .collection("Historial")
            .document(idDocument)
            .collection('ComprasRealizada')
            .getDocuments())
        .documents;

    return listDocument;
  }

  Future<List<DocumentSnapshot>> _getListDocumentHistorialPendientes(
      String id) async {
    List<DocumentSnapshot> listDocument;
    listDocument = (await Firestore.instance
            .collection("usuarios")
            .document(id)
            .collection("Historial")
            .where("Entregado", isEqualTo: false)
            .getDocuments())
        .documents;

    return listDocument;
  }

  Future<List<DocumentSnapshot>> _getListDocumentPedidosPendientes(
      String id) async {
    List<DocumentSnapshot> listDocument;

    return listDocument;
  }

  /*void loginState() async {
    _prefs = await SharedPreferences.getInstance();
    if (_prefs.containsKey("isLoggedIn")) {
      _user = await _auth.currentUser();
      _loggedIn = _user != null;
      _loading = false;
      notifyListeners();
    } else {
      _loading = false;
      notifyListeners();
    }
  }*/

  void createState() async {
    _prefs = await SharedPreferences.getInstance();
    if (_prefs.containsKey("isCreated")) {
      _user = await _auth.currentUser();
      _isComplete = (await _getDocument(_user.uid)).data["Rut"] != null;
      _loading = false;
      notifyListeners();
    } else {
      _loading = false;
      notifyListeners();
    }
  }

  void borrarProducto() {
    _producto = null;
  }
}
