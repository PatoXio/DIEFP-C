import 'Direccion.dart';

class ListDireccion {
  List<Direccion> _listDireccion;

  ListDireccion() {
    _listDireccion = new List<Direccion>();
  }

  ListDireccion.carga(List<Direccion> listDireccion) {
    this._listDireccion = listDireccion;
  }

  List<Direccion> getListDireccion() {
    return _listDireccion;
  }

  Direccion getDireccion(String idDireccion) {
    int i;
    if (_listDireccion != null) {
      for (i = 0; i < _listDireccion.length; i++) {
        if (_listDireccion.elementAt(i) != null) {
          if (_listDireccion
                  .elementAt(i)
                  .getId()
                  .toString()
                  .compareTo(idDireccion) ==
              0) {
            return _listDireccion.elementAt(i);
          }
        }
      }
    }
    return null;
  }

  void setListDireccion(List<Direccion> listDireccion) {
    this._listDireccion = listDireccion;
  }

  void setDireccion(Direccion direccion) {
    this._listDireccion.add(direccion);
  }

  String getDireccionIdLibre() {
    int i;
    if (_listDireccion.length == 0) return "0";
    for (i = 0; i < _listDireccion.length; i++) {
      if (_listDireccion[i].getId() == null) {
        return i.toString();
      }
    }
    return (_listDireccion.length).toString();
  }

  void deleteDireccion(String id) {
    int i;
    for (i = 0; i < _listDireccion.length; i++) {
      if (_listDireccion[i].getId().compareTo(id) == 0) {
        _listDireccion.removeAt(i);
      }
    }
  }
}
