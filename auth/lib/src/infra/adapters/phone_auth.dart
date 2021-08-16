import 'package:async/async.dart';
import 'package:auth/src/domain/details.dart';
import 'package:auth/src/domain/otpMessage.dart';
import 'package:auth/src/domain/pdetails.dart';
import '../../domain/auth_service_contract.dart';
import '../../domain/token.dart';
import '../api/auth_api_contract.dart';

class PhoneAuth implements IAuthService {
  final IAuthApi iAuthApi;
  PhoneAuth(this.iAuthApi);

  @override
  Future<Result<bool>> signOut(Token token) async {
    return await iAuthApi.signOut(token);
  }

  Future<Result<PDetails>> verify(String otp, Token token) async {
    dynamic result = await iAuthApi.verify(otp, token);
    if (result.isError)
      return result.asError;
    else
      return Result.value(PDetails.fromJson(result.asValue.value));
  }

  Future<Result<OtpMessage>> resend(Token token) async {
    dynamic result = await iAuthApi.resend(token);
    if (result.isError)
      return result.asError;
    else
      return Result.value(OtpMessage.fromJson(result.asValue.value));
  }

  @override
  Future<Result<Details>> signIn() {
    throw UnimplementedError();
  }
}
