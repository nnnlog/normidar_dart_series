import 'dart:async';
import 'dart:io';

import 'package:image/image.dart';
import 'package:image_gen/image_gen.dart';

class GenImage {
  final int width;
  final int height;
  final PureColor backgroundColor;

  final List<Layer> _layerStack = [];

  GenImage(
      {required this.width,
      required this.height,
      this.backgroundColor = const FloatColor(r: 1, g: 1, b: 1)});

  void addLayer(Layer layer) {
    _layerStack.add(layer);
  }

  Future<void> saveAsPng(String path) async {
    final image = Image(width: width, height: height);

    // draw background
    final backgroundLayer = Layer(width: width, height: height);
    final backgroundRect = Rect(
      left: PercentQuantity(0),
      right: PercentQuantity(1),
      top: PercentQuantity(0),
      bottom: PercentQuantity(1),
      color: backgroundColor,
    );
    backgroundLayer.draw(backgroundRect);
    final bitmap = await backgroundLayer.apply();

    for (final s in _layerStack) {
      final b = await s.apply();
      bitmap.paintBitmap(b);
    }
    bitmap.drawToImage(image);

    final file = File(path);
    await file.create(recursive: true);
    await file.writeAsBytes(encodePng(image));
  }

  Map<String, dynamic> toJson() {
    return {
      'width': width,
      'height': height,
      'backgroundColor': backgroundColor.toJson(),
      'layerStack': _layerStack.map((e) => e.toJson()).toList(),
    };
  }

  static GenImage fromJson(Map<String, dynamic> json) {
    final width = json['width'] as int;
    final height = json['height'] as int;
    final backgroundColor = PureColor.fromJson(json['backgroundColor']);
    final layerStack = (json['layerStack'] as List)
        .map((e) => Layer.fromJson(e)); 

    final genImage = GenImage(
        width: width, height: height, backgroundColor: backgroundColor);
    genImage._layerStack.addAll(layerStack);
    return genImage;
  }
}
