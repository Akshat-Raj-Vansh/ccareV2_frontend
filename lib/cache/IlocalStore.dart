import 'package:auth/auth.dart';

abstract class ILocalStore{
  Future<Token>fetch();
  delete();
  save(Details details);
  saveAuthType(AuthType type);
  Future<AuthType> fetchAuthType();
  saveTempToken(String token);
  Future<Token> fetchTempToken();
}