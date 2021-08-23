import 'dart:convert';
import 'package:ccarev2_frontend/user/domain/token.dart';

class Credential {
  final String phone;
  final UserType type;
  final String fcmtoken;
  final Token token;
  Credential(this.phone, this.type, this.fcmtoken, this.token);

  Map<String, dynamic> toJson() => {
        "user_type": type,
        "phone": phone,
        "fcmtoken": fcmtoken,
        "token": token,
      };

  Map<String, dynamic> toMap() {
    return {
      'phone': phone,
      'type': type,
      'fcmtoken': fcmtoken,
      'token': token.value,
    };
  }

  factory Credential.fromMap(Map<String, dynamic> map) {
    return Credential(
      map['phone'],
      map['type'],
      map['fcmtoken'],
      Token(map["token"]),
    );
  }
  factory Credential.fromJson(String source) =>
      Credential.fromMap(json.decode(source));
}

enum UserType { doctor, patient }
