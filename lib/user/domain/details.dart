import 'dart:convert';

import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:ccarev2_frontend/user/domain/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Details {
  final bool newUser;
  final String user_token;
  final String phone_number;
  final UserType user_type;
  final DoctorType doctor_type;
  Details({
    required this.newUser,
    required this.user_token,
    required this.phone_number,
    required this.user_type,
    required this.doctor_type,
  });

  Details copyWith({
    bool? newUser,
    String? user_token,
    String? phone_number,
    UserType? user_type,
    DoctorType? doctor_type,
  }) {
    return Details(
      newUser: newUser ?? this.newUser,
      user_token: user_token ?? this.user_token,
      phone_number: phone_number ?? this.phone_number,
      user_type: user_type ?? this.user_type,
      doctor_type: doctor_type ?? this.doctor_type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'newUser': newUser,
      'user_token': user_token,
      'phone_number': phone_number,
      'user_type': user_type.toString().split('.')[1],
      'doctor_type': doctor_type.toString().split('.')[1],
    };
  }

  factory Details.fromMap(Map<String, dynamic> map) {
    return Details(
      newUser: map['newUser'],
      user_token: map['user_token'],
      phone_number: map['phone_number'],
      user_type: UserType.values.firstWhere(
          (element) => element.toString() == "UserType." + map['user_type']),
      doctor_type: DoctorType.values.firstWhere((element) =>
          element.toString() == "DoctorType." + map['doctor_type']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Details.fromJson(String source) =>
      Details.fromMap(json.decode(source));

  @override
  String toString() =>
      'Details(newUser: $newUser, user_token: $user_token, phone_number:$phone_number,user_type: $user_type,doctor_type: $doctor_type)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Details &&
        other.newUser == newUser &&
        other.user_token == user_token &&
        other.phone_number == phone_number &&
        other.user_type == user_type &&
        other.doctor_type == doctor_type;
  }

  @override
  int get hashCode =>
      newUser.hashCode ^
      user_token.hashCode ^
      phone_number.hashCode ^
      user_type.hashCode ^
      doctor_type.hashCode;
}
