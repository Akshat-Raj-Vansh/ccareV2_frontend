import 'package:auth/src/domain/credential.dart';

import 'package:auth/src/domain/otpMessage.dart';
import 'package:auth/src/domain/register_service_contract.dart';
import 'package:auth/src/infra/api/auth_api_contract.dart';

import 'package:async/async.dart';

class RegisterService implements IRegisterService {
  final IAuthApi iAuthApi;

  RegisterService(this.iAuthApi);

  Future<Result<OtpMessage>> register(String phone) async {
    Credential _credential = Credential(phone: phone, type: AuthType.phone);
    print(_credential.email + " " + _credential.type.toString());
    dynamic result = await iAuthApi.register(_credential);
    if (result.isError) return result.asError;

    return Result.value(OtpMessage.fromJson(result.asValue.value));
  }
}
