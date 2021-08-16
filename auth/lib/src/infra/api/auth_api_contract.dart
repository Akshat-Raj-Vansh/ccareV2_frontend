import '../../domain/token.dart';
import '../../domain/credential.dart';
import 'package:async/async.dart';

abstract class IAuthApi {
  Future<Result<String>> signIn(Credential credential);
  Future<Result<String>> signUp(Credential credential);
  Future<Result<bool>> signOut(Token token);
  Future<Result<String>> verify(String otp, Token token);
  Future<Result<String>> resend(Token token);
  Future<Result<String>> register(Credential credential);
}
