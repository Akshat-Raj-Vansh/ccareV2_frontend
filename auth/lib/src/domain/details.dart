import 'dart:convert';

import 'package:auth/src/domain/token.dart';

class Details {
  final Token token;
  final String name;
  final String email;

  Details(
    this.token,
    this.name,
    this.email,
  );

 
  Map<String, dynamic> toMap() {
    return {
      'authToken': token.value,
      'name': name,
      'email': email,
    };
  }

  factory Details.fromMap(Map<String, dynamic> map) {
    return Details(
      new Token(map["authToken"]),
      map['name'],
      map['email'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Details.fromJson(String source) => Details.fromMap(json.decode(source));

  @override
  String toString() => 'Details(authToken: ${token.value}, name: $name, email: $email)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Details &&
      other.token == token &&
      other.name == name &&
      other.email == email;
  }

  @override
  int get hashCode => token.hashCode ^ name.hashCode ^ email.hashCode;
}
