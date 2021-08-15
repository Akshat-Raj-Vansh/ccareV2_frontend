import 'dart:convert';

import 'package:profile/src/domain/token.dart';
import 'package:profile/src/domain/profile.dart';
import 'package:async/src/result/result.dart';
import 'package:profile/src/infra/api/profile_api_contract.dart';
import 'package:http/http.dart' as http;

class ProfileApi implements IProfileApi {
  final http.Client _client;
  final String baseUrl;
  var header = {
    "Content-Type": "application/json",
  };
  ProfileApi(
    this._client,
    this.baseUrl,
  );
  @override
  Future<Result<Profile>> getProfile(Token token) async {
    String endpoint = this.baseUrl + "/doctorprofile/get";
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
    return Result.value(Profile.fromJson(json));
  }

  @override
  Future<Result<String>> updateProfile(Token token, Profile profile) async {
    String endpoint = this.baseUrl + "/doctorprofile/update";
    var header = {
      "Content-Type": "application/json",
      "Authorization": token.value
    };
    var response = await this
        ._client
        .post(endpoint, headers: header, body: profile.toJson());
    if (response.statusCode != 200) {
      Map map = jsonDecode(response.body);
      print(transformError(map));
      return Result.error(transformError(map));
    }
    dynamic json = jsonDecode(response.body);
    return Result.value(json["message"]);
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
