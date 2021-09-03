import 'package:ccarev2_frontend/user/domain/location.dart';
import 'package:equatable/equatable.dart';

abstract class EmergencyState extends Equatable {}

class InitialState extends EmergencyState {
  @override
  List<Object> get props => [];
}

class LoadingEmergencyState extends EmergencyState {
  @override
  List<Object> get props => [];
}

class PatientAccepted extends EmergencyState {
  final Location location;
  PatientAccepted(this.location);
  @override
  List<Object> get props => [location];
}

class DoctorAccepted extends EmergencyState {
  final Location location;
  DoctorAccepted(this.location);
  @override
  List<Object> get props => [location];
}

class DriverAccepted extends EmergencyState {
  final Location location;
  DriverAccepted(this.location);
  @override
  List<Object> get props => [location];
}

class ErrorState extends EmergencyState {
  final String error;
  ErrorState(this.error);
  @override
  List<Object> get props => [error];
}
