import 'Direccion.dart';
import 'ListDireccion.dart';
import 'ListPedido.dart';
import 'ListProducto.dart';
import 'Pedido.dart';
import 'Producto.dart';
import 'Usuario.dart';

class Cliente extends Usuario {
  String _rut;
  int _idDireccion;
  ListDireccion _listDireccion;
  ListPedido _historialCompra;
  ListProducto _carritoDeCompra;
  ListPedido _pedidosPendientes;

  Cliente() {
    _rut = null;
    _idDireccion = -1;
    _listDireccion = new ListDireccion();
    _historialCompra = new ListPedido();
    _carritoDeCompra = new ListProducto();
    _pedidosPendientes = new ListPedido();
  }

  Cliente.carga(
      String rut,
      int idDireccion,
      ListDireccion listDireccion,
      ListPedido historialCompra,
      pedidosPendientes,
      ListProducto carritoDeCompra) {
    this._rut = rut;
    this._idDireccion = idDireccion;
    this._listDireccion = listDireccion;
    this._historialCompra = historialCompra;
    this._carritoDeCompra = carritoDeCompra;
    this._pedidosPendientes = pedidosPendientes;
  }

  String getRut() {
    return _rut;
  }

  int getIdDireccion() {
    return _idDireccion;
  }

  ListDireccion getListDireccion() {
    return _listDireccion;
  }

  Direccion getDireccion() {
    return _listDireccion.getDireccion(_idDireccion);
  }

  ListPedido getHistorialDeCompras() {
    return _historialCompra;
  }

  Pedido getCompra(String id) {
    return _historialCompra.getPedido(id);
  }

  ListProducto getCarritoDeCompra() {
    return _carritoDeCompra;
  }

  ListPedido getPedidosPendientes() {
    return _pedidosPendientes;
  }

  Pedido getPedidoPendiente(String id) {
    return _pedidosPendientes.getPedido(id);
  }

  void setRut(String rut) {
    this._rut = rut;
  }

  void setIdDireccion(int idDireccion) {
    this._idDireccion = idDireccion;
  }

  void setListDireccion(ListDireccion listDireccion) {
    this._listDireccion = listDireccion;
  }

  void setDireccion(Direccion direccion) {
    _listDireccion.setDireccion(direccion);
  }

  void setCarritoDeCompra(ListProducto carritoDeCompra) {
    this._carritoDeCompra = carritoDeCompra;
  }

  void setProductoACarrito(Producto producto) {
    _carritoDeCompra.setProducto(producto);
  }

  void setPedidosPendientes(ListPedido pedidosPendientes) {
    this._pedidosPendientes = pedidosPendientes;
  }

  void setPedidoPendiente(Pedido pedido) {
    _pedidosPendientes.setPedido(pedido);
  }
}
