import 'package:image/image.dart';
import 'package:image_gen/image_gen.dart';

class HsvColor extends PureColor {
  final double _h;
  final double _s;
  final double _v;
  final double _a;

  const HsvColor({
    double h = 0,
    double s = 0,
    double v = 0,
    double a = 1,
  })  : _h = h,
        _s = s,
        _v = v,
        _a = a;

  double get a => _a;
  double get h => _h;
  double get s => _s;
  double get v => _v;

  @override
  PureColor paint(PureColor other) {
    final floatThis = toFloatColor();
    return floatThis.paint(other);
  }

  @override
  FloatColor toFloatColor() {
    final h = _h * 6;
    final i = h.floor();
    final f = h - i;
    return switch (i) {
      0 => FloatColor(r: _v, g: _v * (1 - _s * (1 - f)), b: _v * (1 - _s)),
      1 => FloatColor(r: _v * (1 - _s * f), g: _v, b: _v * (1 - _s)),
      2 => FloatColor(r: _v * (1 - _s), g: _v, b: _v * (1 - _s * (1 - f))),
      3 => FloatColor(r: _v * (1 - _s), g: _v * (1 - _s * f), b: _v),
      4 => FloatColor(r: _v * (1 - _s * (1 - f)), g: _v * (1 - _s), b: _v),
      5 => FloatColor(r: _v, g: _v * (1 - _s), b: _v * (1 - _s * f)),
      _ => throw Exception('Invalid i: $i'),
    };
  }

  @override
  HsvColor toHsvColor() => this;

  @override
  Color toImageColor() => toFloatColor().toImageColor();

  @override
  Map<String, dynamic> toJson() => {
        'id': 'HsvColor',
        'h': _h,
        's': _s,
        'v': _v,
        'a': _a,
      };

  @override
  Uint8Color toUint8Color() => toFloatColor().toUint8Color();

  static HsvColor fromJson(Map<String, dynamic> json) {
    return HsvColor(
      h: json['h'],
      s: json['s'],
      v: json['v'],
      a: json['a'],
    );
  }
}
