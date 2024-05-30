import 'package:image/image.dart';
import 'package:image_gen/image_gen.dart';

/// A color with float r, g, b, a value.
/// r, g, b, a value is between 0 and 1.
class FloatColor extends PureColor {
  final double _r;
  final double _g;
  final double _b;
  final double _a;

  const FloatColor({
    double r = 0,
    double g = 0,
    double b = 0,
    double a = 1,
  })  : _r = r,
        _g = g,
        _b = b,
        _a = a;

  const FloatColor.black() : this(r: 0, g: 0, b: 0, a: 1);
  const FloatColor.blue() : this(r: 0, g: 0, b: 1, a: 1);
  const FloatColor.gray(double v) : this(r: v, g: v, b: v, a: 1);
  const FloatColor.green() : this(r: 0, g: 1, b: 0, a: 1);

  const FloatColor.red() : this(r: 1, g: 0, b: 0, a: 1);
  const FloatColor.white() : this(r: 1, g: 1, b: 1, a: 1);
  double get a => _a;
  double get b => _b;
  double get g => _g;
  double get r => _r;

  /// paint the other color on this color<br>
  /// from: https://stackoverflow.com/a/727339/10375741
  @override
  PureColor paint(PureColor other) {
    final fc = other.toFloatColor();
    if (fc._a == 0) {
      return this;
    } else if (_a == 0) {
      return fc;
    } else if (fc._a == 1) {
      return fc;
    } else if (_a == 1) {
      return this;
    }
    final a = 1 - (1 - fc._a) * (1 - _a);
    final r = _r * _a / a + fc._r * fc._a * (1 - _a) / a;
    final g = _g * _a / a + fc._g * fc._a * (1 - _a) / a;
    final b = _b * _a / a + fc._b * fc._a * (1 - _a) / a;
    return FloatColor(r: r, g: g, b: b, a: a);
  }

  @override
  FloatColor toFloatColor() => this;

  @override
  HsvColor toHsvColor() {
    final max = _r > _g ? (_r > _b ? _r : _b) : (_g > _b ? _g : _b);
    final min = _r < _g ? (_r < _b ? _r : _b) : (_g < _b ? _g : _b);
    final delta = max - min;
    double h = 0;
    if (delta > 0) {
      if (max == _r) {
        h = (_g - _b) / delta;
        if (h < 0) {
          h += 6;
        }
      } else if (max == _g) {
        h = (_b - _r) / delta + 2;
      } else if (max == _b) {
        h = (_r - _g) / delta + 4;
      }
    }
    h /= 6;
    var s = max - min;
    if (max != 0) {
      s /= max;
    }
    final v = max;
    return HsvColor(h: h, s: s, v: v, a: _a);
  }

  @override
  Color toImageColor() => ColorUint8.rgba(
        (_r * 255).round(),
        (_g * 255).round(),
        (_b * 255).round(),
        (_a * 255).round(),
      );

  @override
  Map<String, dynamic> toJson() => {
        'id': 'FloatColor',
        'r': _r,
        'g': _g,
        'b': _b,
        'a': _a,
      };

  @override
  String toString() {
    return 'FloatColor{_r: $_r, _g: $_g, _b: $_b, _a: $_a}';
  }

  @override
  Uint8Color toUint8Color() => Uint8Color(
        r: (_r * 255).round(),
        g: (_g * 255).round(),
        b: (_b * 255).round(),
        a: (_a * 255).round(),
      );

  static FloatColor fromJson(Map<String, dynamic> json) {
    return FloatColor(
      r: json['r'],
      g: json['g'],
      b: json['b'],
      a: json['a'],
    );
  }
}
