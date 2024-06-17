import 'package:image_gen/image_gen.dart';

class PercentQuantity extends Quantity {
  @override
  final num value;

  const PercentQuantity(this.value);

  /// must be same direction
  /// if value is x, size should be width.
  /// if value is y, size should be height.
  @override
  num getPixelValue(num size) {
    return value * size;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': 'PercentQuantity',
      'value': value,
    };
  }

  static PercentQuantity fromJson(Map<String, dynamic> json) {
    return PercentQuantity(json['value']);
  }
}
