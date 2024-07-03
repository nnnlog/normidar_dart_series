import 'package:image_gen/image_gen.dart';

@ImageGen()
class Abc extends ImageGenerator {
  @override
  GenImage generate() {
    const width = 512;
    const height = 512;
    final rt = GenImage(width: width, height: height);
    final layer = Layer(width: width, height: height);
    layer.draw(LinearGradient(
      fromX: const PercentQuantity(0.5),
      fromY: const PercentQuantity(0),
      toX: const PercentQuantity(1),
      toY: const PercentQuantity(1),
      fromColor: const Uint8Color(r: 200, g: 198, b: 50),
      toColor: const Uint8Color(r: 235, g: 143, b: 50),
    ));
    rt.addLayer(layer);
    return rt;
  }
}
