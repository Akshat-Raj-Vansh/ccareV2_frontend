// @dart=2.9
import 'dart:convert';

import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:ccarev2_frontend/user/domain/details.dart';
import 'package:ccarev2_frontend/user/domain/token.dart';

import 'ilocal_store.dart';
import 'package:ccarev2_frontend/cache/ilocal_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String token_key = "CACHED__TOKEN_AND_DATA";
const String temp_token_key = "CACHED_TEMP_TOKEN";
const String auth_key = "CACHED__TYPE";

class LocalStore implements ILocalStore {
  final SharedPreferences sharedPreferences;

  LocalStore(this.sharedPreferences);

  @override
  delete() {
    sharedPreferences.remove(token_key);
  }

  @override
  Future<Token> fetch() {
    String data = sharedPreferences.getString(token_key);
    print(data);
    if (data != null) {
      Details details = Details.fromMap(jsonDecode(data));
      return Future.value(Token(details.user_token));
    }
    return null;
  }

  @override
  Future save(Details details) {
    sharedPreferences.setString(token_key, jsonEncode(details.toMap()));
  }

  @override
  saveUserType(UserType type) {
    return sharedPreferences.setString(auth_key, type.toString());
  }

  @override
  Future<Token> fetchTempToken() {
    String data = sharedPreferences.getString(temp_token_key);
    print(data);
    if (data != null) return Future.value(Token(data));
    return null;
  }

  @override
  saveTempToken(String token) {
    sharedPreferences.setString(temp_token_key, token);
  }

  @override
  Future<UserType> fetchUserType() {
   String data = sharedPreferences.getString(token_key);
  
    if (data != null) {
      Details details = Details.fromMap(jsonDecode(data));
      print(details.user_type.toLowerCase());
      UserType.values.forEach((element) {print(element.toString());});
     return Future.value(UserType.values
          .firstWhere((element) => element.toString() == "UserType."+details.user_type.toLowerCase()));
    }
    return null;
  }
}
