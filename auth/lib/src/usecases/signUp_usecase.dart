import 'package:auth/src/domain/details.dart';

import '../domain/signup_service_contract.dart';
import 'package:async/async.dart';

class SignInUsecase{
  final ISignUpService iSignUpService;

  SignInUsecase(this.iSignUpService);
  Future<Result<Details>> execute(String email,String password,String name) async{
    return await iSignUpService.signUp(email, password, name);
  }
}