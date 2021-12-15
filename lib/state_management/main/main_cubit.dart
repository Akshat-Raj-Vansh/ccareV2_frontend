import 'dart:developer';

import 'package:ccarev2_frontend/cache/ilocal_store.dart';
import 'package:ccarev2_frontend/main/domain/examination.dart' as exam;
import 'package:ccarev2_frontend/main/domain/main_api_contract.dart';
import 'package:ccarev2_frontend/main/domain/mixReport.dart';
import 'package:ccarev2_frontend/main/domain/question.dart';
import 'package:ccarev2_frontend/main/domain/treatment.dart' as treat;
import 'package:ccarev2_frontend/user/domain/location.dart' as loc;
import 'package:ccarev2_frontend/user/domain/token.dart';
import 'package:cubit/cubit.dart';
import 'package:image_picker/image_picker.dart';
import 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  final ILocalStore localStore;
  final IMainAPI api;
  MainCubit(this.localStore, this.api) : super(IntialState());

  getQuestions() async {
    _startLoading("getQuestions");

    final token = await localStore.fetch();
    final result = await api.getAll(Token(token.value));

    if (result.isError) {
      emit(ErrorState(result.asError!.error as String));
      return;
    }
    emit(QuestionnaireState(result.asValue!.value));
  }

  loadMessages(String patientID) async {
    // _startLoading("loadMessages");
    final token = await localStore.fetch();
    final result = await api.getAllMessages(token, patientID);
    if (result.isError) {
      emit(ErrorState(result.asError!.error as String));
      return;
    }
    log('LOG > main_cubit.dart > 39 > result.asValue!.value.last: ${result.asValue!.value.last}');
    emit(MessagesLoadedState(result.asValue!.value));
  }

  fetchToken() async {
    // _startLoading("loadMessages");
    final token = await localStore.fetch();
    print("fetchToken ${token.value}");
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

  notify(String action, bool ambRequired,
      {List<QuestionTree>? assessment}) async {
    print("Inside Notify");
    _startLoading("notify");
    final token = await localStore.fetch();
    final result = await api.notify(Token(token.value),
        loc.Location(latitude: 32.82, longitude: 76.14), action, ambRequired,
        assessment: assessment);

    if (result.isError) {
      emit(ErrorState(result.asError!.error as String));
      return;
    }
    emit(EmergencyState(result.asValue!.value));
  }

  acceptRequest(String patientID) async {
    _startLoading("AcceptRequest");
    print(patientID);
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
      emit(ErrorState(result.asError!.error as String));
      return;
    }
    emit(PatientAcceptedHub());
  }

  fetchHubPatientDetails() async {
    _startLoading("Fetch Hub Patient Details");
    final token = await localStore.fetch();
    final result = await api.fetchHubPatientDetails(Token(token.value));
    log('LOG > main_cubit.dart > fetchHubPatientDetails > 129 > result.asValue!.value: ${result.asValue!.value}');
    if (result.isError) {
      emit(ErrorState(result.asError!.error as String));
      return;
    }
    emit(HubPatientsLoaded(result.asValue!.value));
  }

  fetchHubRequests() async {
    _startLoading("Fetch Hub Consultation Requests");
    final token = await localStore.fetch();
    final result = await api.fetchHubRequests(Token(token.value));
    log('LOG > main_cubit.dart > fetchHubRequests > 140 > result.asValue!.value: ${result.asValue!.value}');
    if (result.isError) {
      emit(ErrorState(result.asError!.error as String));
      return;
    }
    emit(HubRequestsLoaded(result.asValue!.value));
  }

  getAllPatients() async {
    _startLoading("Get All Patients");
    final token = await localStore.fetch();
    final result = await api.getAllPatients(Token(token.value));
    log('LOG > main_cubit.dart > getAllPatients > 153 > result.asValue!.value: ${result.asValue!.value}');
    if (result.isError) {
      emit(ErrorState(result.asError!.error as String));
      return;
    }
    emit(PatientsLoaded(result.asValue!.value));
  }

  fetchPatientReportHistory() async {
    _startLoading("PatientReportHistoryFetch");
    final token = await localStore.fetch();
    final result = await api.fetchPatientReportHistory(Token(token.value));
    if (result.isError) {
      emit(ErrorState(result.asError!.error as String));
      return;
    }
    List<treat.TreatmentReport> reports = result.asValue!.value;

    emit(PatientReportHistoryFetched(reports));
  }

  fetchPatientReport() async {
    // _startLoading("PatientReportFetch");
    final token = await localStore.fetch();
    final result = await api.fetchPatientReport(Token(token.value));
    log('LOG > main_cubit.dart > fetchPatientReport > 164 > result.asValue!.value["currentReport"]: ${result.asValue!.value["currentReport"]}');
    if (result == null) {
      emit(NoReportState("No report exists"));
      return;
    }
    if (result.isError) {
      emit(ErrorState(result.asError!.error as String));
      return;
    }
    emit(PatientReportFetched(MixReport(result.asValue!.value["currentReport"],
        result.asValue!.value["previousReport"])));
  }

  editPatientReport() async {
    _startLoading("PatientReport - Edit");
    emit(EditPatientReport("editing patient report"));
  }

  imageClicked(XFile image, String type) async {
    _startLoading("Image Clicked");
    final token = await localStore.fetch();
    final result = await this.api.uploadImage(token, image, type);
    if (result.isError) {
      emit(ErrorState(result.asError!.error as String));
      return;
    }
    emit(ImageCaptured("Image Clicked"));
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
    _startLoading("PatientReport - View/Save");
    emit(ViewPatientReport("viewing patient report"));
  }

  savePatientReport(treat.TreatmentReport report) async {
    _startLoading("PatientReportSaved");
    final token = await localStore.fetch();
    final result = await api.savePatientReport(Token(token.value), report);
    print("Result ${result.asValue!.value}");

    if (result.isError) {
      emit(ErrorState(result.asError!.error as String));
      return;
    }
    emit(PatientReportSaved("Saved"));
  }

  fetchPatientExamReport() async {
    _startLoading("PatientReportFetch");
    final token = await localStore.fetch();
    final result = await api.fetchPatientExamReport(Token(token.value));
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
    _startLoading("PatientReportEdited");
    emit(EditPatientExamReport("editing patient report"));
  }

  viewPatientExamReport() async {
    _startLoading("PatientReportViewed");
    emit(ViewPatientExamReport("viewing patient report"));
  }

  savePatientExamReport(exam.Examination ereport) async {
    _startLoading("PatientReportSaved");
    final token = await localStore.fetch();
    final result = await api.savePatientExamReport(Token(token.value), ereport);
    print("Result ${result.asValue!.value}");
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
    _startLoading("Edit Examination Report");
    emit(EditExaminationReport(!val));
  }

  acceptPatientByDriver(String patientID) async {
    _startLoading("AcceptPatientbydriver");
    final token = await localStore.fetch();
    final result =
        await api.acceptPatientbyDriver(Token(token.value), Token(patientID));
    print("Result ${result.asValue!.value}");

    if (result.isError) {
      emit(ErrorState(result.asError!.error as String));
      return;
    }
    emit(PatientAccepted(result.asValue!.value));
  }

  doctorAccepted(loc.Location location) async {
    print("Inside doctor accepted");
    if (location == null) {
      emit(ErrorState("Details not fetched!"));
      return;
    }
    emit(DoctorAccepted(location));
  }

  driverAccepted(loc.Location location) async {
    print("Inside driver accepted");
    if (location == null) {
      emit(ErrorState("Location Error!"));
      return;
    }
    emit(DriverAccepted(location));
  }

  // getAllPatients() async {
  //   print("Inside get all patients");
  //   _startLoading("getAllpatients");
  //   final token = await localStore.fetch();
  //   final result = await api.getAllPatients(token);

  //   if (result.isError) {
  //     emit(ErrorState(result.asError!.error as String));
  //     return;
  //   }
  //   emit(AllPatientsState(result.asValue!.value));
  // }

  getAllHubDoctors() async {
    _startLoading("GET ALL HUB DOCTORS LOADING STATE");
    print("MAIN CUBIT/GET ALL HUB DOCTORS");
    final token = await localStore.fetch();
    final result = await api.getAllHubDoctors(token);

    if (result.isError) {
      emit(ErrorState(result.asError!.error as String));
      return;
    }
    emit(AllHubDoctorsState(result.asValue!.value));
  }

  consultHub(String uid) async {
    _startLoading("CONSULT HUB LOADING STATE");
    print("MAIN CUBIT/CONSULT HUB DOCTORS");
    final token = await localStore.fetch();
    final result = await api.consultHub(token, uid);

    if (result.isError) {
      emit(ErrorState(result.asError!.error as String));
      return;
    }
    emit(ConsultHub(result.asValue!.value));
  }

  fetchEmergencyDetails(String patientID) async {
    _startLoading("fetchEmergencyDetails");
    final token = await localStore.fetch();
    final result = await api.fetchEmergencyDetails(token, patientID);
    if (result.isError) {
      emit(NormalState(result.asError!.error as String));
      return;
    }
    emit(DetailsLoaded(result.asValue!.value));
  }

  statusUpdate(String status) async {
    _startLoading("Updating Status");
    final token = await localStore.fetch();
    final result = await api.updateStatus(token, status);
    if (result.isError) {
      emit(ErrorState(result.asError!.error as String));
      return;
    }
    emit(NormalState(result.asValue!.value));
    //can emit a state
  }

  getStatus() async {
    _startLoading("Fetching Status");
    final token = await localStore.fetch();
    final result = await api.getStatus(token);
    if (result.isError) {
      emit(ErrorState(result.asError!.error as String));
      return;
    }
    emit(StatusFetched(result.asValue!.value));
  }

  generateNewReport() async {
    _startLoading("Updating Status");
    final token = await localStore.fetch();
    final result = await api.newReport(token);
    if (result.isError) {
      emit(ErrorState(result.asError!.error as String));
      return;
    }
    emit(NewReportGenerated(result.asValue!.value));
  }

  void _startLoading(String from) {
    print(from);
    emit(LoadingState());
  }
}
