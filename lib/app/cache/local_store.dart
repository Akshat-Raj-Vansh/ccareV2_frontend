import 'dart:convert';

import '../data/details.dart';
import '../data/doc_info.dart';
import '../data/token.dart';

import 'ilocal_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String token_key = "CACHED__TOKEN_AND_DATA";
const String info_key = "CACHED__INFO";
const String temp_token_key = "CACHED_TEMP_TOKEN";
const String auth_key = "CACHED__TYPE";
const String temp_data_key = "CACHED__DATA";

class LocalStore implements ILocalStore {
  final SharedPreferences sharedPreferences;
  LocalStore(this.sharedPreferences);

  @override
  Future<Token>? fetch() {
    String? data = sharedPreferences.getString(token_key);
    //print('LOCAL STORE FETCH');
    //print(data);
    if (data != null) {
      Details details = Details.fromMap(jsonDecode(data));
      return Future.value(Token(details.user_token));
    }
    return null;
  }

  @override
  Future<bool>? fetchNewUser() {
    String? data = sharedPreferences.getString(token_key);
    //print(data);
    if (data != null) {
      Details details = Details.fromMap(jsonDecode(data));
      return Future.value(details.newUser);
    }
    return null;
  }

  @override
  Future<Info>? fetchDocInfo() {
    String? data = sharedPreferences.getString(info_key);
    //print("LOCAL STORE/FETCH DOC INFO");
    //print("DATA:");
    //print(data);
    if (data != null) {
      Info docInfo = Info.fromMap(jsonDecode(data));
      return Future.value(docInfo);
    }
    return null;
  }

  @override
  delete() {
    sharedPreferences.remove(token_key);
  }

  @override
  void save(Details details) {
    sharedPreferences.setString(token_key, jsonEncode(details.toMap()));
  }

  @override
  void saveInfo(Info docInfo) {
    sharedPreferences.setString(info_key, jsonEncode(docInfo.toMap()));
  }

  @override
  void updateNewUser(bool newUser) {
    String? data = sharedPreferences.getString(token_key);
    //print('LOCAL STORE UPDATE NEW USER');
    //print(data);
    if (data != null) {
      Details details = Details.fromMap(jsonDecode(data));
      Details new_details = Details(
        newUser: newUser,
        user_token: details.user_token,
        user_type: details.user_type,
        phone: details.phone,
      );
      sharedPreferences.setString(token_key, jsonEncode(new_details.toMap()));
    }
  }

  @override
  Future<Details>? fetchDetails() {
    String? data = sharedPreferences.getString(token_key);
    //print(data);
    if (data != null) {
      Details details = Details.fromMap(jsonDecode(data));
      return Future.value(details);
    }
    return null;
  }

  @override
  saveTempToken(String token) {
    sharedPreferences.setString(temp_token_key, token);
  }

  @override
  Future<Token>? fetchTempToken() {
    String? data = sharedPreferences.getString(temp_token_key);
    //print(data);
    if (data != null) return Future.value(Token(data));
    return null;
  }
}
