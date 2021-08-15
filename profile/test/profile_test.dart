//@dart=2.9
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:http/http.dart' as http;
import 'package:profile/src/domain/profile.dart';
import 'package:profile/src/infra/api/profile_api.dart';
import 'package:profile/src/domain/token.dart';
void main() {
  ProfileApi sut;
  http.Client _client;
  String baseUrl = "http://localhost:3000";
  String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiNjBkZGIyNTY0MDY0MGFhYmZiNzFiZmNhIiwiaWF0IjoxNjI1MTQxODQ2LCJleHAiOjE2MjU3NDY2NDYsImlzcyI6ImNvbS5jY2FyZW5pdGgifQ.IvVyHFQ2e0pkv2fbNGY9mrN5ab2xjj6ZKzU9JYqrV_E";
  setUp((){
    _client = http.Client();
    sut = ProfileApi(_client, baseUrl);
  });
  group(("Profile Tests"), (){
    test("updateProfile",() async {
      Token _token = Token(token);
      var data= Profile.fromJson(jsonEncode(pr));
      print(data.toString());
      dynamic result = await sut.updateProfile(_token, data);
      expect(result, isNot(Error));
      print(result.asValue.value);
    });

  test("getProfile",() async {
    Token _token = Token(token);
    dynamic result = await sut.getProfile(_token);

    expect(result, isNot(Error));
    print(result.asValue.value.toString());
  });
  });
}

const pr  = {
    "firstName":"Danish",
    "lastName":"Sheikh",
    "address":{
        "houseAddress":"VPO Tissa",
        "city":"Tissa",
        "district":"chamba",
        "state":"H.P",
        "pincode":1745966
    },
    "dob":"2000-08-14",
    "height":280,
    "weight":45,
    "medicalHistory":["Asthma"]
};