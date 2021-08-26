import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:ccarev2_frontend/user/domain/details.dart';
import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {}

class InitialState extends UserState {
  @override
  List<Object> get props => [];
}

class LoadingState extends UserState {
  @override
  List<Object> get props => [];
}

class PhoneVerificationState extends UserState {
  final Credential credential;
  PhoneVerificationState(this.credential);
  @override
  List<Object> get props => [credential];
}

class OTPVerificationState extends UserState {
  final Credential credential;
  OTPVerificationState(this.credential);
  @override
  List<Object> get props => [credential];
}

class LoginSuccessState extends UserState {
  final Details details;
  LoginSuccessState(this.details);
  @override
  List<Object> get props => [details];
}

class ErrorState extends UserState {
  final String error;
  ErrorState(this.error);
  @override
  List<Object> get props => [error];
}

// class SignOutSuccesState extends UserState {
//   @override
//   List<Object> get props => [];
// }

// class OTPState extends UserState {
//   String message;
//   OTPState(this.message) {}
//   @override
//   List<Object> get props => [message];
// }
