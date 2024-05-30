class StreamHolder<T> {
  late T value;
  final Stream<T> _stream;

  StreamHolder(this._stream);
  Future<T> init() async {
    value = await _stream.first;
    _stream.listen((event) {
      value = event;
    });
    return value;
  }
}
