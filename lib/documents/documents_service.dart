import 'package:cloud_firestore/cloud_firestore.dart';

Future<DocumentSnapshot> getDocumentService(String email) async {
  DocumentSnapshot document =
      await Firestore.instance.collection("usuarios").document(email).get();
  return document;
}
