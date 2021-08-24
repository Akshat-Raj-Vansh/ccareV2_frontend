import 'dart:convert';

class Details {
  final bool newUser;
  final String user_token;
  final String user_type;
  Details({
    required this.newUser,
    required this.user_token,
    required this.user_type,
  });

  Details copyWith({
    bool? newUser,
    String? user_token,
    String? user_type,
  }) {
    return Details(
      newUser: newUser ?? this.newUser,
      user_token: user_token ?? this.user_token,
      user_type: user_type ?? this.user_type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'newUser': newUser,
      'user_token': user_token,
      'user_type': user_type,
    };
  }

  factory Details.fromMap(Map<String, dynamic> map) {
    return Details(
      newUser: map['newUser'],
      user_token: map['user_token'],
      user_type: map['user_type'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Details.fromJson(String source) =>
      Details.fromMap(json.decode(source));

  @override
  String toString() =>
      'Details(newUser: $newUser, user_token: $user_token, user_type: $user_type)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Details &&
        other.newUser == newUser &&
        other.user_token == user_token &&
        other.user_type == user_type;
  }

  @override
  int get hashCode =>
      newUser.hashCode ^ user_token.hashCode ^ user_type.hashCode;
}
