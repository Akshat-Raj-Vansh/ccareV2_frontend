import 'package:async/async.dart';

import '../domain/questionTree.dart';
import '../domain/medicalProfile.dart';
import '../domain/token.dart';

abstract class IMainApi {
  Future<Result<List<QuestionTree>>> getAll(Token token);
  Future<Result<List<MedicalProfile>>> getCurrentPatients(Token token);
  Future<Result<List<MedicalProfile>>> getWaitingList(Token token);
  Future<Result<String>> acceptPatient(Token token, String patientId);
}
