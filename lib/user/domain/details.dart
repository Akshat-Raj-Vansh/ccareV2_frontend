//@dart=2.9
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:ccarev2_frontend/user/domain/profile.dart';

class Details {
  final bool newUser;
  final String user_token;
  final String phone_number;
  final UserType user_type;
  final String name;
  final String hospital;
  Details({
    this.newUser,
    this.user_token,
    this.phone_number,
    this.user_type,
    this.name,
    this.hospital,
  });

  Details copyWith({
    bool newUser,
    String user_token,
    String phone_number,
    UserType user_type,
    String name,
    String hospital,
  }) {
    return Details(
      newUser: newUser ?? this.newUser,
      user_token: user_token ?? this.user_token,
      phone_number: phone_number ?? this.phone_number,
      user_type: user_type ?? this.user_type,
      name: name ?? this.name,
      hospital: hospital ?? this.hospital,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'newUser': newUser,
      'user_token': user_token,
      'phone': phone_number,
      'user_type': user_type.toString().split('.')[1],
      'name': name,
      'hospital': hospital,
    };
  }

  factory Details.fromMap(Map<String, dynamic> map) {
    return Details(
      newUser: map['newUser'],
      user_token: map['user_token'],
      phone_number: map['phone'],
      user_type: UserType.values.firstWhere(
          (element) => element.toString() == "UserType." + map['user_type']),
      name: map['name'],
      hospital: map['hospital'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Details.fromJson(String source) =>
      Details.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Details(newUser: $newUser, user_token: $user_token, phone_number: $phone_number, user_type: $user_type, name: $name, hospital: $hospital)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Details &&
        other.newUser == newUser &&
        other.user_token == user_token &&
        other.phone_number == phone_number &&
        other.user_type == user_type &&
        other.name == name &&
        other.hospital == hospital;
  }

  @override
  int get hashCode {
    return newUser.hashCode ^
        user_token.hashCode ^
        phone_number.hashCode ^
        user_type.hashCode ^
        name.hashCode ^
        hospital.hashCode;
  }
}
