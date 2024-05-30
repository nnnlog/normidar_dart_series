import 'package:firebase_manager/firebase_manager.dart';

// please set the T of this class
class FmFirestoreSingleBinder<T> extends AbsSingleBinder<T> {
  final FireDoc doc;
  final String fieldName;
  FmFirestoreSingleBinder({required this.doc, required this.fieldName});

  /// auto cast List<dynamic>
  ///   to List<String> or List<int> or List<double> or List<bool>
  @override
  Stream<T?> getData() {
    final resultStream = doc.readStream();
    return resultStream.map((data) {
      Log.debug(() =>
          'firestore_single_binder.dart docPath:${doc.toString()} data: $data');
      final rt = data?[fieldName];
      if (rt is List<dynamic>) {
        if (T == List<String>) {
          return rt.cast<String>() as T?;
        } else if (T == List<int>) {
          return rt.cast<int>() as T?;
        } else if (T == List<double>) {
          return rt.cast<double>() as T?;
        } else if (T == List<bool>) {
          return rt.cast<bool>() as T?;
        }
      }
      return rt;
    });
  }

  @override
  String getLogInfo() {
    return 'docPath:${doc.toString()} fieldName:$fieldName';
  }
}
