import 'dart:async';
import 'dart:math';

import 'package:image_gen/image_gen.dart';

class LinearGradient extends Drawable {
  final Quantity fromX;
  final Quantity fromY;
  final Quantity toX;
  final Quantity toY;
  final PureColor fromColor;
  final PureColor toColor;

  LinearGradient({
    required this.fromX,
    required this.fromY,
    required this.toX,
    required this.toY,
    required this.fromColor,
    required this.toColor,
  });

  @override
  FutureOr<void> draw(
      {required int width,
      required int height,
      required PureColor Function(int x, int y) picker,
      required void Function(int x, int y, PureColor color) pen,
      bool hard = true,
      bool inside = false}) {
    final fx = fromX.getPixelValue(width);
    final fy = fromY.getPixelValue(height);
    final tx = toX.getPixelValue(width);
    final ty = toY.getPixelValue(height);

    PureColor calcColor(num fPercent, num tPercent) {
      final r = fPercent / (fPercent + tPercent);

      num calPercent(num f, num t, num r) {
        return f + (t - f) * r;
      }

      final fromFColor = fromColor.toFloatColor();
      final toFColor = toColor.toFloatColor();
      final fAlpha = fromFColor.a;
      final tAlpha = toFColor.a;
      final fRed = fromFColor.r;
      final tRed = toFColor.r;
      final fGreen = fromFColor.g;
      final tGreen = toFColor.g;
      final fBlue = fromFColor.b;
      final tBlue = toFColor.b;

      final alpha = calPercent(fAlpha, tAlpha, r);
      final red = calPercent(fRed, tRed, r);
      final green = calPercent(fGreen, tGreen, r);
      final blue = calPercent(fBlue, tBlue, r);
      return FloatColor(
          r: red.toDouble(),
          g: green.toDouble(),
          b: blue.toDouble(),
          a: alpha.toDouble());
    }

    num calcDistance(int x, int y, num xx, num yy) {
      return sqrt((x - xx) * (x - xx) + (y - yy) * (y - yy));
    }

    for (var x = 0; x < width; x++) {
      for (var y = 0; y < height; y++) {
        // calculate xy to f
        final fDistance = calcDistance(x, y, fx, fy);

        // calculate xy to t
        final tDistance = calcDistance(x, y, tx, ty);

        final color = calcColor(fDistance, tDistance);

        pen(x, y, color);
      }
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': 'LinearGradient',
      'fromX': fromX.toJson(),
      'fromY': fromY.toJson(),
      'toX': toX.toJson(),
      'toY': toY.toJson(),
      'fromColor': fromColor.toJson(),
      'toColor': toColor.toJson(),
    };
  }

  static LinearGradient fromJson(Map<String, dynamic> json) {
    return LinearGradient(
      fromX: Quantity.fromJson(json['fromX']),
      fromY: Quantity.fromJson(json['fromY']),
      toX: Quantity.fromJson(json['toX']),
      toY: Quantity.fromJson(json['toY']),
      fromColor: PureColor.fromJson(json['fromColor']),
      toColor: PureColor.fromJson(json['toColor']),
    );
  }
}
