import 'package:async/async.dart';
import 'package:ccarev2_frontend/main/domain/edetails.dart';
import 'package:ccarev2_frontend/main/domain/examination.dart' as exam;
import 'package:ccarev2_frontend/main/domain/treatment.dart';
import 'package:ccarev2_frontend/user/domain/emergency.dart';
import 'package:ccarev2_frontend/user/domain/location.dart' as loc;
import '../../user/domain/token.dart';
import 'question.dart';

abstract class IMainAPI {
  Future<Result<List<QuestionTree>>> getAll(Token token);
  //Future<Result<String>> notify(Token token, loc.Location location);
  Future<Result<String>> emergencyRequest(Token token, Emergency emergency);
  Future<Result<String>> notify(
      Token token, Location location, String action, bool ambRequired,
      {List<QuestionTree>? assessment});
  Future<Result<String>> getAllPatients(Token token);
  Future<Result<dynamic>> fetchPatientReportHistory(Token token);
  Future<Result<String>> savePatientReport(Token token, TreatmentReport report);
  Future<Result<TreatmentReport>> fetchPatientReport(Token token);
  Future<Result<String>> savePatientExamReport(
      Token token, exam.Examination examination);
  Future<Result<exam.Examination>> fetchPatientExamReport(Token token);
  Future<Result<loc.Location>> acceptPatientbyDoctor(
      Token token, Token patient);
  Future<Result<loc.Location>> acceptPatientbyDriver(
      Token token, Token patient);
  Future<Result<EDetails>> fetchEmergencyDetails(Token token);
  Future<Result<String>> updateStatus(Token token, String status);
}
