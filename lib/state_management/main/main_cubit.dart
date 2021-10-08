//@dart=2.9

import 'package:ccarev2_frontend/cache/ilocal_store.dart';
import 'package:ccarev2_frontend/main/domain/examination.dart';
import 'package:ccarev2_frontend/main/domain/main_api_contract.dart';
import 'package:ccarev2_frontend/main/domain/report.dart';
import 'package:ccarev2_frontend/user/domain/location.dart';
import 'package:ccarev2_frontend/user/domain/token.dart';
import 'package:cubit/cubit.dart';
import 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  final ILocalStore localStore;
  final IMainAPI api;
  MainCubit(this.localStore, this.api) : super(IntialState());

  getQuestions() async {
    _startLoading("getQuestions");

    final token = await localStore.fetch();
    final result = await api.getAll(Token(token.value));

    if (result == null) emit(ErrorState("Server Error"));
    if (result.isError) {
      emit(ErrorState(result.asError.error));
      return;
    }
    emit(QuestionnaireState(result.asValue.value));
  }

  notify() async {
    print("Inside Notify");
    _startLoading("notify");
    final token = await localStore.fetch();
    final result = await api.notify(
        Token(token.value), Location(latitude: 32.82, longitude: 76.14));
    print(result);
    if (result == null) emit(ErrorState("Server Error"));
    if (result.isError) {
      emit(ErrorState(result.asError.error));
      return;
    }
    emit(EmergencyState(result.asValue.value));
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

  acceptPatientByDoctor(String patientID) async {
    _startLoading("AcceptPatientbydoctor");
    final token = await localStore.fetch();
    final result =
        await api.acceptPatientbyDoctor(Token(token.value), Token(patientID));
    print(result);
    if (result == null) emit(ErrorState("Server Error"));
    if (result.isError) {
      emit(ErrorState(result.asError.error));
      return;
    }
    emit(PatientAccepted(result.asValue.value));
  }

  fetchPatientReport() async {
    _startLoading("PatientReportFetch");
    final token = await localStore.fetch();
    final result = await api.fetchPatientReport(Token(token.value));
    if (result == null) {
      emit(NoReportState("Server Error"));
      return;
    }
    if (result.isError) {
      emit(NoReportState(result.asError.error));
      return;
    }
    emit(PatientReportFetched(result.asValue.value));
  }

  editPatientReport() async {
    // print(report.toJson());
    _startLoading("PatientReportEdited");
    emit(EditPatientReport("editing patient report"));
  }

  viewPatientReport() async {
    _startLoading("PatientReportViewed");
    emit(ViewPatientReport("viewing patient report"));
  }

  savePatientReport(Report report) async {
    _startLoading("PatientReportSaved");
    final token = await localStore.fetch();
    final result = await api.savePatientReport(Token(token.value), report);
    print("Result ${result.asValue.value}");
    if (result == null) {
      emit(ErrorState("Server Error"));
      return;
    }
    if (result.isError) {
      emit(ErrorState(result.asError.error));
      return;
    }
    emit(PatientReportSaved("Saved"));
  }

  fetchPatientExamReport() async {
    _startLoading("PatientReportFetch");
    final token = await localStore.fetch();
    final result = await api.fetchPatientExamReport(Token(token.value));
    if (result == null) {
      emit(NoReportState("Server Error"));
      return;
    }
    if (result.isError) {
      emit(NoReportState(result.asError.error));
      return;
    }
    emit(PatientExamReportFetched(result.asValue.value));
  }

  editPatientExamReport() async {
    // print(report.toJson());
    _startLoading("PatientReportEdited");
    emit(EditPatientExamReport("editing patient report"));
  }

  viewPatientExamReport() async {
    _startLoading("PatientReportViewed");
    emit(ViewPatientExamReport("viewing patient report"));
  }

  savePatientExamReport(Examination ereport) async {
    _startLoading("PatientReportSaved");
    final token = await localStore.fetch();
    final result = await api.savePatientExamReport(Token(token.value), ereport);
    print("Result ${result.asValue.value}");
    if (result == null) {
      emit(ErrorState("Server Error"));
      return;
    }
    if (result.isError) {
      emit(ErrorState(result.asError.error));
      return;
    }
    emit(PatientExamReportSaved("Saved"));
  }

  acceptPatientByDriver(String patientID) async {
    _startLoading("AcceptPatientbydriver");
    final token = await localStore.fetch();
    final result =
        await api.acceptPatientbyDriver(Token(token.value), Token(patientID));
    print("Result ${result.asValue.value}");
    if (result == null) {
      emit(ErrorState("Server Error"));
      return;
    }
    if (result.isError) {
      emit(ErrorState(result.asError.error));
      return;
    }
    emit(PatientAccepted(result.asValue.value));
  }

  doctorAccepted(Location location) async {
    print("Inside doctor accepted");
    if (location == null) {
      emit(ErrorState("Details not fetched!"));
      return;
    }
    emit(DoctorAccepted(location));
  }

  driverAccepted(Location location) async {
    print("Inside driver accepted");
    if (location == null) {
      emit(ErrorState("Location Error!"));
      return;
    }
    emit(DriverAccepted(location));
  }

  getAllPatients() async {
    print("Inside get all patients");
    _startLoading("getAllpatients");
    final token = await localStore.fetch();
    final result = await api.getAllPatients(token);
    print(result);
    if (result == null) emit(ErrorState("Server Error"));
    if (result.isError) {
      emit(ErrorState(result.asError.error));
      return;
    }
    emit(AllPatientsState(result.asValue.value));
  }

  fetchEmergencyDetails() async {
    _startLoading("fetchEmergencyDetails");
    final token = await localStore.fetch();
    final result = await api.fetchEmergencyDetails(token);
    if (result == null) emit(ErrorState("Server Error"));
    if (result.isError) {
      emit(NormalState(result.asError.error));
      return;
    }
    emit(DetailsLoaded(result.asValue.value));
  }

  void _startLoading(String from) {
    print(from);
    emit(LoadingState());
  }
}
