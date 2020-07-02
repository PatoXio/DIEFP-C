//import 'package:flutter/material.dart';

class Tienda {
  String nombreCompleto;
  String correo;
  String contrasena;
  String rut;
  int numero;
  String patente;
  String codigo;
  String codigoVerificacion;
  String ciudad;
  bool delivery;
  bool tienda;
  bool admin;
  Tienda({
    this.nombreCompleto,
    this.correo,
    this.patente,
    this.numero,
    this.codigo,
    this.codigoVerificacion,
    this.ciudad,
    this.contrasena,
    this.rut,
    this.delivery = true,
    this.tienda = false,
    this.admin = false
  });
}