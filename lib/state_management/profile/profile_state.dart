import 'package:ccarev2_frontend/user/domain/details.dart';
import 'package:ccarev2_frontend/user/domain/doc_info.dart';
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

class LoadingDocInfo extends ProfileState {
  LoadingDocInfo();
  @override
  List<Object> get props => [];
}

class DocInfoState extends ProfileState {
  final Info docInfo;
  DocInfoState(this.docInfo);
  @override
  List<Object> get props => [this.docInfo];
}
class DocNotFoundState extends ProfileState {
  @override
  List<Object> get props => [];
}


class ErrorState extends ProfileState {
  final String error;
  ErrorState(this.error) {}
  @override
  List<Object> get props => [this.error];
}
