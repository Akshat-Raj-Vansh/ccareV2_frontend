import 'package:async/async.dart';
import 'package:flutter/foundation.dart';

import '../../domain/details.dart';
import '../../domain/otpMessage.dart';
import '../../domain/credential.dart';
import '../../domain/auth_service_contract.dart';
import '../../domain/token.dart';
import '../api/auth_api_contract.dart';

class EmailAuth implements IAuthService {
  final IAuthApi iAuthApi;
  Credential _credential;
  EmailAuth(this.iAuthApi);

  void credential({@required String email, @required String password}) {
    _credential =
        Credential(email: email, password: password, type: AuthType.email);
  }

  @override
  Future<Result<bool>> signOut(Token token) async {
    return await iAuthApi.signOut(token);
  }

  @override
  Future<Result<Details>> signIn() async {
    assert(_credential != null);
    dynamic result = await iAuthApi.signIn(_credential);
    if (result.isError)
      return result.asError;
    else
      return Result.value(Details.fromJson(result.asValue.value));
  }

  Future<Result<Details>> verify(String otp, Token token) async {
    dynamic result = await iAuthApi.verify(otp, token);
    if (result.isError)
      return result.asError;
    else
      return Result.value(Details.fromJson(result.asValue.value));
  }

  Future<Result<OtpMessage>> resend(Token token) async {
    dynamic result = await iAuthApi.resend(token);
    if (result.isError)
      return result.asError;
    else
      return Result.value(OtpMessage.fromJson(result.asValue.value));
  }
}
