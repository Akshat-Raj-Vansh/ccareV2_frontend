import 'package:auth/src/domain/details.dart';

import './token.dart';
import 'package:async/async.dart';


abstract class IAuthService{
  Future<Result<Details>> signIn();
  Future<Result<bool>> signOut(Token token);
}