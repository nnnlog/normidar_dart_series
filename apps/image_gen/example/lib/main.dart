import 'package:image_gen/image_gen.dart';

@ImageGen()
class Abc extends ImageGenerator {
  @override
  GenImage generate() {
    const width = 512;
    const height = 512;
    final rt = GenImage(width: width, height: height);
    final layer = Layer(width: width, height: height);
    layer.draw(Img(path: 'assets/resource/hamster.png'));

    // change s of hsv on all pixels.
    layer.draw(Mapper.byFunction(mapp: (_) => 0, type: MapperType.s));

    // change v of hsv on all pixels.
    layer.draw(
        Mapper.byFunction(mapp: (v) => v < 128 ? 0 : 255, type: MapperType.v));

    // remove comment out to draw rect
    // layer.draw(const Rect(
    //   left: PercentQuantity(0),
    //   right: PercentQuantity(0.5),
    //   top: PercentQuantity(0),
    //   bottom: PercentQuantity(0.5),
    //   color: Uint8Color(),
    //   roundCorner: 0.5,
    // ));
    rt.addLayer(layer);
    return rt;
  }
}
