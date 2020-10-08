class Usuario {
  String _id;
  String _name;
  String email;
  String _password;
  String _codigoVerificacion;
  String _codigoDeInvitacion;

  Usuario({String email}) {
    _id = null;
    _name = null;
    email = null;
    _password = null;
    _codigoVerificacion = null;
  }
  Usuario.carga(String id, name, email, password, codigoVerificacion,
      codigoDeInvitacion) {
    this._id = id;
    this._name = name;
    this.email = email;
    this._password = password;
    this._codigoVerificacion = codigoVerificacion;
    this._codigoDeInvitacion = codigoDeInvitacion;
  }

  String getId() {
    return _id;
  }

  String getName() {
    return _name;
  }

  String getEmail() {
    return email;
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
    this.email = email;
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
