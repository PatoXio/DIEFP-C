class Usuario {
  String _name;
  String email;
  String _password;
  String _codigoVerificacion;
  String _codigoDeInvitacion;
  String _tipo;

  Usuario({String email}) {
    _name = null;
    this.email = email;
    _password = null;
    _codigoVerificacion = null;
    _codigoDeInvitacion = null;
    _tipo = null;
  }
  Usuario.carga(String name, tipo, email, password, codigoVerificacion,
      codigoDeInvitacion) {
    this._name = name;
    this.email = email;
    this._password = password;
    this._codigoVerificacion = codigoVerificacion;
    this._codigoDeInvitacion = codigoDeInvitacion;
    this._tipo = tipo;
  }

  String getTipo() {
    return _tipo;
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

  void setTipo(String tipo) {
    this._tipo = tipo;
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
