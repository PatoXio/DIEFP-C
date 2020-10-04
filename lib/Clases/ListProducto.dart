import 'Producto.dart';

class ListProducto {
  List<Producto> listProducto;

  ListProducto() {
    listProducto = new List<Producto>();
  }

  ListProducto.carga(List<Producto> listProducto) {
    this.listProducto = listProducto;
  }

  List<Producto> getListProducto() {
    return listProducto;
  }

  Producto getProducto(String id) {
    int i;
    if (listProducto != null) {
      for (i = 0; i < listProducto.length; i++) {
        if (listProducto.elementAt(i) != null) {
          if (listProducto.elementAt(i).getId().compareTo(id) == 0) {
            return listProducto.elementAt(i);
          }
        }
      }
    }
    return null;
  }

  void setListProducto(List<Producto> listProducto) {
    this.listProducto = listProducto;
  }

  void setProducto(Producto producto) {
    listProducto.add(producto);
  }
}
