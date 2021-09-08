import 'package:ccarev2_frontend/main/domain/elocation.dart';
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
  // TODO: implement props
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
  final Location location;
  DoctorAccepted(this.location);
  @override
  List<Object> get props => [location];
}

class LocationsLoaded extends MainState {
  final ELocations eLocations;
  LocationsLoaded(this.eLocations);
  @override
  List<Object> get props => [this.eLocations];
}

class DriverAccepted extends MainState {
  final Location location;
  DriverAccepted(this.location);
  @override
  List<Object> get props => [location];
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
