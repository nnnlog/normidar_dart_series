import 'package:image_gen/image_gen.dart';

/// Map a color to another color,
/// It will override the color in itself layer.
class Mapper extends Drawable {
  List<int> mapper;
  final MapperType type;

  Mapper({
    required this.mapper,
    required this.type,
  });

  Mapper.byFunction({
    required int Function(int val) mapp,
    required this.type,
  }) : mapper = List.generate(256, mapp);

  @override
  void draw(
      {required int width,
      required int height,
      required PureColor Function(int x, int y) picker,
      required void Function(int x, int y, PureColor color) pen,
      bool hard = true,
      bool inside = false}) {
    void resetHsv(int x, int y) {
      final color = picker(x, y);
      final hsv = color.toHsvColor();
      final newColor = switch (type) {
        MapperType.h =>
          HsvColor(h: mapper[(hsv.h * 255).floor()] / 255, s: hsv.s, v: hsv.v),
        MapperType.s =>
          HsvColor(h: hsv.h, s: mapper[(hsv.s * 255).floor()] / 255, v: hsv.v),
        MapperType.v =>
          HsvColor(h: hsv.h, s: hsv.s, v: mapper[(hsv.v * 255).floor()] / 255),
        _ => throw Exception('Invalid MapperType'),
      };
      pen(x, y, newColor);
    }

    void resetRgb(int x, int y) {
      final color = picker(x, y);
      final rgb = color.toUint8Color();
      final newColor = switch (type) {
        MapperType.r => Uint8Color(r: mapper[rgb.r], g: rgb.g, b: rgb.b),
        MapperType.g => Uint8Color(r: rgb.r, g: mapper[rgb.g], b: rgb.b),
        MapperType.b => Uint8Color(r: rgb.r, g: rgb.g, b: mapper[rgb.b]),
        MapperType.a =>
          Uint8Color(r: rgb.r, g: rgb.g, b: rgb.b, a: mapper[rgb.a]),
        _ => throw Exception('Invalid MapperType'),
      };
      pen(x, y, newColor);
    }

    for (var x = 0; x < width; x++) {
      for (var y = 0; y < height; y++) {
        switch (type) {
          case MapperType.h || MapperType.s || MapperType.v:
            resetHsv(x, y);
          case MapperType.r || MapperType.g || MapperType.b || MapperType.a:
            resetRgb(x, y);
        }
      }
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': 'Mapper',
      'mapper': mapper,
      'type': type.name,
    };
  }

  static Mapper fromJson(Map<String, dynamic> json) {
    return Mapper(
      mapper: (json['mapper'] as List).cast<int>(),
      type: switch (json['type'] as String) {
        'h' => MapperType.h,
        's' => MapperType.s,
        'v' => MapperType.v,
        'r' => MapperType.r,
        'g' => MapperType.g,
        'b' => MapperType.b,
        'a' => MapperType.a,
        _ => throw Exception('Invalid MapperType'),
      },
    );
  }
}

enum MapperType { h, s, v, r, g, b, a }
