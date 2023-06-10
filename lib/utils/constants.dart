import 'package:flutter/material.dart';
import 'size_config.dart';

import 'package:sizer/sizer.dart';

const BASEURL = 'http://3.143.255.116:3000';
// const BASEURL = "http://192.168.125.151:3000";

const kPrimaryColor = Color(0XFF17AD75);
const kPrimaryLightColor = Color(0XFF38CC8F);
const kAccentColor = Color(0XFF17AC75);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);
const kButtonColor = Color(0XFFF17AD75);

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: 28.sp,
  fontWeight: FontWeight.bold,
  color: Colors.blue,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";

final otpInputDecoration = InputDecoration(
  counterText: "",
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(8)),
    borderSide: BorderSide(color: kTextColor),
  );
}


//getPropotionateScreenWidth(285) -> 80.w
//getPropotionateScreenWidth(400) -> 45.h
//getPropotionateScreenWidth(36) -> 32.sp 
//padding horizontal 20 -> 5.w 
// height 20 -> 3.h
//fontSize reduce by 30%
//getPropotionalScreenHeight(42) -> 5.h
//getPropotionalScreenWidth(90) -> 25.w