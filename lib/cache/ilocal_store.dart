import 'package:auth/auth.dart';

abstract class ILocalStore {
  Future<Token> fetch();
  delete();
  save(PDetails details);
  saveTempToken(String token);
  Future<Token> fetchTempToken();
  saveAuthType(AuthType type);
  Future<AuthType> fetchAuthType();
}
