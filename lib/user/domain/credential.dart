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
        "phoneNumber": phone,
        "fcmtoken": fcmtoken,
        "fireBaseToken": token,
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
      map['phoneNumber'],
      map['user_type'],
      map['fcmtoken'],
      Token(map["fireBaseToken"]),
    );
  }
  factory Credential.fromJson(String source) =>
      Credential.fromMap(json.decode(source));
}

enum UserType { doctor, patient }
