import 'package:cloud_firestore/cloud_firestore.dart';

String dbCarrito = "Carrito",
    dbPedidos = "Pedidos",
    dbDireccion = "Direccion",
    dbHistorialCompras = "HistorialCompras",
    dbProductos = "Productos",
    dbPedidosPendientes = "PedidosPendientes";

Future<DocumentSnapshot> getDataDocumentService(String email) async {
  DocumentSnapshot document =
      await Firestore.instance.collection("usuarios").document(email).get();
  return document;
}

Future<List<DocumentSnapshot>> getListDocumentTiendasService() async {
  List<DocumentSnapshot> listDocument;
  listDocument = (await Firestore.instance
          .collection('usuarios')
          .where("tipo", isEqualTo: "Tienda")
          .getDocuments())
      .documents;

  return listDocument;
}

Future<DocumentSnapshot> getProductoTiendaService(
    String idTienda, idProducto) async {
  DocumentSnapshot document = (await Firestore.instance
      .collection("usuarios")
      .document(idTienda)
      .collection('Productos')
      .document(idProducto)
      .get());

  return document;
}

Future<List<DocumentSnapshot>> getListDocumentOneCollecionService(
    String id, collection) async {
  List<DocumentSnapshot> listDocument;
  listDocument = (await Firestore.instance
          .collection("usuarios")
          .document(id)
          .collection(collection)
          .getDocuments())
      .documents;

  return listDocument;
}

Future<DocumentSnapshot> getDocumentDireccionService(
    String id, direccion) async {
  DocumentSnapshot document;
  document = (await Firestore.instance
      .collection("usuarios")
      .document(id)
      .collection('Direccion')
      .document(direccion)
      .get());

  return document;
}

Future<List<DocumentSnapshot>> getListDocumentCollectionDocumentService(
    String id, collection, idDocument) async {
  List<DocumentSnapshot> listDocument;
  listDocument = (await Firestore.instance
          .collection("usuarios")
          .document(id)
          .collection(collection)
          .document(idDocument)
          .collection("Productos")
          .getDocuments())
      .documents;

  return listDocument;
}
