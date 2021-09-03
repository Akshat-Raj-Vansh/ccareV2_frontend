import 'package:equatable/equatable.dart';
import '../../main/domain/question.dart';

abstract class MainState extends Equatable {}

class IntialState extends MainState {
  @override
  List<Object> get props => [];
}

class LoadingState extends MainState {
  @override
  List<Object> get props => [];
}

class AcceptState extends MainState {
  final String msg;
  AcceptState(this.msg);
  @override
  List<Object> get props => [msg];
}

// class PatientArrived extends MainState {
//   final Location location;
//   PatientArrived(this.location);
//   @override
//   List<Object> get props => [location];
// }

// class DoctorAccepted extends MainState {
//   final Location location;
//   DoctorAccepted(this.location);
//   @override
//   List<Object> get props => [location];
// }

// class DriverAccepted extends MainState {
//   final Location location;
//   DriverAccepted(this.location);
//   @override
//   List<Object> get props => [location];
// }

class QuestionnaireState extends MainState {
  final List<QuestionTree> questions;
  QuestionnaireState(this.questions);
  @override
  List<Object> get props => [this.questions];
}

class HelpState extends MainState {
  final String msg;
  HelpState(this.msg);
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
  List<Object> get props => [this.error];
}
