import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:ccarev2_frontend/main/domain/edetails.dart';
import 'package:ccarev2_frontend/main/domain/examination.dart';
import 'package:ccarev2_frontend/main/domain/treatment.dart' as treat;
import 'package:ccarev2_frontend/pages/chat/components/message.dart';
import 'package:ccarev2_frontend/user/domain/doc_info.dart';
import 'package:ccarev2_frontend/user/domain/emergency.dart';
import 'package:ccarev2_frontend/user/domain/hub_doc_info.dart';
import 'package:ccarev2_frontend/user/domain/location.dart';
import 'package:ccarev2_frontend/user/domain/patient_list_info.dart';
import 'package:ccarev2_frontend/utils/constants.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:async/src/result/result.dart';

import 'package:image_picker/image_picker.dart';

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
  Future<Result<String>> getStatus(Token token) async {
    String endpoint = baseUrl + "/emergency/patient/getStatus";
    var header = {
      "Content-Type": "application/json",
      "Authorization": token.value
    };
    var response = await _client.get(Uri.parse(endpoint), headers: header);
    log('DATA > main_api.dart > FUNCTION_NAME > 52 > response.statusCode: ${response.statusCode}');
    log('DATA > main_api.dart > FUNCTION_NAME > 53 > response.body: ${response.body}');
    if (response.statusCode != 200) {
      Map map = jsonDecode(response.body);
      print(transformError(map));
      return Result.error(transformError(map));
    }
    dynamic json = jsonDecode(response.body);
    print('@main_api.dart/getStatus json: $json');
    var result = json["message"] as String;
    return Result.value(result);
  }

  @override
  Future<Result<String>> fetchPatientReportingTime(
      Token token, Token patient) async {
    String endpoint = baseUrl + "/treatment/getReportingTime";
    var header = {
      "Content-Type": "application/json",
      "Authorization": token.value
    };
    var response = await _client.get(Uri.parse(endpoint), headers: header);
    log('LOG > main_api.dart > fetchPatientReportingTime > 73 > response.statusCode: ${response.statusCode}');
    log('LOG > main_api.dart > fetchPatientReportingTime > 74 > response.body: ${response.body}');
    if (response.statusCode != 200) {
      Map map = jsonDecode(response.body);
      print(transformError(map));
      return Result.error(transformError(map));
    }
    dynamic json = jsonDecode(response.body);
    print('@main_api.dart/getStatus json: $json');
    var result = json["msg"] as String;
    return Result.value(result);
  }

  // Patient Side APIs

  @override
  Future<Result<treat.TreatmentReport>> fetchLastReport(Token token) async {
    String endpoint = baseUrl + "/treatment/patient/fetchLastReport";
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
    dynamic report = jsonDecode(response.body)['report'];

    return Result.value(treat.TreatmentReport.fromJson(jsonEncode(report)));
  }

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

  @override
  Future<Result<String>> emergencyRequest(
      Token token, Emergency emergency) async {
    print("Emergency Notification Send");
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
      "assessment": ans
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

  // Doctors Side APIs

  @override
  Future<Result<EDetails>> fetchEmergencyDetails(Token token,
      {String? patientID}) async {
    String endpoint =
        baseUrl + "/emergency/fetchEmergencyDetails?patientID=$patientID";
    print("Fetch Emergency Details");
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
  Future<Result<dynamic>> fetchPatientReport(Token token) async {
    String endpoint = baseUrl + "/treatment/getReport";
    var header = {
      "Content-Type": "application/json",
      "Authorization": token.value
    };
    var response = await _client.get(Uri.parse(endpoint), headers: header);
    print(
        'LOG > main_api.dart > fetchPatientReport > 202 > response.statusCode: ${response.statusCode}');
    print(
        'LOG > main_api.dart > fetchPatientReport > 203 > response.body: ${response.body}');
    if (response.statusCode != 200) {
      Map map = jsonDecode(response.body);
      print(transformError(map));
      return Result.error(transformError(map));
    }
    if (response.body == null)
      return Result.error('No report available currently!');
    dynamic currentReport = jsonDecode(response.body)['currentReport'];
    print("Report $currentReport");
    if (currentReport == null) return currentReport;
    dynamic previousReport = jsonDecode(response.body)['previousReports'];
    if (previousReport == null)
      return Result.value({
        "currentReport": currentReport['ecg'] != null
            ? treat.TreatmentReport.fromJson(jsonEncode(currentReport))
            : treat.TreatmentReport.initialize(),
        "previousReport": null
      });
    // if (currentReport['ecg'] == null) {
    //   print('HELLO WORLD');
    //   return Result.value({
    //     "currentReport": treat.TreatmentReport.initialize(),
    //     "previousReport":
    //         treat.TreatmentReport.fromJson(jsonEncode(previousReport))
    //   });
    // }
    return Result.value({
      "currentReport": currentReport["ecg"] == null
          ? treat.TreatmentReport.initialize()
          : treat.TreatmentReport.fromJson(jsonEncode(currentReport)),
      "previousReport":
          treat.TreatmentReport.fromJson(jsonEncode(previousReport))
    });
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
    log('DATA > main_api.dart > FUNCTION_NAME > 269 > response.statusCode: ${response.statusCode}');
    log('DATA > main_api.dart > FUNCTION_NAME > 270 > response.body: ${response.body}');
    if (response.statusCode != 200) {
      Map map = jsonDecode(response.body);
      print(transformError(map));
      return Result.error(transformError(map));
    }

    if (jsonDecode(response.body)['history'].length == 0)
      return Result.error("No history in records");
    List<treat.TreatmentReport> report =
        (jsonDecode(response.body)['history'] as List)
            .map((data) => treat.TreatmentReport.fromJson(jsonEncode(data)))
            .toList();
    print(report);
    return Result.value(report);
  }

  @override
  Future<Result<Examination>> fetchPatientExamReport(Token token) async {
    String endpoint = baseUrl + "/treatment/getTreatment";
    var header = {
      "Content-Type": "application/json",
      "Authorization": token.value
    };
    var response = await _client.get(Uri.parse(endpoint), headers: header);
    log('LOG > main_api.dart > fetchPatientExamReport > 269 > response.statusCode: ${response.statusCode}');
    log('LOG > main_api.dart > fetchPatientExamReport > 270 > response.body: ${response.body}');
    if (response.statusCode != 200) {
      Map map = jsonDecode(response.body);
      print(transformError(map));
      return Result.error(transformError(map));
    }
    dynamic report = jsonDecode(response.body)['treatment'];
    log('LOG > main_api.dart > fetchPatientExamReport > 277 > report: ${report}');
    var init = Examination.initialize();
    print('NTR REPORT');
    print(report);
    if (report['normalTreatment']['lmwh'] == null) return Result.value(init);
    return Result.value(Examination.fromJson(jsonEncode(report)));

    // try {
    //   return Result.value(report['normalTreatment'] != null
    //       ? Examination.fromJson(jsonEncode(report))
    //       : Examination.initialize());
    // } catch (e) {
    //   var res = Examination.initialize();
    //   print('@main_api/fetchPatientExamReport res: ${res.toString()}');
    //   return Result.value(res);
    // }
    // return Result.value(Examination.fromJson(jsonEncode(report)));
  }

  // Hub Side APIs

  @override
  Future<Result<dynamic>> acceptPatientbyHub(Token token, Token patient) async {
    String endpoint = baseUrl + "/treatment/hub/accept";
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
    return Result.value(json);
  }

  @override
  Future<Result<List<EDetails>>> fetchHubPatientDetails(Token token) async {
    String endpoint = baseUrl + "/treatment/hub/fetchPatientDetails";
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
    dynamic json = jsonDecode(response.body)["details"] as List;
    if (json.length == 0) return Result.error("No patients found");
    print(json);
    return Result.value(
        json.map<EDetails>((e) => EDetails.fromJson(jsonEncode(e))).toList());
  }

  @override
  Future<Result<List<EDetails>>> fetchHubRequests(Token token) async {
    String endpoint = baseUrl + "/treatment/hub/fetchRequests";
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
    dynamic json = jsonDecode(response.body)["details"] as List;
    if (json.length == 0) return Result.error("No patients found");
    print(json);
    return Result.value(
        json.map<EDetails>((e) => EDetails.fromJson(jsonEncode(e))).toList());
  }

  // Driver Side APIs

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

  // Spoke Side APIs

  @override
  Future<Result<Location>> acceptPatientbySpoke(
      Token token, Token patient) async {
    String endpoint = baseUrl + "/emergency/doctor/acceptPatient";
    var header = {
      "Content-Type": "application/json",
      "Authorization": token.value
    };
    var response = await _client.post(Uri.parse(endpoint),
        headers: header, body: jsonEncode({"patID": patient.value}));
    log('LOG > main_api.dart > 360 > response.statusCode: ${response.statusCode}');
    log('LOG > main_api.dart > 361 > response.body: ${response.body}');
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
  Future<Result<List<PatientListInfo>>> getAllPatients(Token token) async {
    String endpoint = baseUrl + "/emergency/doctor/getAllPatient";
    var header = {
      "Content-Type": "application/json",
      "Authorization": token.value
    };
    var response = await _client.post(Uri.parse(endpoint), headers: header);
    if (response.statusCode != 200) {
      Map map = jsonDecode(response.body);
      print(transformError(map));
      return Result.error(transformError(map));
    }

    dynamic json = jsonDecode(response.body)['patients'];
    return Result.value(json
        .map<PatientListInfo>(
            (element) => PatientListInfo.fromJson(jsonEncode(element)))
        .toList());
  }

  @override
  Future<Result<List<PatientListInfo>>> getAllPatientRequests(
      Token token) async {
    String endpoint = baseUrl + "/emergency/spoke/getAllRequests";
    var header = {
      "Content-Type": "application/json",
      "Authorization": token.value
    };
    var response = await _client.get(Uri.parse(endpoint), headers: header);
    //print the name of the function
    print("getAllPatientRequests");
    print(response.body);
    print(response.statusCode);
    if (response.statusCode != 200) {
      Map map = jsonDecode(response.body);
      print(transformError(map));
      return Result.error(transformError(map));
    }
    dynamic json = jsonDecode(response.body)['patients'];
    print(json.toString());
    if (json == null) return Result.error('No requests');
    return Result.value(json
        .map<PatientListInfo>(
            (element) => PatientListInfo.fromJson(jsonEncode(element)))
        .toList());
  }

  @override
  Future<Result<List<HubInfo>>> getAllHubDoctors(Token token) async {
    String endpoint = baseUrl + "/user/fetchHubDoctors";
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
    dynamic json = jsonDecode(response.body)["doctors"] as List;

    List<HubInfo> hubDoctors = json.map<HubInfo>((data) {
      print(data);
      return HubInfo.fromJson(jsonEncode(data));
    }).toList();

    return Result.value(hubDoctors);
  }

  @override
  Future<Result<String>> savePatientReport(
      Token token, treat.TreatmentReport report) async {
    print("Update Patient Report");
    String endpoint = baseUrl + "/treatment/spoke/updateReport";
    var header = {
      "Content-Type": "application/json",
      "Authorization": token.value
    };
    var response = await _client.post(Uri.parse(endpoint),
        headers: header, body: report.toJson());

    print(response.body);
    if (response.statusCode != 200) {
      Map map = jsonDecode(response.body);
      print(transformError(map));
      return Result.error(transformError(map));
    }
    dynamic json = jsonDecode(response.body);
    return Result.value(json["message"]);
  }

  @override
  Future<Result<String>> savePatientExamReport(
      Token token, Examination examination) async {
    String endpoint = baseUrl + "/treatment/spoke/updateTreatment";
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
  Future<Result<String>> updateStatus(Token token, String status) async {
    String endpoint = baseUrl + "/emergency/updateStatus";
    var header = {
      "Content-Type": "application/json",
      "Authorization": token.value
    };
    var response = await _client.post(Uri.parse(endpoint),
        headers: header, body: jsonEncode({'status': status}));
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

  @override
  Future<Result<String>> consultHub(Token token, String docID) async {
    String endpoint = baseUrl + "/treatment/spoke/consult";
    var header = {
      "Content-Type": "application/json",
      "Authorization": token.value
    };
    var response = await _client.post(Uri.parse(endpoint),
        headers: header, body: jsonEncode({'hubDocID': docID}));
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

  @override
  Future<Result<String>> uploadImage(
      Token token, XFile image, String type) async {
    print("Upload Image");
    print(image.name);
    String endpoint = baseUrl + "/treatment/spoke/uploadECG";
    final header = {
      // "Content-Type": "application/json",
      "Authorization": token.value
    };
    var file = await http.MultipartFile.fromBytes(
        'file', await image.readAsBytes(),
        filename: image.name, contentType: MediaType('image', 'jpg'));
    var request = http.MultipartRequest('POST', Uri.parse(endpoint))
      ..headers["Authorization"] = token.value;
    request.fields['type'] = type;
    request.files.add(file);
    var response = await request.send();

    if (response.statusCode != 200) {
      print("error");
      return Result.error("Server Error");
    }
    print("Image Uploaded ,${response.statusCode}");
    return Result.value("Image Uploaded");
  }

  @override
  Future<Result<XFile>> fetchImage(Token token, String patientID) async {
    String endpoint = baseUrl + "/treatment/fetchECG";
    var header = {
      "Content-Type": "application/json",
      "Authorization": token.value
    };
    var response = await _client.post(Uri.parse(endpoint),
        headers: header, body: jsonEncode({'patientID': patientID}));
    print(response.statusCode);
    print(response.bodyBytes);
    if (response.statusCode != 200) {
      Map map = jsonDecode(response.body);
      print(transformError(map));
      return Result.error(transformError(map));
    }

    return Result.value(XFile.fromData(response.bodyBytes));
  }

  @override
  Future<Result<String>> newReport(Token token) async {
    String endpoint = baseUrl + "/treatment/spoke/newReport";
    var header = {
      "Content-Type": "application/json",
      "Authorization": token.value
    };
    var response = await _client.post(Uri.parse(endpoint),
        headers: header, body: jsonEncode({}));
    print('@main_api.dart/newReport response status: ${response.statusCode}');
    print('@main_api.dart/newReport response body: ${response.body}');
    if (response.statusCode != 200) {
      Map map = jsonDecode(response.body);
      print(transformError(map));
      return Result.error(transformError(map));
    }
    dynamic json = jsonDecode(response.body);
    return Result.value(json["message"]);
  }

  @override
  Future<Result<List<Message>>> getAllMessages(
      Token token, String patientID) async {
    String endpoint = baseUrl + "/treatment/getAllMessage?patientID=$patientID";
    var header = {
      "Content-Type": "application/json",
      "Authorization": token.value
    };
    var response = await _client.get(Uri.parse(endpoint), headers: header);
    print(
        '@main_api.dart/getAllMessages response status: ${response.statusCode}');
    print('@main_api.dart/getAllMessages response body: ${response.body}');
    // print(response.statusCode);
    if (response.statusCode != 200) {
      Map map = jsonDecode(response.body);
      print(transformError(map));
      return Result.error(transformError(map));
    }
    if (jsonDecode(response.body)["messages"] == null ||
        jsonDecode(response.body)["messages"].length == 0)
      return Result.error("error");
    dynamic json = jsonDecode(response.body)["messages"] as List;
    print(json.last);
    return Result.value(json
        .map<Message>((message) => Message.fromJson(jsonEncode(message)))
        .toList());
  }
}
