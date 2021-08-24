import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:ccarev2_frontend/user/domain/details.dart';
import 'package:ccarev2_frontend/user/domain/token.dart';

abstract class ILocalStore {
  Future<Token> fetch();
  delete();
  save(Details details);
  saveTempToken(String token);
  Future<Token> fetchTempToken();
  saveUserType(UserType type);
  Future<UserType> fetchUserType();
}
