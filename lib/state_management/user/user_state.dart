import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {}

class InitialState extends UserState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadingState extends UserState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoginSuccessState extends UserState {
  final Credential details;
  LoginSuccessState(this.details) {}
  @override
  List<Object> get props => [this.details];
}

class ErrorState extends UserState {
  final String error;
  ErrorState(this.error) {}
  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class SignOutSuccesState extends UserState {
  @override
  List<Object> get props => [];
}

class OTPState extends UserState {
  String message;
  OTPState(this.message) {}
  @override
  List<Object> get props => [message];
}
