/// use to bind data from firebase to dataset
abstract class AbsSingleBinder<T> {
  Stream<T?> getData();
  String getLogInfo();
}
