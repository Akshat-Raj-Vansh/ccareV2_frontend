import 'package:flutter/foundation.dart';

class Credential {
  final String name, phone;
  final UserType type;
  Credential({
    @required this.phone,
    @required this.type,
    @required this.name,
  });
}

enum UserType { patient, doctor }
