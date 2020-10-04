class Direccion {
  int id;
  String calle;
  bool casa;
  String ciudad;
  String region;
  int codigoPostal;
  int numero;

  Direccion() {
    id = -1;
    calle = null;
    casa = false;
    ciudad = null;
    region = null;
    codigoPostal = -1;
    numero = -1;
  }

  Direccion.carga(
      int id, codigoPostal, numero, String calle, ciudad, region, bool casa) {
    this.id = id;
    this.calle = calle;
    this.casa = casa;
    this.ciudad = ciudad;
    this.region = region;
    this.codigoPostal = codigoPostal;
    this.numero = numero;
  }

  int getId() {
    return id;
  }

  String getDireccion() {
    return region + ', ' + ciudad + ', ' + calle + ', ' + numero.toString();
  }

  int getCodigoPostal() {
    return codigoPostal;
  }

  void setId(int id) {
    this.id = id;
  }

  void setCalle(String calle) {
    this.calle = calle;
  }

  void setCasa(bool casa) {
    this.casa = casa;
  }

  void setCiudad(String ciudad) {
    this.ciudad = ciudad;
  }

  void setRegion(String region) {
    this.region = region;
  }

  void setCodigoPostal(int codigoPostal) {
    this.codigoPostal = codigoPostal;
  }

  void setNumero(int numero) {
    this.numero = numero;
  }
}
