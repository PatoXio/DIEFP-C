import 'Pedido.dart';

class ListPedido {
  List<Pedido> _listPedido;

  ListPedido() {
    _listPedido = new List<Pedido>();
  }

  ListPedido.carga(List<Pedido> listPedido) {
    this._listPedido = listPedido;
  }

  List<Pedido> getListPedido() {
    return _listPedido;
  }

  List<Pedido> getPedidosAceptados() {
    List<Pedido> listPedidos = new List<Pedido>();
    int i;
    if (_listPedido != null) {
      for (i = _listPedido.length - 1; i >= 0; i--) {
        if (_listPedido.elementAt(i) != null) {
          if (_listPedido.elementAt(i).getPorAceptar() == false) {
            listPedidos.add(_listPedido.elementAt(i));
          }
        }
      }
    }
    return listPedidos;
  }

  List<Pedido> getPedidosPorAceptar() {
    List<Pedido> listPedidos = new List<Pedido>();
    int i;
    if (_listPedido != null) {
      for (i = 0; i < _listPedido.length; i++) {
        if (_listPedido.elementAt(i) != null) {
          if (_listPedido.elementAt(i).getPorAceptar() == true) {
            listPedidos.add(_listPedido.elementAt(i));
          }
        }
      }
    }
    return listPedidos;
  }

  Pedido getPedido(String id) {
    int i;
    if (_listPedido != null) {
      for (i = 0; i < _listPedido.length; i++) {
        if (_listPedido.elementAt(i) != null) {
          if (_listPedido.elementAt(i).getId().compareTo(id) == 0) {
            return _listPedido.elementAt(i);
          }
        }
      }
    }
    return null;
  }

  void setListPedido(List<Pedido> listPedido) {
    this._listPedido = listPedido;
  }

  void setPedido(Pedido pedido) {
    _listPedido.add(pedido);
  }
}
