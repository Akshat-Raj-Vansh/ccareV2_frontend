import 'package:auth/src/domain/credential.dart';
import 'package:auth/src/domain/otpMessage.dart';
import 'package:auth/src/infra/adapters/email_signUp.dart';
import 'package:auth/src/infra/api/auth_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  AuthApi api;
  SignUpService sut2;
  setUp((){
    sut2 = SignUpService(api);
  });

//   group("signup",(){
    
//     test("email signup returns message with otpToken",() async {
//       Credential credential = Credential(email: "danishindia1999@gmail.com", type: AuthType.email,name: "Danish",password: "danishindia1999@gmial.com");
//       var result = await sut.signUp(credential);
//       expect(result.isValue, true);
//       tokenString = jsonDecode(result.asValue.value)["otptoken"];
//       print(tokenString);
        
//   });

//    test("Google signup returns user",() async {
//       Credential credential = Credential(email: "danishindia@gmail.com", type: AuthType.google,name: "Danish");
//       var result = await sut.signUp(credential);
//       expect(result.isValue, true);
//       print(result.asValue.value);
        
//   });
  
//   });

//   group("verify",(){
    
//     test("should return user details",() async {
//       tokenString="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiNjBkNjE1NjZkYTg1NmJkNjZmOTg3NmYwIiwiaWF0IjoxNjI0NjQ0NjM5LCJleHAiOjE2MjUyNDk0MzksImlzcyI6ImNvbS5jY2FyZW5pdGgifQ.JRAc4ZBqaNuAEkE8LYf7N7hn6y4uaYQ2o1aBOM2vSsE";
//       Token token = Token(tokenString);
//       print(tokenString);
//      // Credential credential = Credential(email: "danishindia1999@gmail.com", type: AuthType.email,name: "Danish",password: "danishindia1999@gmial.com");
//       var result = await sut.verify("360926",token);
//       if(result.isValue)
//         print(result.asValue.value);
//       else 
//         print(result.asError.error);
        
//   });

// });

  group("SignUpService",(){
    
    test("should return otpmessage",() async {
     
     Credential credential = Credential(email: "danishindia1999@gmail.com", type: AuthType.email,name: "Danish",password: "danishindia1999@gmial.com");
      var result = await sut2.signUp(credential.email, credential.password, credential.name);
      if(result is OtpMessage)
        print("success");
      if(result.isValue)
        print(result.asValue.value);
      else 
        print(result.asError.error);
        
  });

});

}