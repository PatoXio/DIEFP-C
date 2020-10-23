import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diefpc/Clases/Cliente.dart';
import 'package:diefpc/Clases/Delivery.dart';
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
  dynamic _usuario;
  DocumentSnapshot document;
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

  dynamic currentUser() => _usuario;
  DocumentSnapshot getDocument() => document;
  FirebaseUser usuarioFirebase() => _user;
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
          (await getDocumentService(_user.email)).data["email"] != null;
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
    this.document = await getDocumentService(_user.email);
    notifyListeners();
    if (document.data["tipo"].compareTo("Cliente") == 0) {
      Cliente cliente = new Cliente.carga(
          document.data["Rut"],
          document.data["nombre"],
          document.data["tipo"],
          document.data["email"],
          document.data["password"],
          null, //codigoVerificacion
          document.data["codigo"],
          null, //idDireccion
          null, //listDireccion
          null, //historialCompra
          null, //pedidosPendientes
          null); //carritoDeCompra
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
      Tienda tienda = new Tienda.carga(
          document.data["patente"],
          document.data["nombre"],
          document.data["tipo"],
          document.data["email"],
          document.data["password"],
          null, //codigoVerificacion
          null, //codigoDeInvitacion
          null, //direccion
          null, //listProducto
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
}
