import 'package:auth/src/domain/details.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../domain/credential.dart';
import '../api/auth_api_contract.dart';
import '../../domain/auth_service_contract.dart';
import '../../domain/token.dart';
import 'package:async/async.dart';

class GoogleAuth implements IAuthService {
  final IAuthApi iAuthApi;
  GoogleSignIn _googleSignIn;
  GoogleSignInAccount currentUser;
  GoogleAuth(this.iAuthApi, [GoogleSignIn googleSignIn])
      : this._googleSignIn =
            googleSignIn ?? GoogleSignIn(scopes: ['email', 'profiles']);
  @override
  Future<Result<Details>> signIn() async {
    try {
      print("signIn");
      currentUser = await _googleSignIn.signIn();
      print("Email is" + currentUser.email);
      if (currentUser == null)
        return Result.error("Failed to signin with Google");

      Credential credential = Credential(
          email: currentUser.email,
          type: AuthType.google,
          name: currentUser.displayName);
      dynamic result = await iAuthApi.signIn(credential);
      if (result.isError) return result.asError.error;
      return Result.value(Details.fromJson(result.asValue.value));
    } catch (error) {
      print("Error" + error.toString());
      return Result.error(error.toString());
    }
  }

  @override
  Future<Result<bool>> signOut(Token token) async {
    var ans = await iAuthApi.signOut(token);
    if (ans.asValue.value) _googleSignIn.disconnect();
    return ans;
  }

  void handleGoogleSignIn() async {
    try {
      currentUser = await _googleSignIn.signIn();
    } catch (error) {
      return;
    }
  }
}
