import 'package:image_gen/image_gen.dart';

abstract class Quantity {
  const Quantity();
  num get value;
  num getPixelValue(num size);

  Map<String, dynamic> toJson();

  static Quantity fromJson(Map<String, dynamic> json) {
    switch (json['id']) {
      case 'PercentQuantity':
        return PercentQuantity.fromJson(json);
      case 'PixelQuantity':
        return PixelQuantity.fromJson(json);
      default:
        throw Exception('Unknown Quantity type: ${json['id']}');
    }
  }
}
