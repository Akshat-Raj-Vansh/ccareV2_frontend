//@dart=2.9
import 'dart:convert';

import 'package:async/src/result/result.dart';
import 'package:ccarev2_frontend/user/domain/details.dart';
import 'package:ccarev2_frontend/user/domain/doc_info.dart';
import 'package:ccarev2_frontend/user/domain/token.dart';
import 'package:ccarev2_frontend/user/infra/user_api.dart';
import 'package:cubit/cubit.dart';

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
    _startLoading();
    final result = await userAPI.loginNew(credential);
    if (result == null) //print("result is null");
    _setResultOfAuthStateNew(result);
  }

  verifyPhone(String phone) async {
    _startLoading();
    //print('INSIDE verifyPhone');
    Future.delayed(Duration(milliseconds: 3));
    emit(PhoneVerificationState(phone));
  }

  verifyOTP() async {
    emit(OTPVerificationState());
  }

  void signOut() async {
    await this.localStore.delete();
    emit(SignOutSuccessState());
  }

  // void _setResultOfAuthState(Result<dynamic> result) {
  //   if (result.asError != null) {
  //     emit(ErrorState(result.asError.error));
  //     return;
  //   }
  //   if (result.asValue.value is Details) {
  //     localStore.save(result.asValue.value as Details);
  //     //print('INSIDE USER CUBIT/LOGIN');
  //     //print('DETAILS:');
  //     //print((result.asValue.value as Details).toJson());
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
        //print("NEW DOCTOR");
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
