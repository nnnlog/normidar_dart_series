import 'dart:async';

import 'package:image_gen/image_gen.dart';

/// Drawable is one times of drawing,
/// just like a pen.
abstract class Drawable {
  const Drawable();

  /// if [hard] draw will not calculate the critical color
  /// if [hard] and [inside], only darw the pixel that inside the draw area.
  FutureOr<void> draw({
    required int width,
    required int height,
    required PureColor Function(int x, int y) picker,
    required void Function(int x, int y, PureColor color) pen,
    bool hard = true,
    bool inside = false,
  });

  Map<String, dynamic> toJson();

  static Drawable fromJson(Map<String, dynamic> json) {
    final type = json['id'] as String;
    switch (type) {
      case 'Rect':
        return Rect.fromJson(json);
      case 'Img':
        return Img.fromJson(json);
      case 'Mapper':
        return Mapper.fromJson(json);
      case 'LinearGradient':
        return LinearGradient.fromJson(json);
      default:
        throw UnimplementedError();
    }
  }
}
