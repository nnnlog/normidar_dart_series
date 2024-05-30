import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_manager/firebase_manager.dart';

class FireStoreDatabase extends DatabaseInterface {
  FireStoreDatabase({required super.rootPath});

  Object getGeoPoint(double latitude, double longitude) {
    return GeoPoint(latitude, longitude);
  }

  FireColl getMainColl() {
    final db = FirebaseFirestore.instance;
    return FireColl(db.collection(getPrefixPath()));
  }

  FireDoc? getUserDoc(String tableName) {
    final userID = FirebaseManager.share.auth.getNowUser()?.getID();
    if (userID != null) {
      final doc = getMainColl().getDeepColl(tableName).getDoc(userID);
      return doc;
    }
    return null;
  }

  // Object getTimeStamp(DateTime dateTime) {}
}
