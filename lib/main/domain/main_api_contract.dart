import 'package:async/async.dart';
import '../../user/domain/token.dart';
import 'question.dart';

abstract class IMainAPI {
  Future<Result<List<QuestionTree>>> getAll(Token token);
  Future<Result<String>> notify(Token token);
  Future<Result<String>> getAllPatients(Token token);
  Future<Result<String>> acceptPatientbyDoctor(Token token);
  Future<Result<String>> acceptPatientbyDriver(Token token);
}
