class Direccion {
  int _id;
  String _calle;
  bool _casa;
  String _ciudad;
  String _region;
  int _codigoPostal;
  int _numero;

  Direccion() {
    _id = -1;
    _calle = null;
    _casa = false;
    _ciudad = null;
    _region = null;
    _codigoPostal = -1;
    _numero = -1;
  }

  Direccion.carga(
      int id, codigoPostal, numero, String calle, ciudad, region, bool casa) {
    this._id = id;
    this._calle = calle;
    this._casa = casa;
    this._ciudad = ciudad;
    this._region = region;
    this._codigoPostal = codigoPostal;
    this._numero = numero;
  }

  int getId() {
    return _id;
  }

  String getDireccion() {
    return _region + ', ' + _ciudad + ', ' + _calle + ', ' + _numero.toString();
  }

  int getCodigoPostal() {
    return _codigoPostal;
  }

  void setId(int id) {
    this._id = id;
  }

  void setCalle(String calle) {
    this._calle = calle;
  }

  void setCasa(bool casa) {
    this._casa = casa;
  }

  void setCiudad(String ciudad) {
    this._ciudad = ciudad;
  }

  void setRegion(String region) {
    this._region = region;
  }

  void setCodigoPostal(int codigoPostal) {
    this._codigoPostal = codigoPostal;
  }

  void setNumero(int numero) {
    this._numero = numero;
  }
}
