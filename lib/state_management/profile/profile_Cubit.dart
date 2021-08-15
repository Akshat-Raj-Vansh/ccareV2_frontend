//@dart=2.9
import 'package:async/src/result/result.dart';
import '../../../state_management/profile/profile_State.dart';
import 'package:cubit/cubit.dart';

import '../../cache/IlocalStore.dart';
import 'package:profile/profile.dart';
import 'package:auth/auth.dart' as auth;

class ProfileCubit extends Cubit<ProfileState> {
  final ILocalStore localStore;
  final IProfileApi api;
  ProfileCubit(this.localStore, this.api) : super(IntialState());

  updateProfile(Profile profile) async {
    _startLoading();

    final token = await this.localStore.fetch();
    final result = await this.api.updateProfile(Token(token.value), profile);
    if (result == null) emit(ErrorState("Server Error"));
    if (result.isError) {
      emit(ErrorState(result.asError.error));
      return;
    }
    emit(ProfileUpdateState(result.asValue.value));
  }

  getProfile(Profile profile) async {
    _startLoading();

    final token = await this.localStore.fetch();
    final result = await this.api.getProfile(Token(token.value));
    if (result == null) emit(ErrorState("Server Error"));
    if (result.isError) {
      emit(ErrorState(result.asError.error));
      return;
    }
    emit(ProfileGetState(result.asValue.value));
  }

  void _startLoading() {
    emit(LoadingState());
  }
}
