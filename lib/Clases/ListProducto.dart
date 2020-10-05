import 'Producto.dart';

class ListProducto {
  List<Producto> _listProducto;

  ListProducto() {
    _listProducto = new List<Producto>();
  }

  ListProducto.carga(List<Producto> listProducto) {
    this._listProducto = listProducto;
  }

  List<Producto> getListProducto() {
    return _listProducto;
  }

  Producto getProducto(String id) {
    int i;
    if (_listProducto != null) {
      for (i = 0; i < _listProducto.length; i++) {
        if (_listProducto.elementAt(i) != null) {
          if (_listProducto.elementAt(i).getId().compareTo(id) == 0) {
            return _listProducto.elementAt(i);
          }
        }
      }
    }
    return null;
  }

  void setListProducto(List<Producto> listProducto) {
    this._listProducto = listProducto;
  }

  void setProducto(Producto producto) {
    _listProducto.add(producto);
  }
}
