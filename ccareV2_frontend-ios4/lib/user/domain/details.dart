import 'dart:convert';


import 'package:ccarev2_frontend/user/domain/credential.dart';

class Details {
  final bool newUser;
  final String user_token;
  final UserType user_type;
  final String phone;
  Details({
    this.newUser,
    this.user_token,
    this.user_type,
    this.phone,
  });

  Details copyWith({
    bool newUser,
    String user_token,
    UserType user_type,
    String phone,
  }) {
    return Details(
      newUser: newUser ?? this.newUser,
      user_token: user_token ?? this.user_token,
      user_type: user_type ?? this.user_type,
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'newUser': newUser,
      'user_token': user_token,
      'user_type': user_type.toString().split('.')[1],
      'phone': phone,
    };
  }

  factory Details.fromMap(Map<String, dynamic> map) {
    return Details(
      newUser: map['newUser'],
      user_token: map['user_token'],
      user_type: UserType.values.firstWhere(
          (element) => element.toString() == "UserType." + map['user_type']),
      phone: map['phone'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Details.fromJson(String source) =>
      Details.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Details(newUser: $newUser, user_token: $user_token, user_type: $user_type, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Details &&
        other.newUser == newUser &&
        other.user_token == user_token &&
        other.user_type == user_type &&
        other.phone == phone;
  }

  @override
  int get hashCode {
    return newUser.hashCode ^
        user_token.hashCode ^
        user_type.hashCode ^
        phone.hashCode;
  }
}
