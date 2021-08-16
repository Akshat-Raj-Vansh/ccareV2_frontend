import 'dart:convert';

import 'package:auth/src/domain/token.dart';

class PDetails {
  final Token token;
  final String phone;

  PDetails(
    this.token,
    this.phone,
  );

  Map<String, dynamic> toMap() {
    return {
      'authToken': token.value,
      'phone': phone,
    };
  }

  factory PDetails.fromMap(Map<String, dynamic> map) {
    return PDetails(
      new Token(map["authToken"]),
      map['phone'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PDetails.fromJson(String source) =>
      PDetails.fromMap(json.decode(source));

  @override
  String toString() => 'PDetails(authToken: ${token.value}, phone: $phone)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PDetails && other.token == token && other.phone == phone;
  }

  @override
  int get hashCode => token.hashCode ^ phone.hashCode;
}
