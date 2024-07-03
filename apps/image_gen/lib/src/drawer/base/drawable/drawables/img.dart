import 'package:image/image.dart';
import 'package:image_gen/image_gen.dart';

/// Draw an image to the canvas from a path
class Img extends Drawable {
  final String path;

  Image? _img;

  Img({required this.path});

  @override
  Future draw(
      {required int width,
      required int height,
      required PureColor Function(int x, int y) picker,
      required void Function(int x, int y, PureColor color) pen,
      bool hard = true,
      bool inside = false}) async {
    final img = _img ?? await decodeImageFile(path);
    if (img == null) {
      throw Exception('Failed to load image from $path');
    }
    _img = img;

    void drawPixel(int x, int y, PureColor color) {
      if (x < 0 || x >= width || y < 0 || y >= height) {
        return;
      }
      pen(x, y, color);
    }

    for (var x = 0; x < img.width; x++) {
      for (var y = 0; y < img.height; y++) {
        final c = img.getPixel(x, y);
        drawPixel(
          x,
          y,
          Uint8Color(r: c.r.toInt(), g: c.g.toInt(), b: c.b.toInt()),
        );
      }
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': 'Img',
      'path': path,
    };
  }

  static Img fromJson(Map<String, dynamic> json) {
    return Img(path: json['path'] as String);
  }
}
