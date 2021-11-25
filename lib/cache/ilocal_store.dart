import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:ccarev2_frontend/user/domain/details.dart';
import 'package:ccarev2_frontend/user/domain/doc_info.dart';
import 'package:ccarev2_frontend/user/domain/profile.dart';
import 'package:ccarev2_frontend/user/domain/token.dart';

abstract class ILocalStore {
  Future<Token> fetch();
  Future<bool> fetchNewUser();
  delete();
  save(Details details);
  saveInfo(Info docInfo);
  updateNewUser(bool newUser);
  Future<Details> fetchDetails();
  Future<Info> fetchDocInfo();
  saveTempToken(String token);
  Future<Token> fetchTempToken();
}
