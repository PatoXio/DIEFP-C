import 'Usuario.dart';

class ListUsuario {
  List<Usuario> _listUsuario;

  ListUsuario() {
    _listUsuario = new List<Usuario>();
  }

  ListUsuario.carga(List<Usuario> listUsuario) {
    this._listUsuario = listUsuario;
  }

  List<Usuario> getListUsuario() {
    return _listUsuario;
  }

  Usuario getUsuario(String email) {
    int i;
    if (_listUsuario != null) {
      for (i = 0; i < _listUsuario.length; i++) {
        if (_listUsuario.elementAt(i) != null) {
          if (email.compareTo(_listUsuario.elementAt(i).getEmail()) == 0) {
            return _listUsuario.elementAt(i);
          }
        }
      }
    }
    return null;
  }

  void setListUsuario(List<Usuario> listUsuario) {
    this._listUsuario = listUsuario;
  }

  void setUsuario(Usuario usuario) {
    _listUsuario.add(usuario);
  }
}
