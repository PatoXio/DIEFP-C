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

  Producto() {
    _id = null;
    _cantidad = 0;
    _codigo = null;
    _mgPorU = 0;
    _precio = 0;
    _stock = 0;
    _stockReservado = 0;
    _idTienda = null;
    _nombreTienda = null;
    _nombre = null;
  }

  Producto.carga(String id, codigo, idTienda, nombreTienda, nombre,
      int cantidad, precio, stock, stockReservado, double mgPorU) {
    _id = id;
    _cantidad = cantidad;
    _codigo = codigo;
    _mgPorU = mgPorU;
    _precio = precio;
    _stock = stock;
    _stockReservado = stockReservado;
    _idTienda = idTienda;
    _nombreTienda = nombreTienda;
    _nombre = nombre;
  }

  String getDatos() {
    return "Nombre: $_nombre\nStock: $_stock\nPrecio: $_precio\nPeso: $_mgPorU Mg/U\nCodigo: $_codigo";
  }

  String getDatosAlComprar() {
    return "Precio: $_precio\nMg/U: $_mgPorU\nStock: $_stock";
  }

  String getId() {
    return _id;
  }

  int getCantidad() {
    if (_cantidad == null) return 0;
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

  void setId(String id) {
    this._id = id;
  }
}
