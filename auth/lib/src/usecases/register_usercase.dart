import 'package:auth/src/domain/details.dart';
import 'package:auth/src/domain/register_service_contract.dart';

import '../domain/signup_service_contract.dart';
import 'package:async/async.dart';

class RegisterUsecase {
  final IRegisterService iRegisterService;

  RegisterUsecase(this.iRegisterService);
  Future<Result<Details>> execute(String phone) async {
    return await iRegisterService.register(phone);
  }
}
