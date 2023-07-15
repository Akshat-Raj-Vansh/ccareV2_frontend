import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import '../../data/credential.dart';
import '../../data/token.dart';
// import '../../../state_management/user/user_cubit.dart';
// import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:flutter/material.dart';

class AuthenticationController {
  static UserType userType = UserType.PATIENT;
  static String _phone = "";
  static UserType _type = UserType.PATIENT;
  static bool _verified = false;
  static String _verificationCode = "";

  static configure(UserType type) {
    _type = type;
  }

  static get getFCMToken async => await FirebaseMessaging.instance.getToken();
  static get getPhone => _phone;

  static verifyPhone(String phone, BuildContext context) async {
    String _msg = "VERIFICATION INCOMPLETE";
    _phone = phone;
    _verificationCode = "";
    _verified = false;
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: "+91" + _phone,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await FirebaseAuth.instance
                .signInWithCredential(credential)
                .then((value) async {
              if (value.user != null) {
                _verified = true;
                _msg = "VERIFICATION SUCCESSFUL " + value.user!.uid;
                print('auth_page.dart : ' + _msg);
                CubitProvider.of<UserCubit>(context).login(Credential(_phone,
                    userType, getFCMToken, Token(value.user!.uid.toString())));
              }
            });
          },
          verificationFailed: (FirebaseAuthException e) {
            _msg = "VERIFICATION FAILED " + e.toString();
          },
          codeSent: (String verificationID, int resendToken) {
            if (!_verified) {
              _msg = "CODE SENT " + verificationID;
              _verificationCode = verificationID;
              CubitProvider.of<UserCubit>(context).verifyOTP();
            }
          },
          codeAutoRetrievalTimeout: (String verificationID) {
            print('Auto Timeout Reached');
          },
          timeout: const Duration(seconds: 0));
    } catch (e) {
      _msg = "VERIFICATION FAILED " + e.toString();
    }
  }

  static verifyOTP(String otp, BuildContext context) async {
    // _showLoader();
    String _msg = "OTP VERIFICATION INCOMPLETE";
    print('INSIDE VERIFY OTP');

    try {
      await FirebaseAuth.instance
          .signInWithCredential(PhoneAuthProvider.credential(
              verificationId: _verificationCode, smsCode: otp))
          .then((value) async {
        if (value.user != null) {
          _msg = "VERIFICATION SUCCESSFUL OTP " + value.user.uid;
          print('auth_page.dart : ' + _msg);
          CubitProvider.of<UserCubit>(context).login(Credential(
              _phone, userType, getFCMToken, Token(value.user.uid.toString())));
        } else {
          _msg = "VERIFICATION FAILED. INVALID OTP.";
          print(_msg);
        }
      }).catchError((err) {
        print(err);
      });
    } catch (e) {}
    // _hideLoader();
  }
}
