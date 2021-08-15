import 'package:equatable/equatable.dart';
import 'package:profile/profile.dart';

abstract class ProfileState extends Equatable{}

class IntialState extends ProfileState{
  @override
  // TODO: implement props
  List<Object> get props => [];}

  class LoadingState extends ProfileState{
  @override
  // TODO: implement props
  List<Object> get props => [];

  }

  class ProfileUpdateState extends ProfileState{
  final String message;
  ProfileUpdateState(this.message){}
  @override
  // TODO: implement props
  List<Object> get props => [this.message];

  }

  class ErrorState extends ProfileState{
  final String error;
  ErrorState(this.error){}
  @override
  // TODO: implement props
  List<Object> get props => [this.error];

  }

  class ProfileGetState extends ProfileState{
    final Profile profile;
    ProfileGetState(this.profile){}
  @override
  // TODO: implement props
  List<Object> get props => [this.profile];

  }