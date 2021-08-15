import 'package:equatable/equatable.dart';
import 'package:extras/extras.dart';

abstract class MainState extends Equatable {}

class IntialState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class QuestionnaireState extends MainState {
  final List<QuestionTree> questions;
  QuestionnaireState(this.questions);
  @override
  // TODO: implement props
  List<Object> get props => [this.questions];
}

class PatientsState extends MainState {
  final String msg;
  PatientsState(this.msg);
  @override
  // TODO: implement props
  List<Object> get props => [this.msg];
}

class PatientLoadedState extends MainState {
  final List<MedicalProfile> profile;
  PatientLoadedState(this.profile);
  @override
  // TODO: implement props
  List<Object> get props => [this.profile];
}

class PatientWaitingState extends MainState {
  final List<MedicalProfile> profile;
  PatientWaitingState(this.profile);
  @override
  // TODO: implement props
  List<Object> get props => [this.profile];
}

class ErrorState extends MainState {
  final String error;
  ErrorState(this.error) {}
  @override
  // TODO: implement props
  List<Object> get props => [this.error];
}
