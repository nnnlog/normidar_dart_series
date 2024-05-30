import 'package:firebase_manager/firebase_manager.dart';

@Deprecated("use FireDocDataTuple instead")
class FireDocDataset {
  final FireDoc doc;
  final Map<String, dynamic> data;
  FireDocDataset(this.doc, this.data);
}
