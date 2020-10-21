class Direccion {
  int _id;
  String _calle;
  String _depto;
  String _ciudad;
  String _provincia;
  String _country;
  String _region;
  String _codigoPostal;
  String _numero;
  double _lat;
  double _lng;

  Direccion() {
    _id = -1;
    _calle = null;
    _depto = null;
    _ciudad = null;
    _provincia = null;
    _country = null;
    _region = null;
    _codigoPostal = null;
    _numero = null;
    _lat = 0;
    _lng = 0;
  }

  Direccion.carga(
    int _id,
    String _calle,
    String _depto,
    String _ciudad,
    String _provincia,
    String _country,
    String _region,
    String _codigoPostal,
    String _numero,
    double _lat,
    double _lng,
  ) {
    this._id = _id;
    this._calle = _calle;
    this._depto = _depto;
    this._ciudad = _ciudad;
    this._provincia = _provincia;
    this._country = _country;
    this._region = _region;
    this._codigoPostal = _codigoPostal;
    this._numero = _numero;
    this._lat = _lat;
    this._lng = _lng;
  }

  int getId() {
    return _id;
  }

  String getDireccion() {
    if (_depto == null)
      return "$_calle, Casa: $_numero, $_ciudad, $_provincia, $_region, $_country,";
    return "$_calle $_numero, Depto: $_depto $_ciudad, $_provincia, $_region, $_country,";
  }

  String getCodigoPostal() {
    return _codigoPostal;
  }

  double getLatitud() {
    return _lat;
  }

  double getLongitud() {
    return _lng;
  }

  String getCalle() {
    return _calle;
  }

  String getDepto() {
    return _depto;
  }

  String getCiudad() {
    return _ciudad;
  }

  String getProvincia() {
    return _provincia;
  }

  String getCountry() {
    return _country;
  }

  String getRegion() {
    return _region;
  }

  String getNumero() {
    return _numero;
  }

  void setId(int id) {
    this._id = id;
  }

  void setPais(String pais) {
    this._country = pais;
  }

  void setCalle(String calle) {
    this._calle = calle;
  }

  void setDepto(String depto) {
    this._depto = depto;
  }

  void setCiudad(String ciudad) {
    this._ciudad = ciudad;
  }

  void setProvincia(String provincia) {
    this._provincia = provincia;
  }

  void setRegion(String region) {
    this._region = region;
  }

  void setCodigoPostal(String codigoPostal) {
    this._codigoPostal = codigoPostal;
  }

  void setNumero(String numero) {
    this._numero = numero;
  }

  void setLat(double lat) {
    this._lat = lat;
  }

  void setLng(double lng) {
    this._lng = lng;
  }
}
