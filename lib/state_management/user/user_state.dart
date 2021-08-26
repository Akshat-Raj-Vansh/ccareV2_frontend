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
  @override
  List<Object> get props => [];
}

class OTPVerificationState extends UserState {
  @override
  List<Object> get props => [];
}

class VerificationSuccess extends UserState {
  final Credential credential;
  VerificationSuccess(this.credential);
  @override
  List<Object> get props => [credential];
}

class ResendOTPState extends UserState {
  final Credential credential;
  ResendOTPState(this.credential);
  @override
  List<Object> get props => [credential];
}

class OTPState extends UserState {
  @override
  List<Object> get props => [];
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
