import '../domain/token.dart';
import "package:async/async.dart";
import '../domain/auth_service_contract.dart';

class SignOutUseCase{
  final IAuthService iAuthService;

  SignOutUseCase(this.iAuthService);
  Future<Result<bool>> execute(Token token) async{
    return await iAuthService.signOut(token);
  }
}