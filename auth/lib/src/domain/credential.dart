import 'package:flutter/foundation.dart';

class Credential {
  final String name, email, password, phone;
  final AuthType type;
  Credential({
    this.email,
    @required this.type,
    this.password,
    this.name,
    this.phone,
  });
}

enum AuthType { email, google, phone }
