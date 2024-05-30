import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_manager/firebase_manager.dart';

class FireDocTuple<T> extends FireDoc {
  final T data;
  FireDocTuple(QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
      T Function(Map<String, dynamic>) convertor)
      : data = convertor(FireDoc.castMap(snapshot.data())!),
        super(snapshot.reference);
  FireDocTuple.byRefData(super.reference, this.data);
}
