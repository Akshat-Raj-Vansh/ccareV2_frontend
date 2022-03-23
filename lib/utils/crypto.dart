import 'package:encrypt/encrypt.dart';

class Crypto {
  static String encryptData(String text, String key_string) {
    final plainText = text;
    final key = Key.fromUtf8(key_string);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  static String decryptData(String text, String key_string) {
    final key = Key.fromUtf8(key_string);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    final decrypted = encrypter.decrypt64(text, iv: iv);
    return decrypted;
  }
}
