import 'dart:developer';

import 'package:ccarev2_frontend/cache/ilocal_store.dart';
import 'package:ccarev2_frontend/main/domain/examination.dart' as exam;
import 'package:ccarev2_frontend/main/domain/hubResponse.dart';
import 'package:ccarev2_frontend/main/domain/main_api_contract.dart';
import 'package:ccarev2_frontend/main/domain/mixReport.dart';
import 'package:ccarev2_frontend/main/domain/question.dart';
import 'package:ccarev2_frontend/main/domain/spokeResponse.dart';
import 'package:ccarev2_frontend/main/domain/treatment.dart' as treat;
import 'package:ccarev2_frontend/main/domain/treatment.dart';
import 'package:ccarev2_frontend/user/domain/location.dart' as loc;
import 'package:ccarev2_frontend/user/domain/profile.dart';
import 'package:ccarev2_frontend/user/domain/token.dart';
import 'package:cubit/cubit.dart';
import 'package:image_picker/image_picker.dart';
import 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  final ILocalStore localStore;
  final IMainAPI api;
  MainCubit(this.localStore, this.api) : super(IntialState());

  getQuestions() async {
    //_startLoading("getQuestions");

    final token = await localStore.fetch();
    final result = await api.getAll(Token(token.value));

    if (result.isError) {
      emit(
          NewErrorState(result.asError!.error as String, "QuestionnaireState"));
      return;
    }
    emit(QuestionnaireState(result.asValue!.value));
  }

  selfAssessment() async {
    //_startLoading("getQuestions");

    final token = await localStore.fetch();
    final result = await api.getAll(Token(token.value));

    if (result.isError) {
      emit(ErrorState(result.asError!.error as String));
      return;
    }
    emit(SelfAssessmentState(result.asValue!.value));
  }

  loadMessages(String patientID) async {
    // _startLoading("loadMessages");
    final token = await localStore.fetch();
    final result = await api.getAllMessages(token, patientID);
    if (result.isError) {
      print(
          'LOG > main_cubit.dart > 39 > result.asError!.errror: ${result.asError!.error}');
      emit(ErrorState(result.asError!.error as String));
      return;
    }
    print(
        'LOG > main_cubit.dart > 39 > result.asValue!.value.last: ${result.asValue!.value.last}');
    emit(MessagesLoadedState(result.asValue!.value));
  }

  recentHistory() async {
    final token = await localStore.fetch();
    //print("fetchToken ${token.value}");
    final result = await api.fetchLastReport(
      Token(token.value),
    );

    if (result.isError) {
      emit(NewErrorState(result.asError!.error as String, "PreviousHistory"));
      return;
    }
    emit(PreviousHistory(result.asValue!.value));
  }

  fetchToken() async {
    // _startLoading("loadMessages");
    final token = await localStore.fetch();
    //print("fetchToken ${token.value}");
    // if(token==null)

    // final result = await api.getAllMessages(token, patientID);
    // if (result.isError) {
    //   emit(ErrorState(result.asError!.error as String));
    //   return;
    // }
    Future.delayed(Duration(milliseconds: 50), () {
      emit(TokenLoadedState(token.value));
    });
  }

  getAssessments(String patientID) async {
    _startLoading("getAssessments");
    final token = await localStore.fetch();
    final result = await api.getAssessments(token, patientID);
    if (result.isError) {
      emit(NoResponseState(result.asError!.error as String));
      return;
    }
    emit(AssessmentLoaded(result.asValue!.value));
  }

  editResponse() async {
    emit(ResponseEdit());
  }

  notify(String action, bool ambRequired, loc.Location location,
      {List<QuestionTree>? assessment}) async {
    //print("Inside Notify");
    _startLoading("notify");
    final token = await localStore.fetch();
    final result = await api.notify(
        Token(token.value),
        //  loc.Location(latitude: 31.7091367, longitude: 76.5236728),
        location,
        action,
        ambRequired,
        assessment: assessment);

    if (result.isError) {
      emit(ErrorState(result.asError!.error as String));
      return;
    }
    emit(EmergencyState(result.asValue!.value));
  }

  acceptRequest(String patientID) async {
    _startLoading("AcceptRequest");
    //print(patientID);
    if (patientID == null) {
      emit(ErrorState("Invalid ID of patient!"));
      return;
    }
    emit(AcceptState(patientID));
  }

  acceptPatientBySpoke(String patientID) async {
    _startLoading("AcceptPatientbySpoke");
    final token = await localStore.fetch();
    final result =
        await api.acceptPatientbySpoke(Token(token.value), Token(patientID));
    log('LOG > main_cubit.dart > 92 > result.asValue!.value: ${result.asValue!.value}');
    if (result.isError) {
      emit(ErrorState(result.asError!.error as String));
      return;
    }
    emit(PatientAccepted(result.asValue!.value));
  }

  getPatientReportingTime(String patientID) async {
    _startLoading("Get Patient Reporting Time Loading State");
    final token = await localStore.fetch();
    final result = await api.fetchPatientReportingTime(
        Token(token.value), Token(patientID));
    log('LOG > main_cubit.dart > getPatientReportingTime > 105 > result.asValue!.value: ${result.asValue!.value}');
    if (result.isError) {
      emit(ErrorState(result.asError!.error as String));
      return;
    }
    emit(ReportingTimeFetched(result.asValue!.value));
  }

  acceptPatientByHub(String patientID) async {
    _startLoading("AcceptPatientbyHub");
    final token = await localStore.fetch();
    final result =
        await api.acceptPatientbyHub(Token(token.value), Token(patientID));
    if (result.isError) {
      print(
          'LOG > main_cubit.dart > acceptPatientByHub > 140 > result.asError!.error: ${result.asError!.error}');
      emit(ErrorState(result.asError!.error as String));
      return;
    }
    print(
        'LOG > main_cubit.dart > acceptPatientByHub > 129 > result.asValue!.value: ${result.asValue!.value}');
    emit(AcceptState(patientID));
  }

  fetchHubPatientDetails() async {
    //  _startLoading("Fetch Hub Patient Details");
    final token = await localStore.fetch();
    final result = await api.fetchHubPatientDetails(Token(token.value));
    if (result.isError) {
      print(
          'LOG > main_cubit.dart > fetchHubPatientDetails > 140 > result.asError!.error: ${result.asError!.error}');
      emit(NoPatientAccepted(result.asError!.error as String, 'HUB PATIENTS'));
      return;
    }
    print(
        'LOG > main_cubit.dart > fetchHubPatientDetails > 129 > result.asValue!.value: ${result.asValue!.value}');
    emit(HubPatientsLoaded(result.asValue!.value));
  }

  fetchHubRequests() async {
    //_startLoading("Fetch Hub Consultation Requests");
    print('Inside fetchHubRequests');
    final token = await localStore.fetch();
    final result = await api.fetchHubRequests(Token(token.value));
    if (result.isError) {
      print(
          'LOG > main_cubit.dart > fetchHubRequests > 140 > result.asError!.error: ${result.asError!.error}');
      emit(NoPatientRequested(result.asError!.error as String, 'HUB REQUESTS'));
      return;
    }
    print(
        'LOG > main_cubit.dart > fetchHubRequests > 140 > result.asValue!.value: ${result.asValue!.value}');
    emit(HubRequestsLoaded(result.asValue!.value));
  }

  getAllPatients() async {
    // _startLoading("Get All Patients");
    final token = await localStore.fetch();
    final result = await api.getAllPatients(Token(token.value));
    log('LOG > main_cubit.dart > getAllPatients > 153 > result.asValue!.value: ${result.asValue!.value}');
    if (result.isError) {
      emit(ErrorState(result.asError!.error as String));
      return;
    }
    emit(PatientsLoaded(result.asValue!.value));
  }

  getAllPatientRequests() async {
    // _startLoading("Get All Patient Requests");
    final token = await localStore.fetch();
    final result = await api.getAllPatientRequests(Token(token.value));
    if (result.isError) {
      emit(ErrorState(result.asError!.error as String));
      return;
    }
    emit(RequestsLoaded(result.asValue!.value));
  }

  fetchPatientReportHistory(String patientID) async {
    // _startLoading("PatientReportHistoryFetch");
    final token = await localStore.fetch();
    final result =
        await api.fetchPatientReportHistory(Token(token.value), patientID);
    if (result.isError) {
      emit(NoHistoryState(result.asError!.error as String));
      return;
    }
    List<treat.TreatmentReport> reports = result.asValue!.value;

    emit(PatientReportHistoryFetched(reports));
  }

  fetchPatientReport(String? patientID) async {
    // _startLoading("PatientReportFetch");
    final token = await localStore.fetch();
    final result = await api.fetchPatientReport(Token(token.value), patientID);
    //print(result);
    if (result == null) {
      emit(NoReportState("No report exists"));
      return;
    }
    // log('LOG > main_cubit.dart > fetchPatientReport > 164 > result.asValue!.value["currentReport"]: ${result.asValue!.value["currentReport"]}');
    emit(PatientReportFetched(MixReport(result.asValue!.value["currentReport"],
        result.asValue!.value["previousReport"])));
  }

  editPatientReport() async {
    // _startLoading("PatientReport - Edit");
    emit(EditPatientReport("editing patient report"));
  }

  imageClicked(XFile image, String type, String patID,
      treat.TreatmentReport report, int seq_no) async {
    // _startLoading("Image Clicked");
    final token = await localStore.fetch();
    final result =
        await this.api.uploadImage(token, image, type, patID, seq_no);
    if (result.isError) {
      emit(ErrorState(result.asError!.error as String));
      return;
    }
    emit(ImageCaptured("Image Clicked", result.asValue!.value.split('#')[1],
        result.asValue!.value.split('#')[2]));
    //#FIXME: ad all the images somehow
    report.ecg.ecg_file_ids = [
      ECGFile(
          file_id: result.asValue!.value.split('#')[1],
          seq_no: seq_no.toString())
    ];
    report.ecg.ecg_time = result.asValue!.value.split('#')[2];
    final result2 =
        await api.savePatientReport(Token(token.value), report, patID);
    if (result2.isError) {
      emit(ErrorState(result.asError!.error as String));
      return;
    }
    emit(PatientReportSaved("Saved"));
  }

  uploadChatImage(XFile image) async {
    // _startLoading("Image Clicked");
    final token = await localStore.fetch();
    final result = await this.api.uploadChatImage(token, image);
    if (result.isError) {
      emit(ErrorState(result.asError!.error as String));
      return;
    }
    emit(ChatImageUploaded(result.asValue!.value));
  }

  caseClose(String patientID) async {
    final token = await localStore.fetch();
    final result = await this.api.caseClose(token, patientID);

    if (result.isError) {
      print(result.asError?.error);
      emit(ErrorState(result.asError!.error as String));
      return;
    }
    emit(CaseClosedState(result.asValue!.value));
  }

  addPatient(PatientProfile patientProfile, String phone_number) async {
    _startLoading("Add Patient");
    final token = await localStore.fetch();
    final result =
        await api.addPatient(Token(token.value), patientProfile, phone_number);
    if (result.isError) {
      emit(ErrorState(result.asError!.error as String));
      return;
    }
    emit(PatientAdded());
  }

  fetchResponse(String patientID) async {
    _startLoading("Fetch Response");
    final token = await localStore.fetch();
    final result = await api.getConsultationResponse(token, patientID);
    if (result.isError) {
      emit(NoResponseState(result.asError!.error as String));
      return;
    }
    emit(ResponsesLoaded(result.asValue!.value["hubResponse"],
        result.asValue!.value["spokeResponse"]));
  }

  updateHubResponse(String patientID, HubResponse hubResponse) async {
    _startLoading("Update Hub Response");
    final token = await localStore.fetch();
    final result = await api.updateHubResponse(token, patientID, hubResponse);
    if (result.isError) {
      emit(ErrorState(result.asError!.error as String));
      return;
    }
    emit(HubResponseUpdated(result.asValue!.value));
  }

  updateSpokeResponse(String patientID, SpokeResponse spokeResponse) async {
    _startLoading("Update Spoke Response");
    final token = await localStore.fetch();
    final result =
        await api.updateSpokeResponse(token, patientID, spokeResponse);
    if (result.isError) {
      emit(ErrorState(result.asError!.error as String));
      return;
    }
    emit(SpokeResponseUpdated(result.asValue!.value));
  }

  fetchImage(String patientID) async {
    _startLoading("Image Clicked");
    final token = await localStore.fetch();
    final result = await this.api.fetchImage(token, patientID);
    if (result.isError) {
      emit(ErrorState(result.asError!.error as String));
      return;
    }
    emit(ImageLoaded(result.asValue!.value));
  }

  viewPatientReport() async {
    // _startLoading("PatientReport - View/Save");
    emit(ViewPatientReport("viewing patient report"));
  }

  savePatientReport(treat.TreatmentReport report, String? patientID) async {
    // _startLoading("PatientReportSaved");
    final token = await localStore.fetch();
    final result =
        await api.savePatientReport(Token(token.value), report, patientID);
    //print("Result ${result.asValue!.value}");

    if (result.isError) {
      emit(ErrorState(result.asError!.error as String));
      return;
    }
    emit(PatientReportSaved("Saved"));
  }

  fetchPatientExamReport(String patientID) async {
//    _startLoading("PatientReportFetch");
    final token = await localStore.fetch();
    final result =
        await api.fetchPatientExamReport(Token(token.value), patientID);
    log('LOG > main_cubit.dart > fetchPatientExamReport > 226 > result.asValue!.value: ${result.asValue!.value}');
    if (result == null) {
      emit(NoReportState("Server Error"));
      return;
    }
    if (result.isError) {
      emit(ErrorState(result.asError!.error as String));
      return;
    }
    emit(PatientExamReportFetched(result.asValue!.value));
  }

  editPatientExamReport() async {
    // _startLoading("PatientReportEdited");
    emit(EditPatientExamReport("editing patient report"));
  }

  viewPatientExamReport() async {
    // _startLoading("PatientReportViewed");
    emit(ViewPatientExamReport("viewing patient report"));
  }

  savePatientExamReport(exam.Examination ereport, String patientID) async {
    // _startLoading("PatientReportSaved");
    final token = await localStore.fetch();
    final result =
        await api.savePatientExamReport(Token(token.value), ereport, patientID);
    //print("Result ${result.asValue!.value}");
    if (result == null) {
      emit(ErrorState("Server Error"));
      return;
    }
    if (result.isError) {
      emit(ErrorState(result.asError!.error as String));
      return;
    }
    emit(PatientExamReportSaved("Saved"));
  }

  editExaminationReport(bool val) async {
    // _startLoading("Edit Examination Report");
    emit(EditExaminationReport(!val));
  }

  acceptPatientByDriver(String patientID) async {
    _startLoading("AcceptPatientbydriver");
    final token = await localStore.fetch();
    final result =
        await api.acceptPatientbyDriver(Token(token.value), Token(patientID));
    //print("Result ${result.asValue!.value}");

    if (result.isError) {
      emit(ErrorState(result.asError!.error as String));
      return;
    }
    emit(PatientAccepted(result.asValue!.value));
  }

  doctorAccepted(loc.Location location) async {
    //print("Inside doctor accepted");
    if (location == null) {
      emit(ErrorState("Details not fetched!"));
      return;
    }
    emit(DoctorAccepted(location));
  }

  driverAccepted(loc.Location location) async {
    //print("Inside driver accepted");
    if (location == null) {
      emit(ErrorState("Location Error!"));
      return;
    }
    emit(DriverAccepted(location));
  }

  getAllHubDoctors() async {
    _startLoading("GET ALL HUB DOCTORS LOADING STATE");
    //print("MAIN CUBIT/GET ALL HUB DOCTORS");
    final token = await localStore.fetch();
    final result = await api.getAllHubDoctors(token);

    if (result.isError) {
      emit(ErrorState(result.asError!.error as String));
      return;
    }
    emit(AllHubDoctorsState(result.asValue!.value));
  }

  spokeStatusFetched() async {
    //_startLoading("Hub Accepted");
    emit(StatusFetched(''));
  }

  consultHub(String uid, String patientID) async {
    _startLoading("CONSULT HUB LOADING STATE");
    //print("MAIN CUBIT/CONSULT HUB DOCTORS");
    final token = await localStore.fetch();
    final result = await api.consultHub(token, uid, patientID);

    if (result.isError) {
      emit(ErrorState(result.asError!.error as String));
      return;
    }
    emit(ConsultHub(result.asValue!.value));
  }

  fetchEmergencyDetails({String? patientID}) async {
    //  _startLoading("fetchEmergencyDetails");
    print('DATA > main_cubit.dart > 387 > Inside fetchEmergencyDetails');
    final token = await localStore.fetch();
    final result = await api.fetchEmergencyDetails(token, patientID: patientID);
    if (result.isError) {
      print(
          'DATA > main_cubit.dart > 391 > Inside error of fetchEmergencyDetails');
      emit(NewErrorState(result.asError!.error as String, "DetailsLoaded"));
      return;
    }
    emit(DetailsLoaded(result.asValue!.value));
  }

  statusUpdate(String status, {String? patientID}) async {
    _startLoading("Updating Status");
    print('DATA > main_cubit.dart > 399 > Inside statusUpdate');
    final token = await localStore.fetch();
    final result = await api.updateStatus(token, status, patientID);
    if (result.isError) {
      emit(ErrorState(result.asError!.error as String));
      return;
    }
    emit(NormalState(result.asValue!.value));
    //can emit a state
  }

  getStatus() async {
    //_startLoading("Fetching Status");
    log('DATA > main_cubit.dart > 411 > GET STATUS');
    final token = await localStore.fetch();
    final result = await api.getStatus(token);
    if (result.isError) {
      emit(ErrorState(result.asError!.error as String));
      return;
    }
    emit(StatusFetched(result.asValue!.value));
  }

  generateNewReport(String patientID) async {
    // _startLoading("Updating Status");
    final token = await localStore.fetch();
    final result = await api.newReport(token, patientID);
    if (result.isError) {
      emit(ErrorState(result.asError!.error as String));
      return;
    }
    emit(NewReportGenerated(result.asValue!.value));
  }

  chatLoading() async {
    emit(ChatLoadingState());
  }

  patientInfoLoading() async {
    emit(PatientInfoLoadingState());
  }

  void _startLoading(String from) {
    print(from);
    emit(LoadingState());
  }
}
