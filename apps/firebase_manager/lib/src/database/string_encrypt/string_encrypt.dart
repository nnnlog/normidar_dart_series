import 'dart:convert';

class StringEncrypt {
  static const Map<StringEncryptType, String> headMap = {
    StringEncryptType.noEncrypt: '_^>',
    StringEncryptType.base64: 'b^>',
  };

  /// from a secure string to a string
  static String decrypt(String value) {
    if (value.length > 3) {
      // take the first three characters
      final head = value.substring(0, 3);
      final body = value.substring(3);
      switch (head) {
        case '_^>':
          return body;
        case 'b^>':
          return utf8.decode(base64.decode(body));
        default:
      }
    }
    return value;
  }

  /// from a string to a secure string
  static String encrypt(String value, StringEncryptType type) {
    switch (type) {
      case StringEncryptType.noEncrypt:
        return '_^>$value';
      case StringEncryptType.base64:
        return 'b^>${base64.encode(utf8.encode(value))}';
      default:
        throw 'unsupported encrypt';
    }
  }
}

enum StringEncryptType {
  noEncrypt,
  base64,
}

extension HeadStringEncryptType on StringEncrypt {}
