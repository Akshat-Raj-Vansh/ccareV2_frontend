//@dart=2.9
import 'package:ccarev2_frontend/cache/ilocal_store.dart';
import 'package:ccarev2_frontend/main/domain/main_api_contract.dart';
import 'package:ccarev2_frontend/state_management/emergency/emergency_state.dart';
import 'package:ccarev2_frontend/user/domain/location.dart';
import 'package:ccarev2_frontend/user/domain/token.dart';
import 'package:cubit/cubit.dart';

class EmergencyCubit extends Cubit<EmergencyState> {
  final ILocalStore localStore;
  final IMainAPI api;
  EmergencyCubit(this.localStore, this.api) : super(InitialState());

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
  }

  acceptPatientByDriver(String patientID) async {
    print("Inside accept patient by driver");
    _startLoading();
    final token = await localStore.fetch();
    final result =
        await api.acceptPatientbyDriver(Token(token.value), Token(patientID));
    print(result);
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

  void _startLoading() {
    emit(LoadingEmergencyState());
  }
}
