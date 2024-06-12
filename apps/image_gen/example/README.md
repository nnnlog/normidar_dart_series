# Image Gen

A tool for generating images on your dart/flutter project.

## Usage

1. Run `dart pub add dev:image_gen` to add the plugin to your project.
2. Create a file to gen image.
3. Add `import 'package:image_gen/image_gen.dart';` to your file.(don't import other libraries)
4. Create a class that extends `ImageGenerator` and annotate it with `@ImageGen` annotation. (you can see example below)
5. Run `dart run build_runner build` to generate the image to your assets folder.

```dart
import 'package:image_gen/image_gen.dart';

@ImageGen()
class Abc extends ImageGenerator {
  @override
  GenImage generate() {
    const width = 512;
    const height = 512;
    final rt = GenImage(width: width, height: height);
    final layer = Layer(width: width, height: height);

    // draw a rect
    layer.draw(const Rect(
      left: PercentQuantity(0),
      right: PercentQuantity(0.5),
      top: PercentQuantity(0),
      bottom: PercentQuantity(0.5),
      color: Uint8Color(),
      roundCorner: 0.5,
    ));

    rt.addLayer(layer);
    return rt;
  }
}
```

## TODO

> PR is well come, @normidar please.

- Draw circle feature
- Draw line feature
- Draw text feature

