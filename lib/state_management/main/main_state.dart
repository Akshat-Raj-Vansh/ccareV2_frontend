import 'package:ccarev2_frontend/cache/local_store.dart';
import 'package:ccarev2_frontend/main/domain/assessment.dart';
import 'package:ccarev2_frontend/main/domain/edetails.dart';
import 'package:ccarev2_frontend/main/domain/examination.dart';
import 'package:ccarev2_frontend/main/domain/hubResponse.dart';
import 'package:ccarev2_frontend/main/domain/mixReport.dart';
import 'package:ccarev2_frontend/main/domain/spokeResponse.dart';
import 'package:ccarev2_frontend/main/domain/treatment.dart' as treat;
import 'package:ccarev2_frontend/pages/chat/components/message.dart';
import 'package:ccarev2_frontend/services/Notifications/component/patient.dart';
import 'package:ccarev2_frontend/user/domain/doc_info.dart';
import 'package:ccarev2_frontend/user/domain/hub_doc_info.dart';
import 'package:ccarev2_frontend/user/domain/location.dart';
import 'package:ccarev2_frontend/user/domain/patient_list_info.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
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

class ResponsesLoaded extends MainState {
  final HubResponse hubResponse;
  final SpokeResponse spokeResponse;
  ResponsesLoaded(this.hubResponse, this.spokeResponse);
  @override
  List<Object> get props => [hubResponse, spokeResponse];
}

class HubResponseUpdated extends MainState {
  final String message;
  HubResponseUpdated(this.message);
  @override
  List<Object> get props => [message];
}

class SpokeResponseUpdated extends MainState {
  final String message;
  SpokeResponseUpdated(this.message);
  @override
  List<Object> get props => [message];
}

class AssessmentLoaded extends MainState {
  final List<PatientAssessment> assessments;
  AssessmentLoaded(this.assessments);
  @override
  List<Object> get props => [assessments];
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

class PreviousHistory extends MainState {
  final treat.TreatmentReport treatmentReport;
  PreviousHistory(this.treatmentReport);
  @override
  List<Object> get props => [this.treatmentReport];
}

class QuestionnaireState extends MainState {
  final List<QuestionTree> questions;
  QuestionnaireState(this.questions);
  @override
  List<Object> get props => [this.questions];
}

class SelfAssessmentState extends MainState {
  final List<QuestionTree> questions;
  SelfAssessmentState(this.questions);
  @override
  List<Object> get props => [this.questions];
}

class PatientReportHistoryFetched extends MainState {
  final List<treat.TreatmentReport> reports;
  PatientReportHistoryFetched(this.reports);
  @override
  List<Object> get props => [this.reports];
}

class PatientReportFetched extends MainState {
  final MixReport mixReport;
  PatientReportFetched(this.mixReport);
  @override
  List<Object> get props => [this.mixReport];
}

class EditExaminationReport extends MainState {
  final bool value;
  EditExaminationReport(this.value);
  @override
  List<Object> get props => [this.value];
}

class PatientReportSaved extends MainState {
  final String msg;
  PatientReportSaved(this.msg);
  @override
  List<Object> get props => [this.msg];
}

class PatientAdded extends MainState {
  @override
  List<Object> get props => [];
}

class ChatImageUploaded extends MainState {
  final String fileID;
  ChatImageUploaded(this.fileID);
  @override
  List<Object> get props => [this.fileID];
}

class ViewPatientReport extends MainState {
  final String msg;
  ViewPatientReport(this.msg);
  @override
  List<Object> get props => [this.msg];
}

class EditPatientReport extends MainState {
  final String msg;
  EditPatientReport(this.msg);
  @override
  List<Object> get props => [this.msg];
}

class CaseClosedState extends MainState {
  final String msg;
  CaseClosedState(this.msg);
  @override
  List<Object> get props => [this.msg];
}

class ImageCaptured extends MainState {
  final String msg;
  final String id;
  final String time;
  ImageCaptured(this.msg, this.id, this.time);
  @override
  List<Object> get props => [this.msg, this.id, this.time];
}

class ImageLoaded extends MainState {
  final XFile image;
  ImageLoaded(this.image);
  @override
  List<Object> get props => [this.image];
}

class PatientExamReportFetched extends MainState {
  final Examination ereport;
  PatientExamReportFetched(this.ereport);
  @override
  List<Object> get props => [this.ereport];
}

class PatientExamReportSaved extends MainState {
  final String msg;
  PatientExamReportSaved(this.msg);
  @override
  List<Object> get props => [this.msg];
}

class ViewPatientExamReport extends MainState {
  final String msg;
  ViewPatientExamReport(this.msg);
  @override
  List<Object> get props => [this.msg];
}

class EditPatientExamReport extends MainState {
  final String msg;
  EditPatientExamReport(this.msg);
  @override
  List<Object> get props => [this.msg];
}

class NoReportState extends MainState {
  final String msg;
  NoReportState(this.msg);
  @override
  List<Object> get props => [this.msg];
}

class NoHistoryState extends MainState {
  final String error;
  NoHistoryState(this.error);
  @override
  List<Object> get props => [this.error];
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

class PatientAcceptedHub extends MainState {
  @override
  List<Object> get props => [];
}

class MessagesLoadedState extends MainState {
  final List<Message> messages;
  // print(messages);
  MessagesLoadedState(this.messages) {
    print(messages.last);
  }
  @override
  List<Object> get props => [messages];
}

class TokenLoadedState extends MainState {
  final String token;
  TokenLoadedState(this.token);
  @override
  List<Object> get props => [token];
}

class AllPatientsState extends MainState {
  final String msg;
  AllPatientsState(this.msg);
  @override
  List<Object> get props => [msg];
}

class AllHubDoctorsState extends MainState {
  final List<HubInfo> docs;
  AllHubDoctorsState(this.docs);
  @override
  List<Object> get props => [docs];
}

class PatientsLoaded extends MainState {
  final List<PatientListInfo> patients;
  PatientsLoaded(this.patients);
  @override
  List<Object> get props => [patients];
}

class RequestsLoaded extends MainState {
  final List<PatientListInfo> req;
  RequestsLoaded(this.req);
  @override
  List<Object> get props => [req];
}

class ConsultHub extends MainState {
  final String name;
  ConsultHub(this.name);
  @override
  List<Object> get props => [name];
}

class HubPatientsLoaded extends MainState {
  final List<EDetails> details;
  HubPatientsLoaded(this.details);
  @override
  List<Object> get props => [details];
}

class HubRequestsLoaded extends MainState {
  final List<EDetails> details;
  HubRequestsLoaded(this.details);
  @override
  List<Object> get props => [details];
}

class StatusFetched extends MainState {
  final String msg;
  StatusFetched(this.msg);
  @override
  List<Object> get props => [msg];
}

class ReportingTimeFetched extends MainState {
  final String msg;
  ReportingTimeFetched(this.msg);
  @override
  List<Object> get props => [msg];
}

class NewReportGenerated extends MainState {
  final String msg;
  NewReportGenerated(this.msg);
  @override
  List<Object> get props => [msg];
}

class NewErrorState extends MainState {
  final String error;
  final String prevState;
  NewErrorState(this.error, this.prevState) {}
  @override
  List<Object> get props => [this.error, this.prevState];
}

class NoPatientRequested extends MainState {
  final String error;
  final String prevState;
  NoPatientRequested(this.error, this.prevState) {}
  @override
  List<Object> get props => [this.error, this.prevState];
}

class NoPatientAccepted extends MainState {
  final String error;
  final String prevState;
  NoPatientAccepted(this.error, this.prevState) {}
  @override
  List<Object> get props => [this.error, this.prevState];
}

class PatientInfoLoadingState extends MainState {
  PatientInfoLoadingState() {}
  @override
  List<Object> get props => [];
}

class ChatLoadingState extends MainState {
  ChatLoadingState() {}
  @override
  List<Object> get props => [];
}

class ErrorState extends MainState {
  final String error;
  ErrorState(this.error) {}
  @override
  List<Object> get props => [this.error];
}
