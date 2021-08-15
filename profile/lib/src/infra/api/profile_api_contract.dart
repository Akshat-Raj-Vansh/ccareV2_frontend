import 'package:profile/src/domain/profile.dart';

import 'package:async/async.dart';
import 'package:profile/src/domain/token.dart';

abstract class IProfileApi {
  Future<Result<Profile>> getProfile(Token token);
  Future<Result<String>> updateProfile(Token token, Profile profile);
}
