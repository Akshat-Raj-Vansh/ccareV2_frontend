//@dart=2.9
// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:ccarev2_frontend/main/infra/main_api.dart';
import 'package:ccarev2_frontend/user/domain/token.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:http/http.dart' as http;

void main() {
  MainAPI api;
  setUp(() {
    String baseUrl = "http://localhost:3000";
    var client = http.Client();
    api = MainAPI(client, baseUrl);
  });

  group('FetchDetails', () {
    test('returns patient and driver details', () async {
      String token =
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiNjEzOGQyMDhlYmQzY2M4MmUxZmY2NWUyIiwiaWF0IjoxNjMxMTEzNzM3LCJleHAiOjE2MzE3MTg1MzcsImlzcyI6ImNvbS5jY2FyZW5pdGgifQ.OBCE6xyzGe0X6O3QoDIld5zIaXzN6GequUVzTreEtHY";

      // dynamic result = await api.fetchEmergencyDetails(Token(token),patientID:token.value);

      // if(result.isError)
      //   //print(result.asError.error);
      // else
      // //print(result.asValue.value);
    });
  });
}
