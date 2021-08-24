//@dart=2.9
import 'package:async/src/result/result.dart';
import 'package:ccarev2_frontend/user/domain/token.dart';
import 'package:ccarev2_frontend/user/infra/user_api.dart';
import 'package:cubit/cubit.dart';

import '../../user/domain/credential.dart';
import '../../state_management/user/user_state.dart';
import '../../cache/ilocal_store.dart';
import '../../user/domain/user_service_contract.dart';

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

  verify(String otp) async {
    _startLoading();
    final tempToken = await localStore.fetchTempToken();

    if (tempToken == null) {
      print("Error fetching the token");
      emit(ErrorState("Error fetching the token"));
    } else {
      final result = await userAPI.verify(otp);
      localStore.save(result.asValue.value as Credential);
      emit(LoginSuccessState(result.asValue.value as Credential));
    }
  }

  // resend(UserService userService) async {
  //   _startLoading();
  //   final tempToken = await localStore.fetchTempToken();

  //   if (tempToken == null) {
  //     print("Error fetching the token");
  //     emit(ErrorState("System Error. Please try to signup"));
  //   } else {
  //     final result = await userService.resend(tempToken);
  //     if (result.isError)
  //       emit(result.asError.error);
  //     else {
  //       await localStore.saveTempToken(result.asValue.value.otptoken);
  //       emit(OTPState(result.asValue.value.message));
  //     }
  //   }
  // }

  signout() async {
    _startLoading();
    final token = await localStore.fetch();
    if (token == null) {
      print("Error fetching the token");
      emit(ErrorState("Error fetching the token"));
    } else {
      final result = await userAPI.logout(token);

      if (result.asValue.value) {
        localStore.delete();
        emit(SignOutSuccesState());
      } else
        emit(ErrorState("Error logging out"));
    }
  }

  void _setResultOfAuthState(Result<dynamic> result) {
    if (result.asError != null) {
      emit(ErrorState(result.asError.error));
      return;
    }
    if (result.asValue.value is Credential) {
      localStore.save(result.asValue.value as Credential);
      emit(LoginSuccessState(result.asValue.value as Credential));
    }
    // if (result.asValue.value is OtpMessage) {
    //   print(result.asValue.value);
    //   var otp = result.asValue.value as OtpMessage;
    //   localStore.saveTempToken(otp.otptoken);
    //   emit(OTPState(otp.message));
    // }
  }

  void _startLoading() {
    emit(LoadingState());
  }
}
