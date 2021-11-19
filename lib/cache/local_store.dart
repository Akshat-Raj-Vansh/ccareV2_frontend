// @dart=2.9
import 'dart:convert';

import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:ccarev2_frontend/user/domain/details.dart';
import 'package:ccarev2_frontend/user/domain/profile.dart';
import 'package:ccarev2_frontend/user/domain/token.dart';

import 'ilocal_store.dart';
import 'package:ccarev2_frontend/cache/ilocal_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String token_key = "CACHED__TOKEN_AND_DATA";
const String temp_token_key = "CACHED_TEMP_TOKEN";
const String auth_key = "CACHED__TYPE";
const String temp_data_key = "CACHED__DATA";

class LocalStore implements ILocalStore {
  final SharedPreferences sharedPreferences;
  LocalStore(this.sharedPreferences);

  @override
  Future<Token> fetch() {
    String data = sharedPreferences.getString(token_key);
    print('LOCAL STORE FETCH');
    print(data);
    if (data != null) {
      Details details = Details.fromMap(jsonDecode(data));
      return Future.value(Token(details.user_token));
    }
    return null;
  }

  @override
  Future<bool> fetchNewUser() {
    String data = sharedPreferences.getString(token_key);
    print(data);
    if (data != null) {
      Details details = Details.fromMap(jsonDecode(data));
      return Future.value(details.newUser);
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
  void updateNewUser(bool newUser) {
    String data = sharedPreferences.getString(token_key);
    print('LOCAL STORE UPDATE NEW USER');
    print(data);
    if (data != null) {
      Details details = Details.fromMap(jsonDecode(data));
      Details new_details = Details(
        newUser: newUser,
        user_token: details.user_token,
        phone_number: details.phone_number,
        user_type: details.user_type,
        name: details.name,
        hospital: details.hospital,
      );
      sharedPreferences.setString(token_key, jsonEncode(new_details.toMap()));
    }
  }

  @override
  void updateUserType(UserType type) {
    // return sharedPreferences.setString(auth_key, type.toString());
    String data = sharedPreferences.getString(token_key);
    print('LOCAL STORE UPDATE USER TYPE');
    print(data);
    if (data != null) {
      Details details = Details.fromMap(jsonDecode(data));
      Details new_details = Details(
          newUser: details.newUser,
          user_token: details.user_token,
          phone_number: details.phone_number,
          user_type: type,
          name: details.name,
          hospital: details.hospital);
      sharedPreferences.setString(token_key, jsonEncode(new_details.toMap()));
    }
  }

  @override
  void updatePhoneNumber(String phone) {
    // return sharedPreferences.setString(auth_key, type.toString());
    String data = sharedPreferences.getString(token_key);
    print(data);
    if (data != null) {
      Details details = Details.fromMap(jsonDecode(data));
      Details new_details = Details(
          newUser: details.newUser,
          user_token: details.user_token,
          phone_number: phone,
          user_type: details.user_type,
          name: details.name,
          hospital: details.hospital);
      sharedPreferences.setString(token_key, jsonEncode(new_details.toMap()));
    }
  }

  // @override
  // void updateDoctorType(DoctorType type) {
  //   // return sharedPreferences.setString(auth_key, type.toString());
  //   String data = sharedPreferences.getString(token_key);
  //   print(data);
  //   if (data != null) {
  //     Details details = Details.fromMap(jsonDecode(data));
  //     Details new_details = Details(
  //         newUser: details.newUser,
  //         user_token: details.user_token,
  //         phone_number: details.phone_number,
  //         user_type: details.user_type,
  //         doctor_type: type);
  //     sharedPreferences.setString(token_key, jsonEncode(new_details.toMap()));
  //   }
  // }

  @override
  Future<Details> fetchDetails() {
    String data = sharedPreferences.getString(token_key);
    print(data);
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
  Future<Token> fetchTempToken() {
    String data = sharedPreferences.getString(temp_token_key);
    print(data);
    if (data != null) return Future.value(Token(data));
    return null;
  }

  // @override
  // Future<UserType> fetchUserType() {
  //   String data = sharedPreferences.getString(token_key);

  //   if (data != null) {
  //     Details details = Details.fromMap(jsonDecode(data));
  //     UserType.values.forEach((element) {
  //       print(element.toString());
  //     });
  //     return Future.value(UserType.values.firstWhere((element) =>
  //         element.toString() == "UserType." + details.user_type.toLowerCase()));
  //   }
  //   return null;
  // }
}
