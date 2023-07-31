import 'package:async/async.dart';
import 'package:ccarev2_frontend/main/domain/assessment.dart';
import 'package:ccarev2_frontend/main/domain/edetails.dart';
import 'package:ccarev2_frontend/main/domain/examination.dart' as exam;
import 'package:ccarev2_frontend/main/domain/hubResponse.dart';
import 'package:ccarev2_frontend/main/domain/spokeResponse.dart';
import 'package:ccarev2_frontend/main/domain/treatment.dart';
import 'package:ccarev2_frontend/pages/chat/components/message.dart';
import 'package:ccarev2_frontend/user/domain/emergency.dart';
import 'package:ccarev2_frontend/user/domain/location.dart' as loc;
import 'package:ccarev2_frontend/user/domain/patient_list_info.dart';
import 'package:ccarev2_frontend/user/domain/profile.dart';
import 'package:image_picker/image_picker.dart';
import '../../user/domain/token.dart';
import 'question.dart';

abstract class IMainAPI {
  // General API
  Future<Result<String>> getStatus(Token token);
  Future<Result<String>> fetchPatientReportingTime(Token token, Token patient);
  Future<Result<List<PatientAssessment>>> getAssessments(
      Token token, String patientID);

  // Patient Side APIs
  Future<Result<List<QuestionTree>>> getAll(Token token);
  Future<Result<TreatmentReport>> fetchLastReport(Token token);
  Future<Result<String>> emergencyRequest(Token token, Emergency emergency);
  Future<Result<String>> notify(
      Token token, loc.Location location, String action, bool ambRequired,
      {List<QuestionTree>? assessment});

  // Doctors Side APIs
  Future<Result<dynamic>> getConsultationResponse(
      Token token, String patientID);
  Future<Result<String>> uploadChatImage(Token token, XFile image);
  Future<Result<EDetails>> fetchEmergencyDetails(Token token,
      {String? patientID});
  Future<Result<dynamic>> fetchPatientReport(Token token, String? patID);
  Future<Result<dynamic>> fetchPatientReportHistory(Token token, String patID);
  Future<Result<exam.Examination>> fetchPatientExamReport(
      Token token, String patID);
  Future<Result<List<Message>>> getAllMessages(Token token, String patientID);

  // Spoke Side APIs
  Future<Result<String>> updateSpokeResponse(
      Token token, String patientID, SpokeResponse spokeResponse);
  Future<Result<String>> addPatient(
      Token token, PatientProfile patientProfile, String phone_number);
  Future<Result<String>> caseClose(Token token, String patientID);
  Future<Result<loc.Location>> acceptPatientbySpoke(Token token, Token patient);
  Future<Result<List<PatientListInfo>>> getAllPatientRequests(Token token);
  Future<Result<List<PatientListInfo>>> getAllPatients(Token token);
  Future<Result<List<String>>> getAllHubDoctors(Token token);
  Future<Result<String>> savePatientReport(
      Token token, TreatmentReport report, String? patID);
  Future<Result<String>> savePatientExamReport(
      Token token, exam.Examination examination, String patID);
  Future<Result<String>> updateStatus(
      Token token, String status, String? patientID);
  Future<Result<String>> consultHub(
      Token token, String hopitalName, String patID);
  Future<Result<String>> uploadImage(
      Token token, XFile image, String type, String patID, int seq_no);
  Future<Result<XFile>> fetchImage(Token token, String patientID);
  Future<Result<String>> newReport(Token token, String patientID);

  // Driver Side APIs
  Future<Result<loc.Location>> acceptPatientbyDriver(
      Token token, Token patient);

  // Hub Side APIs
  Future<Result<String>> updateHubResponse(
      Token token, String patientID, HubResponse hubResponse);
  Future<Result<dynamic>> acceptPatientbyHub(Token token, Token patient);
  Future<Result<List<EDetails>>> fetchHubRequests(Token token);

  Future<Result<List<EDetails>>> fetchHubPatientDetails(Token token);
}
