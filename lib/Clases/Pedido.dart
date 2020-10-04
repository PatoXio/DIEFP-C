import 'ListProducto.dart';
import 'Producto.dart';

class Pedido {
  String id;
  int costoDeEnvio;
  DateTime fecha;
  String medioDePago;
  bool porAceptar;
  bool porEntregar;
  String idTienda;
  String idUsuario;
  String nombreTienda;
  int totalPagado;
  ListProducto listProducto;

  Pedido() {
    id = null;
    costoDeEnvio = 0;
    fecha = null;
    medioDePago = null;
    porAceptar = false;
    porEntregar = false;
    idTienda = null;
    idUsuario = null;
    nombreTienda = null;
    totalPagado = 0;
    listProducto = new ListProducto();
  }

  Pedido.carga(
      String id,
      medioDePado,
      idTienda,
      idUsuario,
      nombreTienda,
      int costoDeEnvio,
      totalPagado,
      bool porAceptar,
      porEntregar,
      DateTime fecha,
      ListProducto listProducto) {
    this.id = id;
    this.costoDeEnvio = costoDeEnvio;
    this.fecha = fecha;
    this.medioDePago = medioDePago;
    this.porAceptar = porAceptar;
    this.porEntregar = porEntregar;
    this.idTienda = idTienda;
    this.idUsuario = idUsuario;
    this.nombreTienda = nombreTienda;
    this.totalPagado = totalPagado;
    this.listProducto = listProducto;
  }

  String getId() {
    return id;
  }

  int getCostoDeEnvio() {
    return costoDeEnvio;
  }

  DateTime getFecha() {
    return fecha;
  }

  String getMedioDePago() {
    return medioDePago;
  }

  bool getPorAceptar() {
    return porAceptar;
  }

  bool getPorEntregar() {
    return porEntregar;
  }

  String getIdTienda() {
    return idTienda;
  }

  String getIdUsuario() {
    return idUsuario;
  }

  String getNombreTienda() {
    return nombreTienda;
  }

  int getTotalPagado() {
    return totalPagado;
  }

  ListProducto getListProducto() {
    return listProducto;
  }

  Producto getProducto(String id) {
    return listProducto.getProducto(id);
  }

  void setId(String id) {
    this.id = id;
  }

  void setCostoDeEnvio(int costoDeEnvio) {
    this.costoDeEnvio = costoDeEnvio;
  }

  void setFecha(DateTime fecha) {
    this.fecha = fecha;
  }

  void setMedioDePago(String medioDePago) {
    this.medioDePago = medioDePago;
  }

  void setPorAceptar(bool porAceptar) {
    this.porAceptar = porAceptar;
  }

  void setporEntregar(bool porEntregar) {
    this.porEntregar = porEntregar;
  }

  void setIdTienda(String idTienda) {
    this.idTienda = idTienda;
  }

  void setIdUsuario(String idUsuario) {
    this.idUsuario = idUsuario;
  }

  void setNombreTienda(String nombreTienda) {
    this.nombreTienda = nombreTienda;
  }

  void setTotalPagado(int totalPagado) {
    this.totalPagado = totalPagado;
  }

  void setListProducto(ListProducto listProducto) {
    this.listProducto = listProducto;
  }

  void setProducto(Producto producto) {
    listProducto.setProducto(producto);
  }
}
