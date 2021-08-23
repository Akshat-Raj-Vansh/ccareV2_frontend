//@dart=2.9
import 'package:async/src/result/result.dart';
import 'package:auth/auth.dart';
import 'package:cubit/cubit.dart';

import '../../cache/ilocal_store.dart';
import '../../models/users.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final ILocalStore localStore;
  AuthCubit(
    this.localStore,
  ) : super(IntialState());

  login(IRegisterService iRegisterService, String phone) async {
    _startLoading();
    //emit(OTPState("123456"));
    final result = await iRegisterService.register(phone);
    if (result == null) print("result is null");

    _setResultOfAuthState(result);
  }

  verify(PhoneAuth authService, String otp) async {
    _startLoading();
    final tempToken = await localStore.fetchTempToken();

    if (tempToken == null) {
      print("Error fetching the token");
      emit(ErrorState("Error fetching the token"));
    } else {
      final result = await authService.verify(otp, tempToken);
      localStore.save(result.asValue.value as PDetails);
      emit(LoginSuccessState(result.asValue.value));
    }
  }

  resend(PhoneAuth authService) async {
    _startLoading();
    final tempToken = await localStore.fetchTempToken();

    if (tempToken == null) {
      print("Error fetching the token");
      emit(ErrorState("System Error. Please try to signup"));
    } else {
      final result = await authService.resend(tempToken);
      if (result.isError)
        emit(result.asError.error);
      else {
        await localStore.saveTempToken(result.asValue.value.otptoken);
        emit(OTPState(result.asValue.value.message));
      }
    }
  }

  signout(IAuthService iAuthService) async {
    _startLoading();
    final token = await localStore.fetch();
    if (token == null) {
      print("Error fetching the token");
      emit(ErrorState("Error fetching the token"));
    } else {
      final result = await iAuthService.signOut(token);

      if (result.asValue.value) {
        localStore.delete();
        emit(SignOutSuccesState());
      } else
        emit(ErrorState("Error signing out"));
    }
  }

  void _setResultOfAuthState(Result<dynamic> result) {
    if (result.asError != null) {
      emit(ErrorState(result.asError.error));
      return;
    }
    if (result.asValue.value is PDetails) {
      localStore.save(result.asValue.value as PDetails);
      emit(AuthSuccessState(result.asValue.value));
    }
    if (result.asValue.value is OtpMessage) {
      print(result.asValue.value);
      var otp = result.asValue.value as OtpMessage;
      localStore.saveTempToken(otp.otptoken);
      emit(OTPState(otp.message));
    }
  }

  void _startLoading() {
    emit(LoadingState());
  }
}
