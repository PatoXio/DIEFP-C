class Producto {
  String _id;
  int _cantidad;
  String _codigo;
  double _mgPorU;
  int _precio;
  int _stock;
  int _stockReservado;
  String _idTienda;
  String _nombreTienda;
  String _nombre;

  String getId() {
    return _id;
  }

  int getCantidad() {
    return _cantidad;
  }

  String getCodigo() {
    return _codigo;
  }

  double getMgPorU() {
    return _mgPorU;
  }

  int getPrecio() {
    return _precio;
  }

  int getStock() {
    return _stock;
  }

  int getStockReservado() {
    return _stockReservado;
  }

  String getIdTienda() {
    return _idTienda;
  }

  String getNombreTienda() {
    return _nombreTienda;
  }

  String getNombre() {
    return _nombre;
  }

  void setCantidad(int cantidad) {
    this._cantidad = cantidad;
  }

  void setCodigo(String codigo) {
    this._codigo = codigo;
  }

  void setMgPorU(double mgPorU) {
    this._mgPorU = mgPorU;
  }

  void setPrecio(int precio) {
    this._precio = precio;
  }

  void setStock(int stock) {
    this._stock = stock;
  }

  void setStockReservado(int stockReservado) {
    this._stockReservado = stockReservado;
  }

  void setIdTienda(String idTienda) {
    this._idTienda = idTienda;
  }

  void setNombreTienda(String nombreTienda) {
    this._nombreTienda = nombreTienda;
  }

  void setNombre(String nombre) {
    this._nombre = nombre;
  }
}
