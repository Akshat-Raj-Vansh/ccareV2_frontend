import '../data/details.dart';
import '../data/doc_info.dart';
import '../data/token.dart';

abstract class ILocalStore {
  Future<Token>? fetch();
  Future<bool>? fetchNewUser();
  delete();
  save(Details details);
  saveInfo(Info docInfo);
  updateNewUser(bool newUser);
  Future<Details>? fetchDetails();
  Future<Info>? fetchDocInfo();
  saveTempToken(String token);
  Future<Token>? fetchTempToken();
}
