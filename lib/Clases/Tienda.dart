import 'Direccion.dart';
import 'ListPedido.dart';
import 'ListProducto.dart';
import 'Pedido.dart';
import 'Producto.dart';
import 'Usuario.dart';

class Tienda extends Usuario {
  String _patente;
  Direccion _direccion;
  ListProducto _listProducto;
  ListPedido _listPedidoPendiente;
  ListProducto _listVenta;
  bool _verificado;

  Tienda() {
    _patente = null;
    _direccion = new Direccion();
    _listProducto = new ListProducto();
    _listPedidoPendiente = new ListPedido();
    _listVenta = new ListProducto();
    _verificado = false;
  }

  Tienda.carga(
      String patente,
      name,
      tipo,
      email,
      password,
      codigoVerificacion,
      codigoDeInvitacion,
      Direccion direccion,
      ListProducto listProducto,
      listVenta,
      ListPedido listPedidoPendiente,
      bool verificado) {
    setName(name);
    setTipo(tipo);
    setEmail(email);
    setPassword(password);
    setCodigoDeVerificacion(codigoVerificacion);
    setCodigoDeInvitacion(codigoDeInvitacion);
    this._patente = patente;
    this._direccion = direccion;
    this._listProducto = listProducto;
    this._listVenta = listVenta;
    this._listPedidoPendiente = listPedidoPendiente;
    this._verificado = verificado;
  }

  String getPatente() {
    return _patente;
  }

  bool getVerificado() {
    return _verificado;
  }

  Direccion getDireccion() {
    return _direccion;
  }

  ListProducto getListProducto() {
    return _listProducto;
  }

  Producto getProducto(String id) {
    return _listProducto.getProducto(id);
  }

  ListPedido getListPedidosPendientes() {
    return _listPedidoPendiente;
  }

  Pedido getPedidoPendiente(String id) {
    return _listPedidoPendiente.getPedido(id);
  }

  ListProducto getListVenta() {
    return _listVenta;
  }

  Producto getProductoVendido(String id) {
    return _listVenta.getProducto(id);
  }

  void setPatente(String patente) {
    this._patente = patente;
  }

  void setDireccion(Direccion direccion) {
    this._direccion = direccion;
  }

  void setListProducto(ListProducto listProducto) {
    this._listProducto = listProducto;
  }

  void setProducto(Producto producto) {
    _listProducto.setProducto(producto);
  }

  void setVerificado(bool verificado) {
    this._verificado = verificado;
  }

  void setListPedidoPendiente(ListPedido listPedidoPendiente) {
    this._listPedidoPendiente = listPedidoPendiente;
  }

  void setPedidoPendiente(Pedido pedidoPendiente) {
    _listPedidoPendiente.setPedido(pedidoPendiente);
  }

  void setListVenta(ListProducto listVenta) {
    this._listVenta = listVenta;
  }

  void setProductoVendido(Producto producto) {
    _listVenta.setProducto(producto);
  }
}
