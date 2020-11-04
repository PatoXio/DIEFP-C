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
          if (_listProducto.elementAt(i).getId() != null) {
            if (_listProducto.elementAt(i).getId().compareTo(id) == 0) {
              return _listProducto.elementAt(i);
            }
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
    if (getProducto(producto.getCodigo()) == null) _listProducto.add(producto);
  }

  bool eliminarProducto(String id) {
    return _listProducto.remove(getProducto(id));
  }

  bool editProducto(Producto producto) {
    if (getProducto(producto.getCodigo()) != null) {
      if (eliminarProducto(producto.getCodigo()) == true) {
        setProducto(producto);
        return true;
      }
    }
    return false;
  }
}
