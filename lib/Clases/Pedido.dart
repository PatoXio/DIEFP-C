import 'ListProducto.dart';
import 'Producto.dart';

class Pedido {
  String _id;
  int _costoDeEnvio;
  DateTime _fecha;
  DateTime _horaEntrega;
  String _medioDePago;
  bool _porAceptar;
  bool _porEntregar;
  String _idTienda;
  String _idUsuario;
  String _nombreTienda;
  int _totalPagado;
  ListProducto _listProducto;

  Pedido() {
    _id = null;
    _costoDeEnvio = 0;
    _fecha = null;
    _horaEntrega = null;
    _medioDePago = null;
    _porAceptar = false;
    _porEntregar = false;
    _idTienda = null;
    _idUsuario = null;
    _nombreTienda = null;
    _totalPagado = 0;
    _listProducto = new ListProducto();
  }

  Pedido.carga(
      String _id,
      medioDePado,
      _idTienda,
      _idUsuario,
      _nombreTienda,
      int _costoDeEnvio,
      _totalPagado,
      bool _porAceptar,
      _porEntregar,
      DateTime _fecha,
      _horaEntrega,
      ListProducto _listProducto) {
    this._id = _id;
    this._costoDeEnvio = _costoDeEnvio;
    this._fecha = _fecha;
    this._horaEntrega = _horaEntrega;
    this._medioDePago = _medioDePago;
    this._porAceptar = _porAceptar;
    this._porEntregar = _porEntregar;
    this._idTienda = _idTienda;
    this._idUsuario = _idUsuario;
    this._nombreTienda = _nombreTienda;
    this._totalPagado = _totalPagado;
    this._listProducto = _listProducto;
  }

  String getDatos() {
    return "Tienda: $_nombreTienda\nTotal pagado: $_totalPagado\nMedio de Pago: $_medioDePago\nConfirmada: $_porAceptar\nEntrega: $_porEntregar";
  }

  String getId() {
    return _id;
  }

  int getCostoDeEnvio() {
    return _costoDeEnvio;
  }

  DateTime getFecha() {
    return _fecha;
  }

  String getMedioDePago() {
    return _medioDePago;
  }

  bool getPorAceptar() {
    if (_porAceptar == null) return true;
    return _porAceptar;
  }

  DateTime getHoraEntrega() {
    return _horaEntrega;
  }

  bool getPorEntregar() {
    if (_porEntregar == null) return true;
    return _porEntregar;
  }

  String getIdTienda() {
    return _idTienda;
  }

  String getIdUsuario() {
    return _idUsuario;
  }

  String getNombreTienda() {
    return _nombreTienda;
  }

  int getTotalPagado() {
    return _totalPagado;
  }

  ListProducto getListProducto() {
    return _listProducto;
  }

  Producto getProducto(String _id) {
    return _listProducto.getProducto(_id);
  }

  void setId(String _id) {
    this._id = _id;
  }

  void setCostoDeEnvio(int _costoDeEnvio) {
    this._costoDeEnvio = _costoDeEnvio;
  }

  void setFecha(DateTime _fecha) {
    this._fecha = _fecha;
  }

  void setHoraEntrega(DateTime _horaEntrega) {
    this._horaEntrega = _horaEntrega;
  }

  void setMedioDePago(String _medioDePago) {
    this._medioDePago = _medioDePago;
  }

  void setPorAceptar(bool _porAceptar) {
    this._porAceptar = _porAceptar;
  }

  void setporEntregar(bool _porEntregar) {
    this._porEntregar = _porEntregar;
  }

  void setIdTienda(String _idTienda) {
    this._idTienda = _idTienda;
  }

  void setIdUsuario(String _idUsuario) {
    this._idUsuario = _idUsuario;
  }

  void setNombreTienda(String _nombreTienda) {
    this._nombreTienda = _nombreTienda;
  }

  void setTotalPagado(int _totalPagado) {
    this._totalPagado = _totalPagado;
  }

  void setListProducto(ListProducto _listProducto) {
    this._listProducto = _listProducto;
  }

  void setProducto(Producto producto) {
    _listProducto.setProducto(producto);
  }
}
