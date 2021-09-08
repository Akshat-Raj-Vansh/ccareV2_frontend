//@dart=2.9
import 'dart:convert';

import 'package:async/src/result/result.dart';
import 'package:ccarev2_frontend/cache/ilocal_store.dart';
import 'package:ccarev2_frontend/main/domain/main_api_contract.dart';
import 'package:ccarev2_frontend/user/domain/location.dart';
import 'package:ccarev2_frontend/user/domain/token.dart';
import 'package:cubit/cubit.dart';
import 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  final ILocalStore localStore;
  final IMainAPI api;
  MainCubit(this.localStore, this.api) : super(IntialState());

  getQuestions() async {
    print("inside");
    _startLoading();

    final token = await localStore.fetch();
    final result = await api.getAll(Token(token.value));
    print("RESULT");
    print(result);
    if (result == null) emit(ErrorState("Server Error"));
    if (result.isError) {
      emit(ErrorState(result.asError.error));
      return;
    }
    emit(QuestionnaireState(result.asValue.value));
  }

  notify() async {
    print("Inside Notify");
    _startLoading();
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

  acceptPatientByDoctor(String patientID) async {
    print("Inside Accept patient by doctor");
    _startLoading();
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
     await Future.delayed(Duration(seconds: 1));
    emit(AcceptState("Successfully Notified"));
  }

  acceptPatientByDriver(String patientID) async {
    print("Inside accept patient by driver");
    _startLoading();
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
    
    emit(AcceptState("Successfully Notified"));
    await Future.delayed(Duration(seconds: 1));
    emit(PatientAccepted(result.asValue.value));
  }

  doctorAccepted(Location location) async {
    print("Inside doctor accepted");
    _startLoading();

    print(location);
    if (location == null) {
      emit(ErrorState("Location Error!"));
      return;
    }
    emit(DoctorAccepted(location));
  }

  driverAccepted(Location location) async {
    print("Inside driver accepted");
    _startLoading();
    print(location);
    if (location == null) {
      emit(ErrorState("Location Error!"));
      return;
    }
    emit(DriverAccepted(location));
  }

  getAllPatients() async {
    print("Inside get all patients");
    _startLoading();
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


  fetchEmergencyLocation() async{
    // _startLoading();
    final token = await localStore.fetch();
    final result = await api.fetchEmergencyLocations(token);
    if (result == null) emit(ErrorState("Server Error"));
    if (result.isError) {
      emit(ErrorState(result.asError.error));
      return;
    }
     await Future.delayed(Duration(seconds: 1));
    emit(LocationsLoaded(result.asValue.value));
  }
  void _startLoading() {
    emit(LoadingState());
  }
}
