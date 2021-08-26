import 'package:async/async.dart';
import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:ccarev2_frontend/user/domain/details.dart';
import 'package:ccarev2_frontend/user/domain/profile.dart';
import 'package:ccarev2_frontend/user/domain/token.dart';

abstract class UserService {
  Future<Result<Details>> login(Credential credential);

  Future<Result<String>> addPatientProfile(Token token, PatientProfile profile);
  Future<Result<String>> addDoctorProfile(Token token, DoctorProfile profile);

  // Future<Result<String>> verifyPhone(String phone);
  // Future<Result<String>> verifyOTP(String otp, String vid);
}
