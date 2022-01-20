//@dart=2.9
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:ccarev2_frontend/user/domain/details.dart';
import 'package:ccarev2_frontend/user/domain/token.dart';
import 'package:ccarev2_frontend/user/domain/profile.dart';
import 'package:ccarev2_frontend/user/domain/user_service_contract.dart';

import 'package:async/src/result/result.dart';
import 'package:http/http.dart' as http;

class UserAPI implements UserService {
  final http.Client _client;
  final String baseUrl;

  UserAPI(
    this._client,
    this.baseUrl,
  );

  @override
  Future<Result<Details>> loginOld(Credential credential) async {
    String endpoint = baseUrl + "/user/signin";
    var header = {
      "Content-Type": "application/json",
    };
    dynamic response = await _client.post(Uri.parse(endpoint),
        body: credential.toJson(), headers: header);
    //print('LOGIN API CALL');
    if (response.statusCode != 200) {
      Map map = jsonDecode(response.body);
      //print(transformError(map));
      return Result.error(transformError(map));
    }
    dynamic json = jsonDecode(response.body);
    return Result.value(Details.fromJson(jsonEncode(json)));
  }

  @override
  Future<Result<dynamic>> loginNew(Credential credential) async {
    String endpoint = baseUrl + "/user/signin";
    var header = {
      "Content-Type": "application/json",
    };
    dynamic response = await _client.post(Uri.parse(endpoint),
        body: credential.toJson(), headers: header);
    //print('DOC LOGIN API CALL');
    print('LOG > user_api.dart > 51 > response.body: ${response.body}');
    if (response.statusCode != 200) {
      Map map = jsonDecode(response.body);
      //print(transformError(map));
      return Result.error(transformError(map));
    }
    dynamic json = jsonDecode(response.body);
    return Result.value(json);
  }

  @override
  Future<Result<String>> addDoctorProfile(
      Token token, DoctorProfile profile) async {
    String endpoint = baseUrl + "/user/addProfile";
    var header = {
      "Content-Type": "application/json",
      "Authorization": token.value
    };

    var response = await _client.post(Uri.parse(endpoint),
        headers: header, body: profile.toJson());
    //print('ADD DOCTOR PROFILE API CALL');
    if (response.statusCode != 200) {
      Map map = jsonDecode(response.body);
      //print(transformError(map));
      return Result.error(transformError(map));
    }
    dynamic json = jsonDecode(response.body);
    return Result.value(json["message"]);
  }

  @override
  Future<Result<String>> addDriverProfile(
      Token token, DriverProfile profile) async {
    String endpoint = baseUrl + "/user/addProfile";
    var header = {
      "Content-Type": "application/json",
      "Authorization": token.value
    };
    var response = await _client.post(Uri.parse(endpoint),
        headers: header, body: profile.toJson());
    if (response.statusCode != 200) {
      Map map = jsonDecode(response.body);
      //print(transformError(map));
      return Result.error(transformError(map));
    }
    dynamic json = jsonDecode(response.body);
    return Result.value(json["message"]);
  }

  @override
  Future<Result<String>> addPatientProfile(
      Token token, PatientProfile profile) async {
    String endpoint = baseUrl + "/user/addProfile";
    var header = {
      "Content-Type": "application/json",
      "Authorization": token.value
    };
    var response = await _client.post(Uri.parse(endpoint),
        headers: header, body: profile.toJson());
    if (response.statusCode != 200) {
      Map map = jsonDecode(response.body);
      //print(transformError(map));
      return Result.error(transformError(map));
    }
    dynamic json = jsonDecode(response.body);
    return Result.value(json["message"]);
  }

  transformError(Map map) {
    var contents = map["error"] ?? map['errors'];
    //print(contents);
    if (contents is String) return contents;
    var errStr =
        contents.fold('', (prev, ele) => prev + ele.values.first + '\n');
    return errStr;
  }
}
