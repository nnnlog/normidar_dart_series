import 'package:image_gen/image_gen.dart';

class Layer {
  final int width;

  final int height;

  final List<Drawable> _drawables = [];

  Layer({
    required this.width,
    required this.height,
  });

  /// Draw all drawables in the stack to the bitmap, afert that, the stack will be cleared.
  Future<Bitmap> apply() async {
    final rt = Bitmap(width: width, height: height);
    for (final drawable in _drawables) {
      await drawable.draw(
        width: width,
        height: height,
        picker: (x, y) => rt.pixels[x][y],
        pen: (x, y, color) => rt.paint(x, y, color),
      );
    }
    return rt;
  }

  /// Add a drawable to the stack
  void draw(Drawable drawable) {
    _drawables.add(drawable);
  }

  Map<String, dynamic> toJson() {
    return {
      'width': width,
      'height': height,
      'drawables': _drawables.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'Layer{width: $width, height: $height, _drawables: $_drawables}';
  }

  static Layer fromJson(Map<String, dynamic> json) {
    final width = json['width'] as int;
    final height = json['height'] as int;
    final drawables =
        (json['drawables'] as List).map((e) => Drawable.fromJson(e));

    final rt = Layer(width: width, height: height);
    for (final drawable in drawables) {
      rt.draw(drawable);
    }
    return rt;
  }
}
