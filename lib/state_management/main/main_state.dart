import 'package:equatable/equatable.dart';
import '../../main/domain/question.dart';

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

class AcceptState extends MainState {
  final String msg;
  AcceptState(this.msg);
  @override
  List<Object> get props => [msg];
}

class QuestionnaireState extends MainState {
  final List<QuestionTree> questions;
  QuestionnaireState(this.questions);
  @override
  // TODO: implement props
  List<Object> get props => [this.questions];
}

class EmergencyState extends MainState {
  final String msg;
  EmergencyState(this.msg);
  @override
  List<Object> get props => [msg];
}

class AllPatientsState extends MainState {
  final String msg;
  AllPatientsState(this.msg);
  @override
  List<Object> get props => [msg];
}

class ErrorState extends MainState {
  final String error;
  ErrorState(this.error) {}
  @override
  // TODO: implement props
  List<Object> get props => [this.error];
}
