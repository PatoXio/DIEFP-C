import 'Pedido.dart';

class ListPedido {
  List<Pedido> listPedido;

  ListPedido() {
    listPedido = new List<Pedido>();
  }

  ListPedido.carga(List<Pedido> listPedido) {
    this.listPedido = listPedido;
  }

  List<Pedido> getListPedido() {
    return listPedido;
  }

  Pedido getPedido(String id) {
    int i;
    if (listPedido != null) {
      for (i = 0; i < listPedido.length; i++) {
        if (listPedido.elementAt(i) != null) {
          if (listPedido.elementAt(i).getId().compareTo(id) == 0) {
            return listPedido.elementAt(i);
          }
        }
      }
    }
    return null;
  }

  void setListPedido(List<Pedido> listPedido) {
    this.listPedido = listPedido;
  }

  void setPedido(Pedido pedido) {
    listPedido.add(pedido);
  }
}
