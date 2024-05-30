part of 'database_result.dart';

class ValueResult extends DatabaseResult {
  ValueResult(super.snapshot);

  T getContent<T>() {
    final rt = _snapshot.value;
    return rt as T;
  }
}
