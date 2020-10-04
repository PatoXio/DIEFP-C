class Producto {
  String id;
  int cantidad;
  String codigo;
  double mgPorU;
  int precio;
  int stock;
  int stockReservado;
  String idTienda;
  String nombreTienda;
  String nombre;

  String getId() {
    return id;
  }

  int getCantidad() {
    return cantidad;
  }

  String getCodigo() {
    return codigo;
  }

  double getMgPorU() {
    return mgPorU;
  }

  int getPrecio() {
    return precio;
  }

  int getStock() {
    return stock;
  }

  int getStockReservado() {
    return stockReservado;
  }

  String getIdTienda() {
    return idTienda;
  }

  String getNombreTienda() {
    return nombreTienda;
  }

  String getNombre() {
    return nombre;
  }

  void setCantidad(int cantidad) {
    this.cantidad = cantidad;
  }

  void setCodigo(String codigo) {
    this.codigo = codigo;
  }

  void setMgPorU(double mgPorU) {
    this.mgPorU = mgPorU;
  }

  void setPrecio(int precio) {
    this.precio = precio;
  }

  void setStock(int stock) {
    this.stock = stock;
  }

  void setStockReservado(int stockReservado) {
    this.stockReservado = stockReservado;
  }

  void setIdTienda(String idTienda) {
    this.idTienda = idTienda;
  }

  void setNombreTienda(String nombreTienda) {
    this.nombreTienda = nombreTienda;
  }

  void setNombre(String nombre) {
    this.nombre = nombre;
  }
}
