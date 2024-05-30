import 'package:image/image.dart';
import 'package:image_gen/image_gen.dart';

abstract class PureColor {
  const PureColor();

  factory PureColor.zero() => const FloatColor(
        r: 0,
        g: 0,
        b: 0,
        a: 0,
      );

  /// paint the other color on this color<br>
  /// from: https://stackoverflow.com/a/727339/10375741
  PureColor paint(PureColor other);

  FloatColor toFloatColor();

  HsvColor toHsvColor();

  Color toImageColor();

  Map<String, dynamic> toJson();

  Uint8Color toUint8Color();

  static PureColor fromJson(Map<String, dynamic> json) {
    switch (json['id']) {
      case 'FloatColor':
        return FloatColor.fromJson(json);
      case 'UInt8Color':
        return Uint8Color.fromJson(json);
      case 'HsvColor':
        return HsvColor.fromJson(json);
      case _:
        throw UnimplementedError();
    }
  }
}
