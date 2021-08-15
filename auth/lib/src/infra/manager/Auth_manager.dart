import 'package:auth/src/domain/auth_service_contract.dart';
import 'package:auth/src/domain/credential.dart';
import 'package:auth/src/infra/adapters/phone_auth.dart';
import 'package:auth/src/infra/api/auth_api_contract.dart';

class AuthManger {
  final IAuthApi iAuthApi;

  AuthManger(this.iAuthApi);

  IAuthService service(UserType type) {
    // var service;
    // switch (type) {
    //   case UserType.doctor:
    //     service = PhoneAuth(iAuthApi);
    //     break;
    //   case UserType.patient:
    //     service = PhoneAuth(iAuthApi);
    //     break;
    // }
    return PhoneAuth(iAuthApi);
  }
}
