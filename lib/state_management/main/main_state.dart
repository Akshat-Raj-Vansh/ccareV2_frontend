import 'package:ccarev2_frontend/cache/local_store.dart';
import 'package:ccarev2_frontend/main/domain/edetails.dart';
import 'package:ccarev2_frontend/main/domain/report.dart';
import 'package:ccarev2_frontend/services/Notifications/component/patient.dart';
import 'package:ccarev2_frontend/user/domain/location.dart';
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
  final String patientID;
  AcceptState(this.patientID);
  @override
  List<Object> get props => [patientID];
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

class DriverAccepted extends MainState {
  final Location location;
  DriverAccepted(this.location);
  @override
  List<Object> get props => [location];
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

class PatientReportFetched extends MainState {
  final Report report;
  PatientReportFetched(this.report);
  @override
  List<Object> get props => [this.report];
}

class PatientReportSaved extends MainState {
  final String msg;
  PatientReportSaved(this.msg);
  @override
  List<Object> get props => [this.msg];
}

class EmergencyState extends MainState {
  final String msg;
  EmergencyState(this.msg);
  @override
  List<Object> get props => [msg];
}

class NormalState extends MainState {
  final String msg;
  NormalState(this.msg);
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
