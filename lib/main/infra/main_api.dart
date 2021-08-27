import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:async/src/result/result.dart';

import '../../user/domain/token.dart';
import '../domain/question.dart';
import '../domain/main_api_contract.dart';

class MainAPI extends IMainAPI {
  final http.Client _client;
  final String baseUrl;
  var header = {
    "Content-Type": "application/json",
  };

  MainAPI(this._client, this.baseUrl);
  @override
  Future<Result<List<QuestionTree>>> getAll(Token token) async {
    String endpoint = baseUrl + "emergency/patient/getAllQuestions";
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
    var result = json["questions"] as List;
    return Result.value(result
        .map<QuestionTree>(
            (element) => QuestionTree.fromJson(jsonEncode(element)))
        .toList());
  }

  transformError(Map map) {
    var contents = map["error"] ?? map['errors'];
    print(contents);
    if (contents is String) return contents;
    var errStr =
        contents.fold('', (prev, ele) => prev + ele.values.first + '\n');
    return errStr;
  }

  @override
  Future<Result<String>> notify(Token token) async {
    String endpoint = baseUrl + "emergency/patient/notify";
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
    var result = json["questions"] as List;
    return Result.value("NOTIFY");
  }

  @override
  Future<Result<String>> acceptPatientbyDoctor(Token token) async {
    String endpoint = baseUrl + "emergency/doctor/acceptPatient";
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
    // var result = json["questions"] as List;
    return Result.value("ACCEPT");
  }

  @override
  Future<Result<String>> acceptPatientbyDriver(Token token) async {
    String endpoint = baseUrl + "emergency/driver/acceptPatient";
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
    // var result = json["questions"] as List;
    return Result.value("ACCEPT");
  }

  @override
  Future<Result<String>> getAllPatients(Token token) async {
    String endpoint = baseUrl + "emergency/doctor/getAllPatients";
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
    // var result = json["patients"] as List;
    return Result.value("GET ALL PATIENTS");
  }
}
