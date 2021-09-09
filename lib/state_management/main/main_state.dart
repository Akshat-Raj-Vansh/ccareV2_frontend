import 'package:ccarev2_frontend/main/domain/edetails.dart';
import 'package:ccarev2_frontend/user/domain/location.dart';
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
  List<Object> get props => [];
}

class AcceptState extends MainState {
  final String msg;
  AcceptState(this.msg);
  @override
  List<Object> get props => [msg];
}

class PatientAccepted extends MainState {
  final Location location;
  PatientAccepted(this.location);
  @override
  List<Object> get props => [location];
}

class DoctorAccepted extends MainState {
  final DoctorDetails doctorDetails;
  DoctorAccepted(this.doctorDetails);
  @override
  List<Object> get props => [doctorDetails];
}

class DriverAccepted extends MainState {
  final DriverDetails driverDetails;
  DriverAccepted(this.driverDetails);
  @override
  List<Object> get props => [driverDetails];
}

class DetailsLoaded extends MainState {
  final EDetails eDetails;
  DetailsLoaded(this.eDetails);
  @override
  List<Object> get props => [this.eDetails];
}

class QuestionnaireState extends MainState {
  final List<QuestionTree> questions;
  QuestionnaireState(this.questions);
  @override
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
