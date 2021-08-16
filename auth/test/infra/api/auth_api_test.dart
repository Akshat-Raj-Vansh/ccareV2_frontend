import 'package:auth/src/domain/credential.dart';
import 'package:auth/src/infra/api/auth_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:async/async.dart';
class MockClient extends Mock implements  http.Client{}
void main(){
  MockClient _mock;
  AuthApi _api;
  setUp((){
    _mock = MockClient();
    _api = AuthApi(_mock, "http:baseUrl");

  });
group("signin", (){
  Credential credential = Credential(email: "email@email", type: AuthType.email,password: "password");
  test("when the status code is not 200", () async {
    when(_mock.post(any,body:anyNamed('body'))).thenAnswer((_)async =>http.Response('{}',404) );
    dynamic result = await _api.signIn(credential);
    expect(result, isA<ErrorResult>());
  });
    test("when the status code is 200 but response is null", () async {
    when(_mock.post(any,body:anyNamed('body'))).thenAnswer((_)async =>http.Response('{"message":"Email is not valid"}',200) );
    dynamic result = await _api.signIn(credential);
    print(result.asError.error);
    expect(result, isA<ErrorResult>());
  });
    test("when the status code is 200 and working", () async {
    when(_mock.post(any,body:anyNamed('body'))).thenAnswer((_)async =>http.Response('{"authToken":"abbc"}',200) );
    dynamic result = await _api.signIn(credential);
    
    expect(result.asValue.value,"abbc" );
  });
});
}