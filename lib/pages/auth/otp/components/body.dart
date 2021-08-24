//@dart=2.9
import 'package:ccarev2_frontend/state_management/user/user_cubit.dart';
import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:ccarev2_frontend/user/domain/token.dart';
import 'package:ccarev2_frontend/user/domain/user_service_contract.dart';
import 'package:ccarev2_frontend/user/infra/user_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/size_config.dart';
import 'package:flutter/material.dart';

import 'otp_form.dart';

class Body extends StatefulWidget {
  final UserCubit cubit;
  final Credential credential;
  final UserAPI userAPI;
  Body(
    this.cubit,
    this.credential,
    this.userAPI,
  );

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with TickerProviderStateMixin {
  AnimationController animationController;
  String _verificationCode;

  String get timeString {
    Duration duration =
        animationController.duration * animationController.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(minutes: 5));
    animationController.reverse(
        from: animationController.value == 0 ? 1.0 : animationController.value);
    _verifyPhone();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildbody();
  }

  buildbody() {
    return Container(
      height: 300,
      color: Colors.white,
      width: double.infinity,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.02),
              // _showLogo(context),
              const Text(
                'Enter Mobile Number',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                "We sent your code to - ${widget.credential.phone}",
                style: const TextStyle(color: Colors.green, fontSize: 16),
              ),
              buildTimer(),
              GestureDetector(
                onTap: () {
                  animationController.reverse(
                      from: animationController.value == 0
                          ? 1.0
                          : animationController.value);
                  // widget.cubit.resend(widget.phoneAuth);
                },
                child: const Text(
                  "Resend OTP Code",
                  style: TextStyle(
                      color: Colors.green,
                      decoration: TextDecoration.underline),
                ),
              ),
              OtpForm(
                  widget.cubit, widget.userAPI, validateOTP, _verificationCode),
              SizedBox(height: SizeConfig.screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  Row buildTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("This code will expired in ",
            style: TextStyle(fontSize: 16, color: Colors.green)),
        AnimatedBuilder(
          animation: animationController,
          builder: (_, child) {
            return Text(timeString,
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold));
          },
        )
      ],
    );
  }

  validateOTP(String pin) async {
    print('Inside validate OTP');
    try {
      await FirebaseAuth.instance
          .signInWithCredential(PhoneAuthProvider.credential(
              verificationId: _verificationCode, smsCode: pin))
          .then((value) async {
        if (value.user != null) {
          Credential credential = Credential(
              widget.credential.phone,
              widget.credential.type,
              "fcmtoken",
              Token(value.user.uid.toString()));
          // print('token' + value.credential.token.toString());
          widget.cubit.login(credential);
          print('Success validate');
        }
      });
    } catch (e) {
      print('invalid OTP');
      print(e);
    }
  }

  _verifyPhone() async {
    print('Inside verify phone');
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+91 " + widget.credential.phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              Credential credential = Credential(
                  widget.credential.phone,
                  widget.credential.type,
                  "fcmtoken",
                  Token(value.user.uid.toString()));
              // print('token' + value.credential.token.toString());
              widget.cubit.login(credential);
              print('Successs BODY');
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verficationID, int resendToken) {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
            print("verification id" + _verificationCode);
          });
        },
        timeout: Duration(seconds: 120));
  }
}
