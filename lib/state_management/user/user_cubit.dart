//@dart=2.9
import 'dart:convert';

import 'package:async/src/result/result.dart';
import 'package:ccarev2_frontend/user/domain/details.dart';
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
    final result = await userAPI.login(credential);
    if (result == null) print("result is null");
    _setResultOfAuthState(result);
  }

  verifyPhone() async {
    _startLoading();
    emit(PhoneVerificationState());
  }

  verifyOTP() async {
    emit(OTPVerificationState());
  }

  void signOut() async {
    await this.localStore.delete();
    emit(SignOutSuccessState());
  }

  void _setResultOfAuthState(Result<dynamic> result) {
    if (result.asError != null) {
      emit(ErrorState(result.asError.error));
      return;
    }
    if (result.asValue.value is Details) {
      localStore.save(result.asValue.value as Details);
      print('INSIDE USER CUBIT/LOGIN');
      print('DETAILS:');
      print((result.asValue.value as Details).toJson());
      emit(LoginSuccessState(result.asValue.value as Details));
    }
  }

  void _startLoading() {
    emit(LoadingState());
  }
}
