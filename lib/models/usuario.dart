//import 'package:flutter/material.dart';

class User {
  String nombreCompleto;
  String correo;
  String contrasena;
  String rut;
  bool delivery;
  bool tienda;
  bool admin;
  User({
    this.nombreCompleto,
    this.correo,
    this.contrasena,
    this.rut,
    this.delivery = false,
    this.tienda = false,
    this.admin = false
  });
}