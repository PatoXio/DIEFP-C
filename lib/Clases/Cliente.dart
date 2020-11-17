import 'Direccion.dart';
import 'ListDireccion.dart';
import 'ListPedido.dart';
import 'ListProducto.dart';
import 'Pedido.dart';
import 'Producto.dart';
import 'Usuario.dart';

class Cliente extends Usuario {
  String _rut;
  String _idDireccion;
  ListDireccion _listDireccion;
  ListPedido _historialCompra;
  ListProducto _carritoDeCompra;
  ListPedido _pedidosPendientes;

  Cliente() {
    _rut = null;
    _idDireccion = null;
    _listDireccion = new ListDireccion();
    _historialCompra = new ListPedido();
    _carritoDeCompra = new ListProducto();
    _pedidosPendientes = new ListPedido();
  }

  Cliente.carga(
      String rut,
      name,
      tipo,
      email,
      password,
      codigoVerificacion,
      codigoDeInvitacion,
      idDireccion,
      ListDireccion listDireccion,
      ListPedido historialCompra,
      pedidosPendientes,
      ListProducto carritoDeCompra) {
    setName(name);
    setTipo(tipo);
    setEmail(email);
    setPassword(password);
    setCodigoDeVerificacion(codigoVerificacion);
    setCodigoDeInvitacion(codigoDeInvitacion);
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

  String getIdDireccion() {
    return _idDireccion;
  }

  ListDireccion getListDireccion() {
    return _listDireccion;
  }

  Direccion getDireccionEspecifica(String id) {
    return _listDireccion.getDireccion(id);
  }

  Direccion getDireccion() {
    if (_idDireccion != null) return _listDireccion.getDireccion(_idDireccion);
    if (_idDireccion == null && _listDireccion.getListDireccion().isNotEmpty) {
      _idDireccion = _listDireccion.getListDireccion().first.getId();
      return _listDireccion.getDireccion(_idDireccion);
    }
    return null;
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

  String getDireccionIdLibre() {
    return _listDireccion.getDireccionIdLibre();
  }

  Producto getProductoDeCarrito(String codigo) {
    return _carritoDeCompra.getProducto(codigo);
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

  void setIdDireccion(String idDireccion) {
    this._idDireccion = idDireccion;
  }

  void setListDireccion(ListDireccion listDireccion) {
    this._listDireccion = listDireccion;
  }

  void setDireccion(Direccion direccion) {
    this._listDireccion.setDireccion(direccion);
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

  void setHistorialDeCompras(ListPedido historialCompra) {
    this._historialCompra = historialCompra;
  }

  void setCompra(Pedido pedido) {
    _historialCompra.setPedido(pedido);
  }

  bool deleteProductoDeCarrito(String codigo) {
    return _carritoDeCompra.eliminarProducto(codigo);
  }

  void deleteCarrito() {
    _carritoDeCompra = new ListProducto();
  }

  void deleteDireccion(String id) {
    _listDireccion.deleteDireccion(id);
  }
}
