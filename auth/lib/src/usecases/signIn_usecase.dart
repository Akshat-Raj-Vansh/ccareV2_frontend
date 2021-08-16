import 'package:auth/src/domain/details.dart';

import '../domain/auth_service_contract.dart';
import 'package:async/async.dart';

class SignInUsecase{
  final IAuthService iAuthService;

  SignInUsecase(this.iAuthService);
  Future<Result<Details>> execute() async{
    return await iAuthService.signIn();
  }
}