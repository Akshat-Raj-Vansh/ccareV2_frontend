import 'package:auth/src/domain/auth_service_contract.dart';
import 'package:auth/src/domain/credential.dart';
import 'package:auth/src/infra/adapters/email_auth.dart';
import 'package:auth/src/infra/adapters/google_auth.dart';
import 'package:auth/src/infra/api/auth_api_contract.dart';

class AuthManger{
  final IAuthApi iAuthApi;

  AuthManger(this.iAuthApi);
   
   IAuthService service(AuthType type){
     var service;
     switch (type){
       case AuthType.email:
         service = EmailAuth(iAuthApi); 
         break;
       case AuthType.google:
         service = GoogleAuth(iAuthApi);
         break;
     }
     return service;
   }
}