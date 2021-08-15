import 'dart:convert';

import 'package:async/src/result/result.dart';
import 'package:extras/src/domain/medicalProfile.dart';

import '../domain/token.dart';
import '../domain/questionTree.dart';
import 'main_api_contract.dart';
import 'package:http/http.dart' as http;

class MainApi extends IMainApi {
  final http.Client _client;
  final String baseUrl;
  var header = {
    "Content-Type": "application/json",
  };

  MainApi(this._client, this.baseUrl);
  @override
  Future<Result<List<QuestionTree>>> getAll(Token token) async {
    String endpoint = this.baseUrl + "/questionnare/getAll";
    var header = {
      "Content-Type": "application/json",
      "Authorization": token.value
    };
    var response = await this._client.get(endpoint, headers: header);
    if (response.statusCode != 200) {
      Map map = jsonDecode(response.body);
      print(transformError(map));
      return Result.error(transformError(map));
    }
    dynamic json = jsonDecode(response.body);
    var result = json["questions"] as List;
    return Result.value(result
        .map<QuestionTree>(
            (element) => QuestionTree.fromJson(jsonEncode(element)))
        .toList());
  }

  // TO BE CHANGED
  @override
  Future<Result<List<MedicalProfile>>> getCurrentPatients(Token token) async {
    print('Inside api call of get current patients');
    String endpoint = this.baseUrl + "/patients/getcurrent";
    var header = {
      "Content-Type": "application/json",
      "Authorization": token.value
    };
    var response = await this._client.get(endpoint, headers: header);
    if (response.statusCode != 200) {
      Map map = jsonDecode(response.body);
      print(transformError(map));
      return Result.error(transformError(map));
    }
    print('Response Body:');
    print(response.body);
    dynamic json = jsonDecode(response.body);
    var result = json["patients"] as List;
    return Result.value(result
        .map<MedicalProfile>(
            (element) => MedicalProfile.fromJson(jsonEncode(element)))
        .toList());
  }

  @override
  Future<Result<List<MedicalProfile>>> getWaitingList(Token token) async {
    String endpoint = this.baseUrl + "/patients/getwaiting";
    var header = {
      "Content-Type": "application/json",
      "Authorization": token.value
    };
    var response = await this._client.get(endpoint, headers: header);
    if (response.statusCode != 200) {
      Map map = jsonDecode(response.body);
      print(transformError(map));
      return Result.error(transformError(map));
    }
    dynamic json = jsonDecode(response.body);
    var result = json["patients"] as List;
    print(json["patients"]);
    return Result.value(result
        .map<MedicalProfile>(
            (element) => MedicalProfile.fromJson(jsonEncode(element)))
        .toList());
  }

  @override
  Future<Result<String>> acceptPatient(Token token, String patientId) async {
    String endpoint = this.baseUrl + "/patients/accept";
    var header = {
      "Content-Type": "application/json",
      "Authorization": token.value
    };
    var response = await this._client.get(endpoint, headers: header);
    if (response.statusCode != 200) {
      Map map = jsonDecode(response.body);
      print(transformError(map));
      return Result.error(transformError(map));
    }
    dynamic json = jsonDecode(response.body);
    return Result.value('Successful'); // TO BE CHANGED
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
