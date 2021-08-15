import 'dart:convert';

class OtpMessage {
  String message;
  String otptoken;
  OtpMessage({
     this.message,
     this.otptoken,
  });

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'otptoken': otptoken,
    };
  }

  factory OtpMessage.fromMap(Map<String, dynamic> map) {
    return OtpMessage(
      message: map['message'],
      otptoken: map['otptoken'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OtpMessage.fromJson(String source) => OtpMessage.fromMap(json.decode(source));
}
