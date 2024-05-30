import 'package:image_gen/image_gen.dart';

class PixelQuantity extends Quantity {
  @override
  final num value;

  const PixelQuantity(this.value);

  @override
  num getPixelValue(num size) {
    return value;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': 'PixelQuantity',
      'value': value,
    };
  }

  static PixelQuantity fromJson(Map<String, dynamic> json) {
    return PixelQuantity(json['value']);
  }
}
