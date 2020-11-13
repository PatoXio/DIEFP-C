import 'package:cloud_firestore/cloud_firestore.dart';

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

Future<List<DocumentSnapshot>> getListDocumentCarritoService(String id) async {
  List<DocumentSnapshot> listDocument;
  listDocument = (await Firestore.instance
          .collection("usuarios")
          .document(id)
          .collection("Carrito")
          .getDocuments())
      .documents;

  return listDocument;
}

Future<List<DocumentSnapshot>> getListDocumentPedidosService(String id) async {
  List<DocumentSnapshot> listDocument;
  listDocument = (await Firestore.instance
          .collection("usuarios")
          .document(id)
          .collection("Pedidos")
          .getDocuments())
      .documents;

  return listDocument;
}

Future<List<DocumentSnapshot>> getListDocumentDireccionService(
    String id) async {
  List<DocumentSnapshot> listDocument;
  listDocument = (await Firestore.instance
          .collection("usuarios")
          .document(id)
          .collection("Direccion")
          .getDocuments())
      .documents;

  return listDocument;
}

Future<List<DocumentSnapshot>> getListDocumentProductosPedidoService(
    String id, String idDocument) async {
  List<DocumentSnapshot> listDocument;
  listDocument = (await Firestore.instance
          .collection("usuarios")
          .document(id)
          .collection("Pedidos")
          .document(idDocument)
          .collection("Productos")
          .getDocuments())
      .documents;

  return listDocument;
}

Future<List<DocumentSnapshot>> getListDocumentPedidosPendientes(
    String email) async {
  List<DocumentSnapshot> listDocument;

  return listDocument;
}

Future<List<DocumentSnapshot>> getListDocumentProductoService(
    String email) async {
  List<DocumentSnapshot> listDocument;
  listDocument = (await Firestore.instance
          .collection("usuarios")
          .document(email)
          .collection("Productos")
          .getDocuments())
      .documents;

  return listDocument;
}
