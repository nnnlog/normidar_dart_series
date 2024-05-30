import 'package:firebase_manager/firebase_manager.dart';

class FmFirestoreDefaultBinder<T extends FmMatcherDataset>
    extends FmFirestoreDataBinder<T> {
  final FireDoc doc;
  final T Function(Map<String, dynamic>) constructor;
  FmFirestoreDefaultBinder({
    required this.doc,
    required this.constructor,
  });

  @override
  FireDoc getDataRef() => doc;

  @override
  Stream<T> getDataset() {
    return getMap().map((event) {
      event?['id'] = doc.getID();
      return constructor(event!);
    });
  }
}
