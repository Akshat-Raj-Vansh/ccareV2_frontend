import 'package:ccarev2_frontend/user/domain/details.dart';
import 'package:ccarev2_frontend/user/domain/profile.dart';
import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {}

class IntialState extends ProfileState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadingState extends ProfileState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class AddProfileState extends ProfileState {
  final Details details;
  AddProfileState(this.details);
  @override
  List<Object> get props => [details];
}

class ErrorState extends ProfileState {
  final String error;
  ErrorState(this.error) {}
  @override
  List<Object> get props => [this.error];
}
