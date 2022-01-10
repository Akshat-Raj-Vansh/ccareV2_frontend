import 'package:async/async.dart';
import 'package:ccarev2_frontend/main/domain/edetails.dart';
import 'package:ccarev2_frontend/main/domain/examination.dart' as exam;
import 'package:ccarev2_frontend/main/domain/treatment.dart';
import 'package:ccarev2_frontend/pages/chat/components/message.dart';
import 'package:ccarev2_frontend/user/domain/doc_info.dart';
import 'package:ccarev2_frontend/user/domain/emergency.dart';
import 'package:ccarev2_frontend/user/domain/hub_doc_info.dart';
import 'package:ccarev2_frontend/user/domain/location.dart' as loc;
import 'package:ccarev2_frontend/user/domain/patient_list_info.dart';
import 'package:image_picker/image_picker.dart';
import '../../user/domain/token.dart';
import 'question.dart';

abstract class IMainAPI {
  // General API
  Future<Result<String>> getStatus(Token token);
  Future<Result<String>> fetchPatientReportingTime(Token token, Token patient);

  // Patient Side APIs
  Future<Result<List<QuestionTree>>> getAll(Token token);
  Future<Result<TreatmentReport>> fetchLastReport(Token token);
  Future<Result<String>> emergencyRequest(Token token, Emergency emergency);
  Future<Result<String>> notify(
      Token token, loc.Location location, String action, bool ambRequired,
      {List<QuestionTree>? assessment});

  // Doctors Side APIs
  Future<Result<EDetails>> fetchEmergencyDetails(Token token,
      {String? patientID});
  Future<Result<dynamic>> fetchPatientReport(Token token);
  Future<Result<dynamic>> fetchPatientReportHistory(Token token);
  Future<Result<exam.Examination>> fetchPatientExamReport(Token token);
  Future<Result<List<Message>>> getAllMessages(Token token, String patientID);

  // Spoke Side APIs
  Future<Result<loc.Location>> acceptPatientbySpoke(Token token, Token patient);
  Future<Result<List<PatientListInfo>>> getAllPatientRequests(Token token);
  Future<Result<List<PatientListInfo>>> getAllPatients(Token token);
  Future<Result<List<HubInfo>>> getAllHubDoctors(Token token);
  Future<Result<String>> savePatientReport(Token token, TreatmentReport report);
  Future<Result<String>> savePatientExamReport(
      Token token, exam.Examination examination);
  Future<Result<String>> updateStatus(Token token, String status);
  Future<Result<String>> consultHub(Token token, String docID);
  Future<Result<String>> uploadImage(Token token, XFile image, String type);
  Future<Result<XFile>> fetchImage(Token token, String patientID);
  Future<Result<String>> newReport(Token token);

  // Driver Side APIs
  Future<Result<loc.Location>> acceptPatientbyDriver(
      Token token, Token patient);

  // Hub Side APIs
  Future<Result<dynamic>> acceptPatientbyHub(Token token, Token patient);
  Future<Result<List<EDetails>>> fetchHubRequests(Token token);

  Future<Result<List<EDetails>>> fetchHubPatientDetails(Token token);
}
