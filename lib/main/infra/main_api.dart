import 'dart:convert';
import 'package:ccarev2_frontend/main/domain/edetails.dart';
import 'package:ccarev2_frontend/main/domain/examination.dart';
import 'package:ccarev2_frontend/main/domain/treatment.dart' as treat;
import 'package:ccarev2_frontend/user/domain/emergency.dart';
import 'package:ccarev2_frontend/user/domain/location.dart';
import 'package:ccarev2_frontend/utils/constants.dart';
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
    print(json);
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
    String errStr = "ERRORS";
    (contents as Map<dynamic, dynamic>).forEach((key, value) {
      print("${key} : ${value}\n");
    });

    return errStr;
  }

  @override
  Future<Result<String>> notify(
      Token token, Location location, String action, bool ambRequired,
      {List<QuestionTree>? assessment}) async {
    String endpoint = baseUrl + "/emergency/patient/notify";
    assessment?.removeLast();
    var ans = assessment
        ?.map((e) => {"question": e.question, "answer": e.answers})
        .toList();
    print(ans);
    var body = {
      "latitude": location.latitude,
      'longitude': location.longitude,
      "action": action,
      "ambulanceRequired": ambRequired,
      "assessment":ans
    };
    var header = {
      "Content-Type": "application/json",
      "Authorization": token.value
    };
    var response = await _client.post(
      Uri.parse(endpoint),
      headers: header,
      body: jsonEncode(body),
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
  Future<Result<String>> emergencyRequest(
      Token token, Emergency emergency) async {
    String endpoint = baseUrl + "/emergency/patient/notify";
    print(endpoint);
    var header = {
      "Content-Type": "application/json",
      "Authorization": token.value
    };
    var response = await _client.post(
      Uri.parse(endpoint),
      headers: header,
      body: emergency.toJson(),
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
    return Result.value(
        Location(longitude: json['longtitude'], latitude: json["latitude"]));
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
    return Result.value(
        Location(longitude: json['longitude'], latitude: json["latitude"]));
  }

  @override
  Future<Result<List<treat.TreatmentReport>>> fetchPatientReportHistory(
      Token token) async {
    String endpoint = baseUrl + "/treatment/getHistory";
    var header = {
      "Content-Type": "application/json",
      "Authorization": token.value
    };
    var response = await _client.get(Uri.parse(endpoint), headers: header);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode != 200) {
      Map map = jsonDecode(response.body);
      print(transformError(map));
      return Result.error(transformError(map));
    }
    List<treat.TreatmentReport> report =
        (jsonDecode(response.body)['history'] as List)
            .map((data) => treat.TreatmentReport.fromJson(jsonEncode(data)))
            .toList();
    return Result.value(report);
  }

  @override
  Future<Result<treat.TreatmentReport>> fetchPatientReport(Token token) async {
    String endpoint = baseUrl + "/treatment/getReport";
    var header = {
      "Content-Type": "application/json",
      "Authorization": token.value
    };
    var response = await _client.get(Uri.parse(endpoint), headers: header);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode != 200) {
      Map map = jsonDecode(response.body);
      print(transformError(map));
      return Result.error(transformError(map));
    }
    dynamic report = jsonDecode(response.body)['report'];
    try {
      treat.TreatmentReport.fromJson(jsonEncode(report));
    } catch (e) {
      return Result.error("No medical records present");
    }
    print(report);

    return Result.value(treat.TreatmentReport.fromJson(jsonEncode(report)));
  }

  @override
  Future<Result<String>> savePatientReport(
      Token token, treat.TreatmentReport report) async {
    String endpoint = baseUrl + "/treatment/doctor/updateReport";
    var header = {
      "Content-Type": "application/json",
      "Authorization": token.value
    };
    var response = await _client.post(Uri.parse(endpoint),
        headers: header, body: report.toJson());
    if (response.statusCode != 200) {
      Map map = jsonDecode(response.body);
      print(transformError(map));
      return Result.error(transformError(map));
    }
    dynamic json = jsonDecode(response.body);
    return Result.value(json["message"]);
  }

  @override
  Future<Result<Examination>> fetchPatientExamReport(Token token) async {
    String endpoint = baseUrl + "/treatment/getTreatment";
    var header = {
      "Content-Type": "application/json",
      "Authorization": token.value
    };
    var response = await _client.get(Uri.parse(endpoint), headers: header);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode != 200) {
      Map map = jsonDecode(response.body);
      print(transformError(map));
      return Result.error(transformError(map));
    }
    dynamic report = jsonDecode(response.body)['treatment'];
    print(report);
    try {
      Examination.fromJson(jsonEncode(report));
    } catch (e) {
      return Result.error("No medical records present");
    }

    return Result.value(Examination.fromJson(jsonEncode(report)));
  }

  @override
  Future<Result<String>> savePatientExamReport(
      Token token, Examination examination) async {
    String endpoint = baseUrl + "/treatment/doctor/updateTreatment";
    var header = {
      "Content-Type": "application/json",
      "Authorization": token.value
    };
    var response = await _client.post(Uri.parse(endpoint),
        headers: header, body: examination.toJson());
    if (response.statusCode != 200) {
      Map map = jsonDecode(response.body);
      print(transformError(map));
      return Result.error(transformError(map));
    }
    dynamic json = jsonDecode(response.body);
    return Result.value(json["message"]);
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

  @override
  Future<Result<EDetails>> fetchEmergencyDetails(Token token) async {
    String endpoint = baseUrl + "/emergency/fetchEmergencyDetails";
    var header = {
      "Content-Type": "application/json",
      "Authorization": token.value
    };
    var response = await _client.get(Uri.parse(endpoint), headers: header);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode != 200) {
      Map map = jsonDecode(response.body);
      print(transformError(map));
      return Result.error(transformError(map));
    }
    dynamic json = jsonDecode(response.body);
    return Result.value(EDetails.fromJson(jsonEncode(json)));
  }

  @override
  Future<Result<String>> updateStatus(Token token, String status) async {
    String endpoint = baseUrl + "/emergency/updateStatus";
    var header = {
      "Content-Type": "application/json",
      "Authorization": token.value
    };
    var response = await _client
        .post(Uri.parse(endpoint), headers: header, body: jsonEncode({'status': status}));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode != 200) {
      Map map = jsonDecode(response.body);
      print(transformError(map));
      return Result.error(transformError(map));
    }
    dynamic json = jsonDecode(response.body);
    return Result.value(json["message"]);
  }
}
