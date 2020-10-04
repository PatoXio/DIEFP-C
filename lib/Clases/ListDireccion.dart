import 'Direccion.dart';

class ListDireccion {
  List<Direccion> listDireccion;

  ListDireccion() {
    listDireccion = new List<Direccion>();
  }

  ListDireccion.carga(List<Direccion> listDireccion) {
    this.listDireccion = listDireccion;
  }

  List<Direccion> getListDireccion() {
    return listDireccion;
  }

  Direccion getDireccion(int idDireccion) {
    int i;
    if (listDireccion != null) {
      for (i = 0; i < listDireccion.length; i++) {
        if (listDireccion.elementAt(i) != null) {
          if (listDireccion.elementAt(i).getId() == idDireccion) {
            return listDireccion.elementAt(i);
          }
        }
      }
    }
    return null;
  }

  void setListDireccion(List<Direccion> listDireccion) {
    this.listDireccion = listDireccion;
  }

  void setDireccion(Direccion direccion) {
    listDireccion.add(direccion);
  }
}
