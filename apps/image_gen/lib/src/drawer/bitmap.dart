import 'package:image/image.dart';
import 'package:image_gen/image_gen.dart';

/// Bitmap is a matrix of pixels.<br>
/// A pixel meaning a rgba color.<br>
/// Bitmap can fit all pixels in a image.<br>
class Bitmap {
  final int width;
  final int height;

  final List<List<PureColor>> pixels;

  Bitmap({
    required this.width,
    required this.height,
  }) : pixels = List.generate(
          width,
          (y) => List.generate(
            height,
            (x) => PureColor.zero(),
          ),
        );

  void drawToImage(Image image) {
    for (var x = 0; x < width; x++) {
      for (var y = 0; y < height; y++) {
        image.setPixel(x, y, pixels[x][y].toImageColor());
      }
    }
  }

  /// Paint a color to a pixel.<br>
  void paint(int x, int y, PureColor color) {
    pixels[x][y] = pixels[x][y].paint(color);
  }

  /// Paint a bitmap to this bitmap.<br>
  void paintBitmap(Bitmap bitmap) {
    assert(bitmap.width >= width);
    assert(bitmap.height >= height);
    for (var x = 0; x < width; x++) {
      for (var y = 0; y < height; y++) {
        pixels[x][y] = pixels[x][y].paint(bitmap.pixels[x][y]);
      }
    }
  }

  @override
  String toString() {
    return 'Bitmap{width: $width, height: $height, leftTop: ${pixels[0][0]}, rightBottom: ${pixels[width - 1][height - 1]}';
  }
}
