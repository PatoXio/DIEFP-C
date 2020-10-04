import 'Usuario.dart';

class ListUsuario {
  List<Usuario> listUsuario;

  ListUsuario() {
    listUsuario = new List<Usuario>();
  }

  ListUsuario.carga(List<Usuario> listUsuario) {
    this.listUsuario = listUsuario;
  }

  List<Usuario> getListUsuario() {
    return listUsuario;
  }

  Usuario getUsuario(String id) {
    int i;
    if (listUsuario != null) {
      for (i = 0; i < listUsuario.length; i++) {
        if (listUsuario.elementAt(i) != null) {
          if (id.compareTo(listUsuario.elementAt(i).getId()) == 0) {
            return listUsuario.elementAt(i);
          }
        }
      }
    }
    return null;
  }

  void setListUsuario(List<Usuario> listUsuario) {
    this.listUsuario = listUsuario;
  }

  void setUsuario(Usuario usuario) {
    listUsuario.add(usuario);
  }
}
