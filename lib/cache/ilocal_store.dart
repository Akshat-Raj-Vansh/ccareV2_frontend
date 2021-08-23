import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:ccarev2_frontend/user/domain/token.dart';

abstract class ILocalStore {
  Future<Token> fetch();
  delete();
  save(Credential credential);
  saveTempToken(String token);
  Future<Token> fetchTempToken();
  saveUserType(UserType type);
  Future<UserType> fetchUserType();
}
