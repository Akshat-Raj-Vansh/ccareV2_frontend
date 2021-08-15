import 'package:flutter/foundation.dart';

class Credential {
  final String name, email, password;
  final AuthType type;
  Credential({
    @required this.email,
    @required this.type,
    this.password,
    this.name,
  });
}

enum AuthType { email, google }
