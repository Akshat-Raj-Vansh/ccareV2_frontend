import 'package:async/async.dart';

abstract class ISignUpService{
  Future<Result<dynamic>> signUp(
    String email,
    String password,
    String name
  );
}