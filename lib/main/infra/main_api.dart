import 'dart:convert';
import 'dart:io';
import 'package:ccarev2_frontend/main/domain/edetails.dart';
import 'package:ccarev2_frontend/main/domain/examination.dart';
import 'package:ccarev2_frontend/main/domain/treatment.dart' as treat;
import 'package:ccarev2_frontend/pages/chat/components/message.dart';
import 'package:ccarev2_frontend/user/domain/doc_info.dart';
import 'package:ccarev2_frontend/user/domain/emergency.dart';
import 'package:ccarev2_frontend/user/domain/hub_doc_info.dart';
import 'package:ccarev2_frontend/user/domain/location.dart';
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

  // Patient Side APIs

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
    if (response.statusCode!= 200) {
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
  Future<Result<EDetails>> fetchEmergencyDetails(Token token) async {
    String endpoint = baseUrl + "/emergency/fetchEmergencyDetails";
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
    print(response.statusCode);
    print(response.body);
    if (response.statusCode != 200) {
      Map map = jsonDecode(response.body);
      print(transformError(map));
      return Result.error(transformError(map));
    }
    dynamic currentReport = jsonDecode(response.body)['currentReport'];
    print("Report $currentReport");
    if(currentReport==null)  return currentReport;
    dynamic previousReport= jsonDecode(response.body)['previousReport'];
    if(previousReport==null) 
    return Result.value({
      "currentReport": treat.TreatmentReport.fromJson(jsonEncode(currentReport)),
      "previousReport" :null
    });

    return Result.value({
      "currentReport": treat.TreatmentReport.fromJson(jsonEncode(currentReport)),
      "previousReport":treat.TreatmentReport.fromJson(jsonEncode(previousReport))
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
    if(json.length==0) return Result.error("No patients found");
    print(json);
    return Result.value(json.map<EDetails>((e) => EDetails.fromJson(jsonEncode(e))).toList());
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
    if(json.length==0) return Result.error("No patients found");
    print(json);
    return Result.value(json.map<EDetails>((e) => EDetails.fromJson(jsonEncode(e))).toList());
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
  Future<Result<String>> uploadImage(Token token, XFile image,String type) async {
    print("Upload Image");
    print(image.name);
      String endpoint = baseUrl + "/treatment/spoke/uploadECG";
    final header = {
      // "Content-Type": "application/json",
      "Authorization": token.value
    };
    var file = await http.MultipartFile.fromBytes('file', await image.readAsBytes(),filename:image.name, contentType:MediaType('image', 'jpg'));
    var request = http.MultipartRequest('POST',Uri.parse(endpoint))
  ..headers["Authorization"]= token.value;
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
  Future<Result<XFile>> fetchImage(Token token, String patientID) async  {
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
  Future<Result<List<Message>>> getAllMessages(Token token, String patientID) async {
   String endpoint = baseUrl + "/treatment/getAllMessage?patientID=$patientID";
    var header = {
      "Content-Type": "application/json",
      "Authorization": token.value
    };
    var response = await _client.get(Uri.parse(endpoint),
        headers: header);
    print(response.statusCode);
    print(response.bodyBytes);
    if (response.statusCode != 200) {
      Map map = jsonDecode(response.body);
      print(transformError(map));
      return Result.error(transformError(map));
    }
  
  dynamic json = jsonDecode(response.body)["messages"] as List;
    return json.map<Message>((message)=>Message.fromJson(jsonEncode(message)));
   
  }
}
