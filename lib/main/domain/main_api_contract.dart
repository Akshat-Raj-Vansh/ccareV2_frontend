import 'package:async/async.dart';
import 'package:ccarev2_frontend/user/domain/location.dart';
import '../../user/domain/token.dart';
import 'question.dart';

abstract class IMainAPI {
  Future<Result<List<QuestionTree>>> getAll(Token token);
  Future<Result<String>> notify(Token token, Location location);
  Future<Result<String>> getAllPatients(Token token);
  Future<Result<Location>> acceptPatientbyDoctor(Token token, Token patient);
  Future<Result<Location>> acceptPatientbyDriver(Token token, Token patient);
}
