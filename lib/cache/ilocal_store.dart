import 'package:auth/auth.dart';

abstract class ILocalStore {
  Future<Token> fetch();
  delete();
  save(Details details);
  saveTempToken(String token);
  Future<Token> fetchTempToken();
}
