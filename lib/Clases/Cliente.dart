import 'Direccion.dart';
import 'ListDireccion.dart';
import 'ListPedido.dart';
import 'ListProducto.dart';
import 'Pedido.dart';
import 'Producto.dart';
import 'Usuario.dart';

class Cliente extends Usuario {
  String rut;
  int idDireccion;
  ListDireccion listDireccion;
  ListPedido historialCompra;
  ListProducto carritoDeCompra;
  ListPedido pedidosPendientes;

  Cliente() {
    rut = null;
    idDireccion = -1;
    listDireccion = new ListDireccion();
    historialCompra = new ListPedido();
    carritoDeCompra = new ListProducto();
    pedidosPendientes = new ListPedido();
  }

  Cliente.carga(
      String rut,
      int idDireccion,
      ListDireccion listDireccion,
      ListPedido historialCompra,
      pedidosPendientes,
      ListProducto carritoDeCompra) {
    this.rut = rut;
    this.idDireccion = idDireccion;
    this.listDireccion = listDireccion;
    this.historialCompra = historialCompra;
    this.carritoDeCompra = carritoDeCompra;
    this.pedidosPendientes = pedidosPendientes;
  }

  String getRut() {
    return rut;
  }

  int getIdDireccion() {
    return idDireccion;
  }

  ListDireccion getListDireccion() {
    return listDireccion;
  }

  Direccion getDireccion() {
    return listDireccion.getDireccion(idDireccion);
  }

  ListPedido getHistorialDeCompras() {
    return historialCompra;
  }

  Pedido getCompra(String id) {
    return historialCompra.getPedido(id);
  }

  ListProducto getCarritoDeCompra() {
    return carritoDeCompra;
  }

  ListPedido getPedidosPendientes() {
    return pedidosPendientes;
  }

  Pedido getPedidoPendiente(String id) {
    return pedidosPendientes.getPedido(id);
  }

  void setRut(String rut) {
    this.rut = rut;
  }

  void setIdDireccion(int idDireccion) {
    this.idDireccion = idDireccion;
  }

  void setListDireccion(ListDireccion listDireccion) {
    this.listDireccion = listDireccion;
  }

  void setDireccion(Direccion direccion) {
    listDireccion.setDireccion(direccion);
  }

  void setCarritoDeCompra(ListProducto carritoDeCompra) {
    this.carritoDeCompra = carritoDeCompra;
  }

  void setProductoACarrito(Producto producto) {
    carritoDeCompra.setProducto(producto);
  }

  void setPedidosPendientes(ListPedido pedidosPendientes) {
    this.pedidosPendientes = pedidosPendientes;
  }

  void setPedidoPendiente(Pedido pedido) {
    pedidosPendientes.setPedido(pedido);
  }
}
