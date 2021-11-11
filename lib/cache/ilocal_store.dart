import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:ccarev2_frontend/user/domain/details.dart';
import 'package:ccarev2_frontend/user/domain/profile.dart';
import 'package:ccarev2_frontend/user/domain/token.dart';

abstract class ILocalStore {
  Future<Token> fetch();
  Future<bool> fetchNewUser();
  delete();
  save(Details details);
  updateNewUser(bool newUser);
  updateUserType(UserType type);
  updatePhoneNumber(String phone);
  updateDoctorType(DoctorType type);
  Future<Details> fetchDetails();
  saveTempToken(String token);
  Future<Token> fetchTempToken();
}
