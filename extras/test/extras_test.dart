//@dart=2.9
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:http/http.dart' as http;

import '../lib/src/domain/token.dart';
import '../lib/src/domain/token.dart';
import '../lib/src/infra/main_api.dart';
import '../lib/src/infra/main_api_contract.dart';

void main() {
  IMainApi sut;
  http.Client _client;
  String baseUrl = "http://localhost:3000";
  String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiNjBlZWI4MTI1MDU4NjE2YzcwNjBlMDZmIiwiaWF0IjoxNjI2MjU3NDI2LCJleHAiOjE2MjY4NjIyMjYsImlzcyI6ImNvbS5jY2FyZW5pdGgifQ.rMbQGLYYVuVxqqaggHfnXMx9ylR_TsSQrSxPVX9kGg0";
   setUp((){
    _client = http.Client();
    sut = MainApi(_client, baseUrl);
  });
  group(("Questions"), (){
    test("getAll",() async {
      Token _token = Token(token);
      dynamic result = await sut.getAll(_token);
      expect(result, isNot(Error));
      print(result.asValue.value.length);
    });

 
  });
}

