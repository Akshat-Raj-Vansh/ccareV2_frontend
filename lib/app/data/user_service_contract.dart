import 'package:async/async.dart';
import './credential.dart';
import './details.dart';
import './profile.dart';
import './token.dart';

abstract class UserService {
  Future<Result<Details>> loginOld(Credential credential);
  Future<Result<dynamic>> loginNew(Credential credential);
  Future<Result<String>> addPatientProfile(Token token, PatientProfile profile);
  Future<Result<String>> addDoctorProfile(Token token, DoctorProfile profile);
  Future<Result<String>> addDriverProfile(Token token, DriverProfile profile);
}
