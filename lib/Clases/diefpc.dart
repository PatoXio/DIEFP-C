import 'ListUsuario.dart';
import 'Usuario.dart';

class DIEFPC {
  String _name;
  ListUsuario _listUsuario;

  DIEFPC() {
    _name = "DIEFPC-C";
    _listUsuario = new ListUsuario();
  }

  DIEFPC.carga(ListUsuario listUsuario) {
    _name = "Diefp-C";
    this._listUsuario = listUsuario;
  }

  String getNombre() {
    return _name;
  }

  ListUsuario getListUsuario() {
    return _listUsuario;
  }

  Usuario getUsuario(String rut) {
    if (_listUsuario != null) {
      return _listUsuario.getUsuario(rut);
    }
    return null;
  }

  void setListUsuario(ListUsuario listUsuario) {
    this._listUsuario = listUsuario;
  }

  void setUsuario(Usuario usuario) {
    _listUsuario.setUsuario(usuario);
  }

  bool cargarDatos() {
    return false;
  }
}
