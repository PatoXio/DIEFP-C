class Usuario {
  String _id;
  String _name;
  String _email;
  String _password;
  String _codigoVerificacion;
  String _codigoDeInvitacion;

  Usuario() {
    _id = null;
    _name = null;
    _email = null;
    _password = null;
    _codigoVerificacion = null;
  }
  Usuario.carga(String id, name, email, password, codigoVerificacion,
      codigoDeInvitacion) {
    this._id = id;
    this._name = name;
    this._email = email;
    this._password = password;
    this._codigoVerificacion = codigoVerificacion;
    this._codigoDeInvitacion = codigoDeInvitacion;
  }

  String getId() {
    return _id;
  }

  String getname() {
    return _name;
  }

  String getEmail() {
    return _email;
  }

  String getPassword() {
    return _password;
  }

  String getCodigoDeVerificacion() {
    return _codigoVerificacion;
  }

  String getCodigoDeInvitacion() {
    return _codigoDeInvitacion;
  }

  void setId(String id) {
    this._id = id;
  }

  void setName(String name) {
    this._name = name;
  }

  void setEmail(String email) {
    this._email = email;
  }

  void setPassword(String password) {
    this._password = password;
  }

  void setCodigoDeVerificacion(String codigoVerificacion) {
    this._codigoVerificacion = codigoVerificacion;
  }

  void setCodigoDeInvitacion(String codigoDeInvitacion) {
    this._codigoDeInvitacion = codigoDeInvitacion;
  }
}
