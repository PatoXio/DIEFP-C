import 'package:cloud_firestore/cloud_firestore.dart';

Future<DocumentSnapshot> getDataDocumentService(String email) async {
  DocumentSnapshot document =
      await Firestore.instance.collection("usuarios").document(email).get();
  return document;
}

Future<Stream<QuerySnapshot>> getListDocumentTiendasService() async {
  Stream<QuerySnapshot> listDocument;
  listDocument = Firestore.instance
      .collection('usuarios')
      .where("tipo", isEqualTo: "Tienda")
      .snapshots();

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
