import 'ListPedido.dart';
import 'Pedido.dart';
import 'Pedido.dart';
import 'Usuario.dart';

class Delivery extends Usuario {
  String rut;
  int telefono;
  String medioDeTransporte;
  ListPedido pedidosPorTomar;
  Pedido pedidoActual;
  ListPedido listPedidoEntregado;

  Delivery() {
    rut = null;
    telefono = 0;
    medioDeTransporte = null;
    pedidosPorTomar = new ListPedido();
    pedidoActual = new Pedido();
    listPedidoEntregado = new ListPedido();
  }

  Delivery.carga(String rut, medioDeTransporte, int telefono,
      ListPedido pedidosPorTomar, listPedidoEntregado, Pedido pedidoActual) {
    this.rut = rut;
    this.telefono = telefono;
    this.medioDeTransporte = medioDeTransporte;
    this.pedidosPorTomar = pedidosPorTomar;
    this.pedidoActual = pedidoActual;
    this.listPedidoEntregado = listPedidoEntregado;
  }

  String getRut() {
    return rut;
  }

  int getTelefono() {
    return telefono;
  }

  String getMedioDeTransporte() {
    return medioDeTransporte;
  }

  ListPedido getPedidosPorTomar() {
    return pedidosPorTomar;
  }

  Pedido getPedidoPorTomar(String id) {
    return listPedidoEntregado.getPedido(id);
  }

  Pedido getPedidoActual() {
    return pedidoActual;
  }

  ListPedido getPedidosEntregados() {
    return listPedidoEntregado;
  }

  Pedido getPedidoEntregado(String id) {
    return listPedidoEntregado.getPedido(id);
  }

  void setRut(String rut) {
    this.rut = rut;
  }

  void setTelefono(int telefono) {
    this.telefono = telefono;
  }

  void setMedioDeTransporte(String medioDeTransporte) {
    this.medioDeTransporte = medioDeTransporte;
  }

  void setPedidosPorTomar(ListPedido pedidosPorTomar) {
    this.pedidosPorTomar = pedidosPorTomar;
  }

  void setPedidoPorTomar(Pedido pedido) {
    pedidosPorTomar.setPedido(pedido);
  }

  void setPedidoActual(Pedido pedidoActual) {
    this.pedidoActual = pedidoActual;
  }

  void setPedidosEntregados(ListPedido listPedidoEntregado) {
    this.listPedidoEntregado = listPedidoEntregado;
  }

  void setPedidoEntregado(Pedido pedido) {
    listPedidoEntregado.setPedido(pedido);
  }
}
