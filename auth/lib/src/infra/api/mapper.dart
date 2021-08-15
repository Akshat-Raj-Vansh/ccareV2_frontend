import '../../domain/credential.dart';

class Mapper {
  static Map<String, dynamic> toJson(Credential credential) => {
        "user_type": credential.type.toString().split(".").last,
        "name": credential.name,
        "phone": credential.phone,
      };
}
