import 'dart:convert';

import 'package:ccarev2_frontend/user/domain/credential.dart';
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
  Future<Result<String>> login(Credential credential) {
    String endpoint = baseUrl + "/user/doctor";
    return _post(endpoint, credential);
  }

  @override
  Future<Result<bool>> logout(Token token) async {
    String endpoint = baseUrl + "/auth/signout";
    var header = {
      "Content-Type": "application/json",
      "Authorization": token.value
    };
    var res = await _client.post(Uri.parse(endpoint), headers: header);
    if (res.statusCode != 200) return Result.value(false);
    return Result.value(true);
  }

  @override
  Future<Result<String>> verify(String phone) {
    //USE FIREBASE AUTHs
    throw UnimplementedError();
  }

  @override
  Future<Result<DoctorProfile>> getDoctorProfile(Token token) async {
    String endpoint = baseUrl + "/user/doctor";
    var header = {
      "Content-Type": "application/json",
      "Authorization": token.value
    };
    var response = await _client.get(Uri.parse(endpoint), headers: header);
    if (response.statusCode != 200) {
      Map map = jsonDecode(response.body);
      print(transformError(map));
      return Result.error(transformError(map));
    }
    dynamic json = jsonDecode(response.body);
    return Result.value(DoctorProfile.fromJson(json));
  }

  @override
  Future<Result<PatientProfile>> getPatientProfile(Token token) async {
    String endpoint = baseUrl + "/user/patient";
    var header = {
      "Content-Type": "application/json",
      "Authorization": token.value
    };
    var response = await _client.get(Uri.parse(endpoint), headers: header);
    if (response.statusCode != 200) {
      Map map = jsonDecode(response.body);
      print(transformError(map));
      return Result.error(transformError(map));
    }
    dynamic json = jsonDecode(response.body);
    return Result.value(PatientProfile.fromJson(json));
  }

  @override
  Future<Result<String>> updateDoctorProfile(
      Token token, DoctorProfile profile) async {
    String endpoint = baseUrl + "/user/doctor";
    var header = {
      "Content-Type": "application/json",
      "Authorization": token.value
    };
    var response = await _client.post(Uri.parse(endpoint),
        headers: header, body: profile.toJson());
    if (response.statusCode != 200) {
      Map map = jsonDecode(response.body);
      print(transformError(map));
      return Result.error(transformError(map));
    }
    dynamic json = jsonDecode(response.body);
    return Result.value(json["message"]);
  }

  @override
  Future<Result<String>> updatePatientProfile(
      Token token, PatientProfile profile) async {
    String endpoint = baseUrl + "/user/patient";
    var header = {
      "Content-Type": "application/json",
      "Authorization": token.value
    };
    var response = await _client.post(Uri.parse(endpoint),
        headers: header, body: profile.toJson());
    if (response.statusCode != 200) {
      Map map = jsonDecode(response.body);
      print(transformError(map));
      return Result.error(transformError(map));
    }
    dynamic json = jsonDecode(response.body);
    return Result.value(json["message"]);
  }

  Future<Result<String>> _post(String endpoint, Credential credential) async {
    print(credential.phone);
    var header = {
      "Content-Type": "application/json",
    };
    dynamic response = await _client.post(Uri.parse(endpoint),
        body: credential.toJson(), headers: header);
    print(response.statusCode);
    if (response.statusCode != 200) {
      Map map = jsonDecode(response.body);
      print(transformError(map));
      return Result.error(transformError(map));
    }
    dynamic json = jsonDecode(response.body);

    if (json['authToken'] != null) return Result.value(jsonEncode(json));
    return Result.error(json["message"]);
  }

  transformError(Map map) {
    var contents = map["error"] ?? map['errors'];
    print(contents);
    if (contents is String) return contents;
    var errStr =
        contents.fold('', (prev, ele) => prev + ele.values.first + '\n');
    return errStr;
  }
}
