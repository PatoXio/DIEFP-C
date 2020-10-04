import 'package:diefpc/screens/pedidosPendientes.dart';

import 'Direccion.dart';
import 'ListPedido.dart';
import 'ListProducto.dart';
import 'Pedido.dart';
import 'Producto.dart';
import 'Usuario.dart';

class Tienda extends Usuario {
  String patente;
  Direccion direccion;
  ListProducto listProducto;
  ListPedido listPedidoPendiente;
  ListProducto listVenta;

  Tienda() {
    patente = null;
    direccion = new Direccion();
    listProducto = new ListProducto();
    listPedidoPendiente = new ListPedido();
    listVenta = new ListProducto();
  }

  Tienda.carga(String patente, Direccion direccion, ListProducto listProducto,
      listVenta, ListPedido listPedidoPendiente) {
    this.patente = patente;
    this.direccion = direccion;
    this.listProducto = listProducto;
    this.listVenta = listVenta;
    this.listPedidoPendiente = listPedidoPendiente;
  }

  String getPatente() {
    return patente;
  }

  Direccion getDireccion() {
    return direccion;
  }

  ListProducto getListProducto() {
    return listProducto;
  }

  Producto getProducto(String id) {
    return listProducto.getProducto(id);
  }

  ListPedido getListPedidosPendientes() {
    return listPedidoPendiente;
  }

  Pedido getPedidoPendiente(String id) {
    return listPedidoPendiente.getPedido(id);
  }

  ListProducto getListVenta() {
    return listVenta;
  }

  Producto getProductoVendido(String id) {
    return listVenta.getProducto(id);
  }

  void setPatente(String patente) {
    this.patente = patente;
  }

  void setDireccion(Direccion direccion) {
    this.direccion = direccion;
  }

  void setListProducto(ListProducto listProducto) {
    this.listProducto = listProducto;
  }

  void setProducto(Producto producto) {
    listProducto.setProducto(producto);
  }

  void setListPedidoPendiente(ListPedido listPedidoPendiente) {
    this.listPedidoPendiente = listPedidoPendiente;
  }

  void setPedidoPendiente(Pedido pedidoPendiente) {
    listPedidoPendiente.setPedido(pedidoPendiente);
  }

  void setListVenta(ListProducto listVenta) {
    this.listVenta = listVenta;
  }

  void setProductoVendido(Producto producto) {
    listVenta.setProducto(producto);
  }
}
