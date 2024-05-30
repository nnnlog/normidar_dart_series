import 'package:firebase_manager/firebase_manager.dart';

/// you create a random id doc
/// and then you can get the id
void toGetADocIdAlthoughItDoesNotExist() async {
  final mainColl = fs.db.fireStore.getMainColl();
  final doc = mainColl.getRandomNameDoc();
  doc.getID();
}
