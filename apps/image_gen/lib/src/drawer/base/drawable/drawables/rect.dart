import 'dart:math';

import 'package:image_gen/image_gen.dart';

/// A base drawer with rect
class Rect extends Drawable {
  final Quantity left;
  final Quantity right;
  final Quantity top;
  final Quantity bottom;
  final PureColor color;
  final bool? hard;
  final bool? inside;

  /// The round corner of the rect, if null, the rect will be a rectangle <br>
  /// if not null, the rect will be a round rect <br>
  /// the value should be between 0 and 1 <br>
  /// now, it only support inside round corner
  final double? roundCorner;

  const Rect({
    required this.left,
    required this.right,
    required this.top,
    required this.bottom,
    required this.color,
    this.hard,
    this.inside,
    this.roundCorner,
  });

  @override
  void draw({
    required int width,
    required int height,
    required PureColor Function(int x, int y) picker,
    required void Function(int x, int y, PureColor color) pen,
    bool hard = true,
    bool inside = false,
  }) {
    // draw round
    final roundCorner = this.roundCorner;
    if (roundCorner != null) {
      _drawRoundRect(
        width: width,
        height: height,
        pen: pen,
        color: color,
        left: left.getPixelValue(width).ceil(),
        right: right.getPixelValue(width).floor(),
        top: top.getPixelValue(height).ceil(),
        bottom: bottom.getPixelValue(height).floor(),
        roundCorner: roundCorner,
      );
      return;
    }

    // normal rect
    switch ((this.hard ?? hard, this.inside ?? inside)) {
      case (true, true):
        _drawArea(
          width: width,
          height: height,
          pen: pen,
          color: color,
          left: left.getPixelValue(width).ceil(),
          right: right.getPixelValue(width).floor(),
          top: top.getPixelValue(height).ceil(),
          bottom: bottom.getPixelValue(height).floor(),
        );
      case (true, false):
        _drawArea(
          width: width,
          height: height,
          pen: pen,
          color: color,
          left: left.getPixelValue(width).floor(),
          right: right.getPixelValue(width).ceil(),
          top: top.getPixelValue(height).floor(),
          bottom: bottom.getPixelValue(height).ceil(),
        );
      case _:
        throw UnimplementedError();
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': 'Rect',
      'left': left.toJson(),
      'right': right.toJson(),
      'top': top.toJson(),
      'bottom': bottom.toJson(),
      'color': color.toJson(),
      'hard': hard,
      'inside': inside,
      'roundCorner': roundCorner,
    };
  }

  @override
  String toString() {
    return 'Rect{left: $left, right: $right, top: $top, bottom: $bottom, color: $color, hard: $hard, inside: $inside, roundCorner: $roundCorner}';
  }

  void _drawArea({
    required int width,
    required int height,
    required void Function(int x, int y, PureColor color) pen,
    required PureColor color,
    required int left,
    required int right,
    required int top,
    required int bottom,
  }) {
    void drawPixel(int x, int y) {
      if (x < 0 || x >= width || y < 0 || y >= height) {
        return;
      }
      pen(x, y, color);
    }

    for (int x = left; x <= right; x++) {
      for (int y = top; y <= bottom; y++) {
        drawPixel(x, y);
      }
    }
  }

  /// Draw a round rect
  void _drawRoundRect({
    required int width,
    required int height,
    required void Function(int x, int y, PureColor color) pen,
    required PureColor color,
    required int left,
    required int right,
    required int top,
    required int bottom,
    required double roundCorner,
  }) {
    void drawPixel(int x, int y) {
      if (x < 0 || x >= width || y < 0 || y >= height) {
        return;
      }
      pen(x, y, color);
    }

    double calcDistance(int x, int y, double x1, double y1) {
      return sqrt((x - x1) * (x - x1) + (y - y1) * (y - y1)).toDouble();
    }

    final r = (right - left) * roundCorner / 2;
    final roundLeft = left + (right - left) * roundCorner / 2;
    final roundRight = right - (right - left) * roundCorner / 2;
    final roundTop = top + (bottom - top) * roundCorner / 2;
    final roundBottom = bottom - (bottom - top) * roundCorner / 2;
    for (int x = left; x <= right; x++) {
      for (int y = top; y <= bottom; y++) {
        final inCircleLeftTop = calcDistance(x, y, roundLeft, roundTop) <= r;
        final inCircleRightTop = calcDistance(x, y, roundRight, roundTop) <= r;
        final inCircleLeftBottom =
            calcDistance(x, y, roundLeft, roundBottom) <= r;
        final inCircleRightBottom =
            calcDistance(x, y, roundRight, roundBottom) <= r;
        final inCircle = inCircleLeftTop ||
            inCircleRightTop ||
            inCircleLeftBottom ||
            inCircleRightBottom;
        if ((x > roundLeft && x < roundRight) ||
            (y > roundTop && y < roundBottom) ||
            inCircle) {
          drawPixel(x, y);
        }
      }
    }
  }

  static Rect fromJson(Map<String, dynamic> json) {
    return Rect(
      left: Quantity.fromJson(json['left']),
      right: Quantity.fromJson(json['right']),
      top: Quantity.fromJson(json['top']),
      bottom: Quantity.fromJson(json['bottom']),
      color: PureColor.fromJson(json['color']),
      hard: json['hard'],
      inside: json['inside'],
      roundCorner: json['roundCorner'],
    );
  }
}
