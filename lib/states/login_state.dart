import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;

class LoginState with ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn( );
  final FirebaseAuth _auth = FirebaseAuth.instance;
  SharedPreferences _prefs;
  DocumentSnapshot document;
  FirebaseUser _user;

  bool _isComplete = false;
  bool _isCreate = false;
  bool _loggedIn = false;
  bool _loading = true;

  LoginState(){
    loginState();
  }

  bool isComplete() => _isComplete;

  bool isCreate() => _isCreate;

  bool isLoggedIn() => _loggedIn;

  bool isLoading() => _loading;

  FirebaseUser currentUser() => _user;

  void Complete(){
    _isComplete = true;
  }

  void login() async {
    _loading = true;
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
      if(!document.exists){
        _loading = true;
        _createUser(_user);
        _isCreate = true;
        _loading = false;
        notifyListeners();
      }else {
        _isCreate = true;
        _loading = false;
        notifyListeners();
      }
    } else {
      _loggedIn = false;
      _loading = false;
      notifyListeners();
    }
    if(document.data["Rut"] != null){
      _isComplete = true;
      notifyListeners();
    }
  }
  void logout() {
    _prefs.clear();
    _googleSignIn.signOut();
    _loggedIn = false;
    notifyListeners( );
  }

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn( );
    final GoogleSignInAuthentication googleAuth = await googleUser
        .authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = (await _auth.signInWithCredential( credential )).user;
    return user;
  }
  
  void _createUser(FirebaseUser _user){
    Firestore.instance
        .collection('usuarios')
        .document(_user.uid)
        .setData({
      "nombre": _user.displayName,
      "email": _user.email,
    });
  }
  
  Future<DocumentSnapshot> _getDocument(String id) async{
    DocumentSnapshot document;
    document = await Firestore.instance
        .collection("usuarios")
        .document(id)
        .get();

    return document;
  }

  void loginState() async {
    _prefs = await SharedPreferences.getInstance();
    if(_prefs.containsKey("isLoggedIn")){
      _user = await _auth.currentUser();
      _loggedIn = _user != null;
      _loading = false;
      notifyListeners();
    }else{
      _loading = false;
      notifyListeners();
    }
  }
}
