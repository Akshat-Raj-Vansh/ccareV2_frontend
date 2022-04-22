//@dart=2.9
import 'dart:convert';

import 'package:async/src/result/result.dart';
import 'package:ccarev2_frontend/user/domain/details.dart';
import 'package:ccarev2_frontend/user/domain/doc_info.dart';
import 'package:ccarev2_frontend/user/domain/token.dart';
import 'package:ccarev2_frontend/user/infra/user_api.dart';
import 'package:cubit/cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../user/domain/credential.dart';
import '../../state_management/user/user_state.dart';
import '../../cache/ilocal_store.dart';

class UserCubit extends Cubit<UserState> {
  final ILocalStore localStore;
  final UserAPI userAPI;
  UserCubit(
    this.localStore,
    this.userAPI,
  ) : super(InitialState());

  login(Credential credential) async {
    // _startLoading();
    emit(LoginInProcessState());
    final result = await userAPI.loginNew(credential);

    _setResultOfAuthStateNew(result);
  }

  verifyPhone(String phone) async {
    //_startLoading();
    //  emit(LoginInProcessState());
    Future.delayed(Duration(milliseconds: 3));
    emit(PhoneVerificationState(phone));
  }

  verifyOTP() async {
    Future.delayed(Duration(milliseconds: 3));
    emit(OTPVerificationState());
  }

  void signOut() async {
    await this.localStore.delete();
    await FirebaseAuth.instance.signOut();
    emit(SignOutSuccessState());
  }

  // void _setResultOfAuthState(Result<dynamic> result) {
  //   if (result.asError != null) {
  //     emit(ErrorState(result.asError.error));
  //     return;
  //   }
  //   if (result.asValue.value is Details) {
  //     localStore.save(result.asValue.value as Details);
  //     emit(LoginSuccessState(result.asValue.value as Details));
  //   }
  // }

  void _setResultOfAuthStateNew(Result<dynamic> result) {
    if (result.asError != null) {
      emit(ErrorState(result.asError.error));
      return;
    }
    Details details = Details.fromJson(jsonEncode(result.asValue.value));
    localStore.save(details);
    if (details.newUser &&
        (details.user_type == UserType.SPOKE ||
            details.user_type == UserType.HUB)) {
      if (result.asValue.value["name"] == null) {
        emit(LoginSuccessState(details));
        return;
      }
      Info docInfo = Info.fromJson(jsonEncode(result.asValue.value));
      localStore.saveInfo(docInfo);
    }
    emit(LoginSuccessState(details));
  }

  void _startLoading() {
    emit(LoadingState());
  }
}
