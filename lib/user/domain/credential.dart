import 'dart:convert';
import 'package:ccarev2_frontend/user/domain/token.dart';

class Credential {
  final String phone;
  final UserType type;
  final String fcmToken;
  final Token token;
  Credential(this.phone, this.type, this.fcmToken, this.token);

  Map<String, dynamic> toMap() {
    return {
      'phoneNumber': phone,
      'user_type': type == UserType.patient ? "patient" : "doctor",
      'fcmToken': fcmToken,
      'fireBaseToken': token.value,
    };
  }

  String toJson() => json.encode(toMap());

  factory Credential.fromMap(Map<String, dynamic> map) {
    return Credential(
      map['phoneNumber'],
      map['user_type'] == 'doctor' ? UserType.doctor : UserType.patient,
      map['fcmToken'],
      Token(map["fireBaseToken"]),
    );
  }
  factory Credential.fromJson(String source) =>
      Credential.fromMap(json.decode(source));
}

enum UserType { doctor, patient }
