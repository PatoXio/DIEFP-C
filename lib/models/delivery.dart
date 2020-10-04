//import 'package:flutter/material.dart';

class Delivery {
  String nombreCompleto;
  String correo;
  String contrasena;
  String rut;
  String numero;
  String codigoInvitacion;
  String ciudad;
  String codigoVerificacion;
  String transporte;
  bool delivery;
  bool tienda;
  bool admin;

  Delivery(
      {this.nombreCompleto,
      this.correo,
      this.numero,
      this.codigoInvitacion,
      this.codigoVerificacion,
      this.ciudad,
      this.transporte,
      this.contrasena,
      this.rut,
      this.delivery = true,
      this.tienda = false,
      this.admin = false});
}
