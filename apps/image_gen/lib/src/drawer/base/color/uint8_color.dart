import 'package:image/image.dart';
import 'package:image_gen/image_gen.dart';

class Uint8Color extends PureColor {
  final int _r;
  final int _g;
  final int _b;
  final int _a;

  const Uint8Color({
    int r = 0,
    int g = 0,
    int b = 0,
    int a = 255,
  })  : _r = r,
        _g = g,
        _b = b,
        _a = a;

  int get a => _a;
  int get b => _b;
  int get g => _g;
  int get r => _r;

  @override
  PureColor paint(PureColor other) {
    final floatThis = toFloatColor();
    return floatThis.paint(other);
  }

  @override
  FloatColor toFloatColor() => FloatColor(
        r: _r / 255,
        g: _g / 255,
        b: _b / 255,
        a: _a / 255,
      );

  @override
  HsvColor toHsvColor() => toFloatColor().toHsvColor();

  @override
  Color toImageColor() => ColorUint8.rgba(_r, _g, _b, _a);

  @override
  Map<String, dynamic> toJson() => {
        'id': 'UInt8Color',
        'r': _r,
        'g': _g,
        'b': _b,
        'a': _a,
      };

  @override
  String toString() {
    return 'Uint8Color{_r: $_r, _g: $_g, _b: $_b, _a: $_a}';
  }

  @override
  Uint8Color toUint8Color() => this;

  static Uint8Color fromJson(Map<String, dynamic> json) {
    return Uint8Color(
      r: json['r'],
      g: json['g'],
      b: json['b'],
      a: json['a'],
    );
  }
}
