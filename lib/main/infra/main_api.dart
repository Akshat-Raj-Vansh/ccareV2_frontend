import 'dart:convert';
import 'package:ccarev2_frontend/user/domain/location.dart';
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
    String endpoint = baseUrl + "/emergency/patient/getAllQuestions";
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
    print(result);
    return Result.value(result.map<QuestionTree>((element) {
      print(jsonEncode(element));
      return QuestionTree.fromJson(jsonEncode(element));
    }).toList());
  }

  transformError(Map map) {
    var contents = map["error"] ?? map['errors'];
    print(contents);
    if (contents is String) return contents;
    String errStr = "ERRORS";
    (contents as Map<dynamic, dynamic>).forEach((key, value) {
      print("${key} : ${value}\n");
    });

    return errStr;
  }

  @override
  Future<Result<String>> notify(Token token, Location location) async {
    String endpoint = baseUrl + "/emergency/patient/notify";
    print(endpoint);
    var header = {
      "Content-Type": "application/json",
      "Authorization": token.value
    };
    var response = await _client.post(
      Uri.parse(endpoint),
      headers: header,
      body: location.toJson(),
    );
    if (response.statusCode != 200) {
      print("error");
      Map map = jsonDecode(response.body);
      print(transformError(map));
      return Result.error(transformError(map));
    }
    dynamic json = jsonDecode(response.body);
    return Result.value(json['message']);
  }

  @override
  Future<Result<Location>> acceptPatientbyDoctor(
      Token token, Token patient) async {
    String endpoint = baseUrl + "/emergency/doctor/acceptPatient";
    var header = {
      "Content-Type": "application/json",
      "Authorization": token.value
    };
    var response = await _client.post(Uri.parse(endpoint),
        headers: header, body: jsonEncode({"patID": patient.value}));
    if (response.statusCode != 200) {
      Map map = jsonDecode(response.body);
      print(transformError(map));
      return Result.error(transformError(map));
    }
    dynamic json = jsonDecode(response.body);
    return Result.value(Location(longitude:json['longtitude'],latitude:json["latitude"]));
  }

  @override
  Future<Result<Location>> acceptPatientbyDriver(
      Token token, Token patient) async {
    String endpoint = baseUrl + "/emergency/driver/acceptPatient";
    var header = {
      "Content-Type": "application/json",
      "Authorization": token.value
    };
    var response = await _client.post(Uri.parse(endpoint),
        headers: header, body: jsonEncode({"patID": patient.value}));
    print("Response: " + response.body);
    if (response.statusCode != 200) {
      print("error");
      Map map = jsonDecode(response.body);
      print(transformError(map));
      return Result.error(transformError(map));
    }
    dynamic json = jsonDecode(response.body);
    return Result.value(Location(longitude:json['longtitude'],latitude:json["latitude"]));
  }

  @override
  Future<Result<String>> getAllPatients(Token token) async {
    String endpoint = baseUrl + "/emergency/doctor/getAllPatients";
    var header = {
      "Content-Type": "application/json",
      "Authorization": token.value
    };
    var response = await _client
        .post(Uri.parse(endpoint), headers: header, body: {"json": "json"});
    if (response.statusCode != 200) {
      Map map = jsonDecode(response.body);
      print(transformError(map));
      return Result.error(transformError(map));
    }
    dynamic json = jsonDecode(response.body);
    return Result.value(json["message"]);
  }
}
