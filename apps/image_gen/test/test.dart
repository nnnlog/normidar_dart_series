import 'package:image_gen/image_gen.dart';
import 'package:test/test.dart';

void main() {
  test('test rect json', () {
    final rect = Rect(
      left: PercentQuantity(0.1),
      right: PercentQuantity(0.9),
      top: PercentQuantity(0.1),
      bottom: PercentQuantity(0.9),
      color: FloatColor(),
    );
    final json = rect.toJson();
    final newRect = Rect.fromJson(json);
    final newJson = newRect.toJson();
    expect(json, newJson);
  });

  test('test layer json', () {
    final layer = Layer(width: 1024, height: 1024);
    layer.draw(const Rect(
      left: PercentQuantity(0.5),
      right: PercentQuantity(1),
      top: PercentQuantity(0.5),
      bottom: PercentQuantity(1),
      color: Uint8Color(),
      roundCorner: 0.5,
    ));
    final json = layer.toJson();
    final newLayer = Layer.fromJson(json);
    final newJson = newLayer.toJson();
    expect(json, newJson);
  });

  // test('test color paint', () {
  //   final color = Uint8Color(r: 255, g: 255, b: 255);
  //   final newColor = color.paint(Uint8Color(r: 0, g: 0, b: 0, a: 255));
  // });
}
