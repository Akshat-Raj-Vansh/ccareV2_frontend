import 'package:async/async.dart';
import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:ccarev2_frontend/user/domain/profile.dart';
import 'package:ccarev2_frontend/user/domain/token.dart';

abstract class UserService {
  Future<Result<String>> login(Credential credential);
  // Future<Result<String>> verify(String phone);
  Future<Result<bool>> logout(Token token);

  // Future<Result<PatientProfile>> getPatientProfile(Token token);
  // Future<Result<DoctorProfile>> getDoctorProfile(Token token);

  Future<Result<String>> addPatientProfile(Token token, PatientProfile profile);
  Future<Result<String>> addDoctorProfile(Token token, DoctorProfile profile);
}
