import 'package:cloud_firestore/cloud_firestore.dart';

Future<DocumentSnapshot> getDocument(String id) async {
  DocumentSnapshot document;
  document = await Firestore.instance.collection("usuarios").document(id).get();
  return document;
}
