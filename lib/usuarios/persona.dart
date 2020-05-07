import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Persona{

  String nombreCompleto;
  String correo;
  String rut;
  bool delivery;
  bool tienda;
  bool admin;

  Persona(String nombreCompleto, String correo ) {
    this.nombreCompleto = nombreCompleto;
    this.correo = correo;
  }

  String getName(){
    return nombreCompleto;
  }
  String getCorreo(){
    return correo;
  }
}