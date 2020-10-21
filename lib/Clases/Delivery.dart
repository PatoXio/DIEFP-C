import 'ListPedido.dart';
import 'Pedido.dart';
import 'Usuario.dart';

class Delivery extends Usuario {
  String _rut;
  String _telefono;
  String _medioDeTransporte;
  ListPedido _pedidosPorTomar;
  Pedido _pedidoActual;
  ListPedido _listPedidoEntregado;

  Delivery() {
    _rut = null;
    _telefono = null;
    _medioDeTransporte = null;
    _pedidosPorTomar = new ListPedido();
    _pedidoActual = new Pedido();
    _listPedidoEntregado = new ListPedido();
  }

  Delivery.carga(
      String rut,
      name,
      tipo,
      email,
      password,
      codigoVerificacion,
      codigoDeInvitacion,
      medioDeTransporte,
      telefono,
      ListPedido pedidosPorTomar,
      listPedidoEntregado,
      Pedido pedidoActual) {
    setName(name);
    setTipo(tipo);
    setEmail(email);
    setPassword(password);
    setCodigoDeVerificacion(codigoVerificacion);
    setCodigoDeInvitacion(codigoDeInvitacion);
    this._rut = rut;
    this._telefono = telefono;
    this._medioDeTransporte = medioDeTransporte;
    this._pedidosPorTomar = pedidosPorTomar;
    this._pedidoActual = pedidoActual;
    this._listPedidoEntregado = listPedidoEntregado;
  }

  String getRut() {
    return _rut;
  }

  String getTelefono() {
    return _telefono;
  }

  String getMedioDeTransporte() {
    return _medioDeTransporte;
  }

  ListPedido getPedidosPorTomar() {
    return _pedidosPorTomar;
  }

  Pedido getPedidoPorTomar(String id) {
    return _listPedidoEntregado.getPedido(id);
  }

  Pedido getPedidoActual() {
    return _pedidoActual;
  }

  ListPedido getPedidosEntregados() {
    return _listPedidoEntregado;
  }

  Pedido getPedidoEntregado(String id) {
    return _listPedidoEntregado.getPedido(id);
  }

  void setRut(String rut) {
    this._rut = rut;
  }

  void setTelefono(String telefono) {
    this._telefono = telefono;
  }

  void setMedioDeTransporte(String medioDeTransporte) {
    this._medioDeTransporte = medioDeTransporte;
  }

  void setPedidosPorTomar(ListPedido pedidosPorTomar) {
    this._pedidosPorTomar = pedidosPorTomar;
  }

  void setPedidoPorTomar(Pedido pedido) {
    _pedidosPorTomar.setPedido(pedido);
  }

  void setPedidoActual(Pedido pedidoActual) {
    this._pedidoActual = pedidoActual;
  }

  void setPedidosEntregados(ListPedido listPedidoEntregado) {
    this._listPedidoEntregado = listPedidoEntregado;
  }

  void setPedidoEntregado(Pedido pedido) {
    _listPedidoEntregado.setPedido(pedido);
  }
}
