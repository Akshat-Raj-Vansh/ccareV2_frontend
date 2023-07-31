import 'package:ccarev2_frontend/user/domain/details.dart';
import 'package:ccarev2_frontend/user/domain/profile.dart';
import 'package:ccarev2_frontend/user/domain/token.dart';
import 'package:ccarev2_frontend/user/infra/user_api.dart';
import 'profile_state.dart';
import 'package:cubit/cubit.dart';

import '../../cache/ilocal_store.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ILocalStore localStore;
  final UserAPI api;
  ProfileCubit(this.localStore, this.api) : super(IntialState());

  addPatientProfile(PatientProfile profile) async {
    _startLoading();
    final token = await this.localStore.fetch();
    Details details = await this.localStore.fetchDetails();
    final result = await api.addPatientProfile(Token(token.value), profile);
    if (result == null) emit(ErrorState("Server Error"));
    if (result.isError) {
      emit(ErrorState(result.asError.error));
      return;
    }
    await this.localStore.updateNewUser(false);
    emit(AddProfileState(details));
  }

  getDocInfo() async {
    emit(LoadingDocInfo());
    //print("PROFILE CUBIT/GET DOC INFO PROFILE");
    final docInfo = await this.localStore.fetchDocInfo();
    if (docInfo == null) {
      //print("DOC NOT FOUND");
      Future.delayed(Duration(seconds: 1), () {
        emit(DocNotFoundState());
      });
      return;
    } else {
      //print('DOC INFO JSON:');
      //print(docInfo.toJson());
      Future.delayed(Duration(milliseconds: 100), () {
        emit(DocInfoState(docInfo));
      });
    }
  }

  addDoctorProfile(DoctorProfile profile) async {
    //print("PROFILE CUBIT/ADD DOCTOR PROFILE");
    _startLoading();
    final token = await this.localStore.fetch();
    final result = await api.addDoctorProfile(Token(token.value), profile);
    if (result == null) emit(ErrorState("Server Error"));
    if (result.isError) {
      emit(ErrorState(result.asError.error));
      return;
    }
    await this.localStore.updateNewUser(false);
    Details details = await this.localStore.fetchDetails();
    //print("DETAILS:");
    //print(details.toJson());
    emit(AddProfileState(details));
  }

  searchDoctor(String hospital) async {
    _startLoading();
    final token = await this.localStore.fetch();
    //   final result = await api.addDoctorProfile(Token(token.value), profile);
    // if (result == null) emit(ErrorState("Server Error"));
    // if (result.isError) {
    //   emit(ErrorState(result.asError.error));
    //   return;
    // }
    // await this.localStore.updateDetail(false);
    // emit(AddProfileState(result.asValue.value));
  }

  addDriverProfile(DriverProfile profile) async {
    _startLoading();

    final token = await this.localStore.fetch();
    Details details = await this.localStore.fetchDetails();
    final result = await api.addDriverProfile(Token(token.value), profile);
    if (result == null) emit(ErrorState("Server Error"));
    if (result.isError) {
      emit(ErrorState(result.asError.error));
      return;
    }
    await this.localStore.updateNewUser(false);
    emit(AddProfileState(details));
  }

  void _startLoading() {
    emit(LoadingState());
  }
}
