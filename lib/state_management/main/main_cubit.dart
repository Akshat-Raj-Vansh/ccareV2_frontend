//@dart=2.9
import 'dart:convert';

import 'package:async/src/result/result.dart';
import 'package:ccarev2_frontend/cache/ilocal_store.dart';
import 'package:ccarev2_frontend/main/domain/edetails.dart';
import 'package:ccarev2_frontend/main/domain/main_api_contract.dart';
import 'package:ccarev2_frontend/user/domain/location.dart';
import 'package:ccarev2_frontend/user/domain/temp.dart';
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

  saveTempVars(Temp temp) async {
    await localStore.saveTemp(temp);
  }

  getTempVars() async {
    _startLoading("getTempVars");
    final temp = await localStore.fetchTemp();
    print(temp.notificationSent);
    if (temp == null) {
      emit(ErrorState("Cache Error"));
      return;
    }
    emit(ValuesLoadedState(temp));
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
    // _startLoading();

    // print(location);
    if (location == null) {
      emit(ErrorState("Details not fetched!"));
      return;
    }
    emit(DoctorAccepted(location));
  }

  driverAccepted(Location location) async {
    print("Inside driver accepted");
    // _startLoading();
    // print(location);
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
