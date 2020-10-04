import 'ListUsuario.dart';
import 'Usuario.dart';

class DIEFPC {
  String name;
  ListUsuario listUsuario;

  DIEFPC() {
    name = "DIEFPC-C";
    listUsuario = new ListUsuario();
  }

  DIEFPC.carga(ListUsuario listUsuario) {
    name = "Diefp-C";
    this.listUsuario = listUsuario;
  }

  String getNombre() {
    return name;
  }

  ListUsuario getListUsuario() {
    return listUsuario;
  }

  Usuario getUsuario(String rut) {
    if (listUsuario != null) {
      return listUsuario.getUsuario(rut);
    }
    return null;
  }

  void setListUsuario(ListUsuario listUsuario) {
    this.listUsuario = listUsuario;
  }

  void setUsuario(Usuario usuario) {
    listUsuario.setUsuario(usuario);
  }

  bool cargarDatos() {
    return false;
  }
}
