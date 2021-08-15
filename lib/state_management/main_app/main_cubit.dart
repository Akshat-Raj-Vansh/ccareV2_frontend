//@dart=2.9
import 'package:async/src/result/result.dart';
import 'package:cubit/cubit.dart';
import 'package:extras/extras.dart';
import '../../cache/IlocalStore.dart';
import 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  final ILocalStore localStore;
  final IMainApi api;
  MainCubit(this.localStore, this.api) : super(IntialState());

  getQuestions() async {
    print("inside");
    _startLoading();

    final token = await this.localStore.fetch();

    final result = await this.api.getAll(Token(token.value));
    print(result);
    if (result == null) emit(ErrorState("Server Error"));
    if (result.isError) {
      emit(ErrorState(result.asError.error));
      return;
    }
    emit(QuestionnaireState(result.asValue.value));
  }

  getCurrentPatients() async {
    print("inside get current patients");
    _startLoading();

    final token = await this.localStore.fetch();
    final result = await this.api.getCurrentPatients(Token(token.value));

    print('result of getCurrentPatients:' + result.toString());
    if (result == null) emit(ErrorState("Server Error"));
    if (result.isError) {
      emit(ErrorState(result.asError.error));
      return;
    }
    emit(PatientLoadedState(result.asValue.value));
  }

  getWaitingList() async {
    print("inside get waiting list");
    _startLoading();

    final token = await this.localStore.fetch();
    final result = await this.api.getWaitingList(Token(token.value));

    print(result);
    if (result == null) emit(ErrorState("Server Error"));
    if (result.isError) {
      emit(ErrorState(result.asError.error));
      return;
    }
    emit(PatientWaitingState(result.asValue.value));
  }

  acceptPatient(String userId) async {
    print("inside accept patient");
    _startLoading();

    final token = await this.localStore.fetch();
    final result = await this.api.acceptPatient(Token(token.value), userId);

    print(result);
    if (result == null) emit(ErrorState("Server Error"));
    if (result.isError) {
      emit(ErrorState(result.asError.error));
      return;
    }
    emit(PatientsState(result.asValue.value));
  }

  void _startLoading() {
    emit(LoadingState());
  }
}
