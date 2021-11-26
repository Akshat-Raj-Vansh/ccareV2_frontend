import 'package:async/async.dart';
import 'package:ccarev2_frontend/main/domain/edetails.dart';
import 'package:ccarev2_frontend/main/domain/examination.dart' as exam;
import 'package:ccarev2_frontend/main/domain/treatment.dart';
import 'package:ccarev2_frontend/user/domain/doc_info.dart';
import 'package:ccarev2_frontend/user/domain/emergency.dart';
import 'package:ccarev2_frontend/user/domain/hub_doc_info.dart';
import 'package:ccarev2_frontend/user/domain/location.dart' as loc;
import '../../user/domain/token.dart';
import 'question.dart';

abstract class IMainAPI {
  // Patient Side APIs
  Future<Result<List<QuestionTree>>> getAll(Token token);
  Future<Result<String>> emergencyRequest(Token token, Emergency emergency);
  Future<Result<String>> notify(
      Token token, loc.Location location, String action, bool ambRequired,
      {List<QuestionTree>? assessment});

  // Doctors Side APIs
  Future<Result<EDetails>> fetchEmergencyDetails(Token token);
  Future<Result<TreatmentReport>> fetchPatientReport(Token token);
  Future<Result<dynamic>> fetchPatientReportHistory(Token token);
  Future<Result<exam.Examination>> fetchPatientExamReport(Token token);

  // Spoke Side APIs
  Future<Result<loc.Location>> acceptPatientbySpoke(Token token, Token patient);
  Future<Result<String>> getAllPatients(Token token);
  Future<Result<List<HubInfo>>> getAllHubDoctors(Token token);
  Future<Result<String>> savePatientReport(Token token, TreatmentReport report);
  Future<Result<String>> savePatientExamReport(
      Token token, exam.Examination examination);
  Future<Result<String>> updateStatus(Token token, String status);
  Future<Result<String>> consultHub(Token token, String docID);

  // Driver Side APIs
  Future<Result<loc.Location>> acceptPatientbyDriver(
      Token token, Token patient);

  // Hub Side APIs
  Future<Result<dynamic>> acceptPatientbyHub(Token token, Token patient);
  Future<Result<EDetails>> fetchHubPatientDetails(Token token);
}
