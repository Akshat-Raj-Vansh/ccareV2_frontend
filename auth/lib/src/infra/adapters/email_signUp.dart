import 'package:auth/src/domain/credential.dart';

import '../../domain/otpMessage.dart';
import '../../domain/signup_service_contract.dart';
import '../api/auth_api_contract.dart';

import 'package:async/async.dart';

class SignUpService implements ISignUpService {
  final IAuthApi iAuthApi;

  SignUpService(this.iAuthApi);

  Future<Result<OtpMessage>> signUp(
      String email, String password, String name) async {
    Credential _credential = Credential(
        email: email, password: password, name: name, type: AuthType.email);
    print(_credential.email + " " + _credential.type.toString());
    dynamic result = await iAuthApi.signUp(_credential);
    if (result.isError) return result.asError;

    return Result.value(OtpMessage.fromJson(result.asValue.value));
  }
}
