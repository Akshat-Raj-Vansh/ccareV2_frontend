//@dart=2.9
import 'package:ccarev2_frontend/pages/auth/components/otp_form.dart';
import 'package:ccarev2_frontend/pages/auth/components/phone_form.dart';
import 'package:ccarev2_frontend/pages/auth/components/type_form.dart';
import 'package:ccarev2_frontend/pages/splash/splash_screen.dart';
import 'package:ccarev2_frontend/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:sizer/sizer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../customBuilds/customtextformfield.dart';
import '../../state_management/profile/profile_cubit.dart';
import '../../state_management/profile/profile_state.dart' as profileState;
import '../../state_management/user/user_state.dart';
import '../../user/domain/credential.dart';
import '../../user/domain/token.dart';
import '../../state_management/user/user_cubit.dart';
import '../../utils/loaders.dart';
import 'auth_page_adapter.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import '../../utils/size_config.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  final IAuthPageAdapter pageAdatper;
  AuthPage({
    this.pageAdatper,
  });
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  UserType _userType;
  String _verificationCode = "";
  String _otp = "";
  String _phone = "";
  String _fcmToken = "";
  bool verified = false;

  int hex(String color) {
    return int.parse("FF" + color.toUpperCase(), radix: 16);
  }

  AnimationController animationController;
  final PageController _controller = PageController();

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    print('AUTH PAGE');
    FirebaseMessaging.instance.getToken().then((value) => _fcmToken = value);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await _onBackPressed(context);
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
              child: Container(
            width: double.infinity,
            color: const Color(0xFFE1D9D9),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 10,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: _showBackground(context),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: CubitConsumer<UserCubit, UserState>(
                    builder: (_, state) {
                      print("Builder State $state");
                      // var cubit = CubitProvider.of<UserCubit>(context);

                      return _buildUI();
                    },
                    listener: (_, state) {
                      print(context);
                      print("Listener State: $state");
                      if (state is LoadingState) {
                        print('Inside Loading State in Auth Page');
                      }
                      if (state is LoginInProcessState) {
                        Loaders.showLoader(context);
                        print('Inside Loading State in Auth Page');
                      } else if (state is LoginSuccessState) {
                        print("Login Success State Called");
                        Loaders.hideLoader(context);
                        print(_userType);
                        state.details.newUser
                            ? widget.pageAdatper
                                .onAuthSuccess(context, _userType)
                            : widget.pageAdatper
                                .onLoginSuccess(context, _userType);
                        print(state.details.toString());
                      } else if (state is PhoneVerificationState) {
                        Loaders.showLoader(context);
                        print("Phone Verification State Called");
                        _phone = state.phone;
                        _verifyPhone(_phone);
                      } else if (state is OTPVerificationState) {
                        //print("OTP State Called");
                        Loaders.hideLoader(context);

                        _controller.nextPage(
                            duration: const Duration(microseconds: 1000),
                            curve: Curves.elasticIn);
                      } else {
                        //   // _hideLoader();
                        if (state is ErrorState) {
                          //print("Error State Called");
                          //print(state.error);
                          Loaders.showSnackbar(context, state.error);
                        }
                      }
                    },
                  ),
                ),
                CubitListener<ProfileCubit, profileState.ProfileState>(
                  child: Container(),
                  listener: (context, state) {
                    if (state is profileState.LoadingState) {
                      //print("LoadingStateCalled");
                      //  _showLoader();
                    } else if (state is profileState.AddProfileState) {
                      widget.pageAdatper.onLoginSuccess(context, _userType);
                    } else {
                      //   // _hideLoader();
                      if (state is profileState.ErrorState) {
                        //print("ErrorState");
                        //print(state.error);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Theme.of(context).accentColor,
                          content: Text(
                            state.error,
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(color: Colors.white, fontSize: 8.sp),
                          ),
                        ));
                      }
                    }
                  },
                )
              ],
            ),
          ))),
    );
  }

  _onBackPressed(BuildContext context) =>
      // Navigator.of(context).pop(true);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => SplashScreen(widget.pageAdatper)),
          (Route<dynamic> route) => false);

  _showBackground(BuildContext context) => Container(
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Text(
              "CardioCare",
              style: TextStyle(
                fontSize: 32.sp,
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              "Welcome to CardioCare,\n Let’s take care of your heart!",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            Image.asset(
              "assets/images/sp1e.png",
              height: getProportionateScreenHeight(45.h),
              width: getProportionateScreenWidth(80.w),
            ),
          ],
        ),
      );

  _launchPhoneForm(UserType userType) {
    _controller.nextPage(
        duration: const Duration(microseconds: 1000), curve: Curves.elasticIn);
    _userType = userType;
  }

  _launchPhoneVerificationState(String phone) {
    Loaders.showLoader(context);
    print("Phone Verification State Called");
    _phone = phone;
    _verifyPhone(_phone);
  }

  _buildUI() => Container(
        height: 40.h + SizeConfig.bottomInsets,
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: PageView(
          controller: _controller,
          physics: NeverScrollableScrollPhysics(),
          children: [
            TypeForm(_launchPhoneForm, _onBackPressed),
            PhoneForm(_controller, CubitProvider.of<UserCubit>(context),
                _verifyPhone, _launchPhoneVerificationState, _onBackPressed),
            OTPForm(_controller, CubitProvider.of<UserCubit>(context),
                _verifyOTP, _phone),
          ],
        ),
      );

  _verifyPhone(String phone) async {
    print('INSIDE VERIFY PHONE');
    print("AuthPage: $_phone");
    String _msg = "VERIFICATION INCOMPLETE";
    _verificationCode = "";
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: "+91" + _phone,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await FirebaseAuth.instance
                .signInWithCredential(credential)
                .then((value) async {
              if (value.user != null) {
                verified = true;
                _msg = "VERIFICATION SUCCESSFUL " + value.user.uid;
                print('auth_page.dart : ' + _msg);
                CubitProvider.of<UserCubit>(context).login(Credential(_phone,
                    _userType, _fcmToken, Token(value.user.uid.toString())));
              }
            });
          },
          verificationFailed: (FirebaseAuthException e) {
            _msg = "VERIFICATION FAILED " + e.toString();
            //    // _hideLoader();
            Loaders.showSnackbar(context, _msg);
          },
          codeSent: (String verificationID, int resendToken) {
            if (!verified) {
              setState(() {
                _msg = "CODE SENT " + verificationID;
                _verificationCode = verificationID;
                CubitProvider.of<UserCubit>(context).verifyOTP();
              });
            }
          },
          codeAutoRetrievalTimeout: (String verificationID) {
            print('Auto Timeout Reached');
          },
          timeout: const Duration(seconds: 10));
    } catch (e) {
      _msg = "VERIFICATION FAILED " + e.toString();
      //  // _hideLoader();
      Loaders.showSnackbar(context, _msg);
    }
  }

  _verifyOTP(String otp) async {
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
              _phone, _userType, _fcmToken, Token(value.user.uid.toString())));
        } else {
          _msg = "VERIFICATION FAILED. INVALID OTP.";
          print('INVALID OTP');
          // _hideLoader();
          Loaders.showSnackbar(context, _msg);
        }
      }).catchError((err) {
        print(err);
        //print("INVALID OTP 2");
        print('ERROR: ' + err.toString());
        Loaders.showSnackbar(context, 'WRONG OTP ENTERED');
      });
    } catch (e) {
      _msg = "VERIFICATION FAILED " + e.toString();
      // _hideLoader();
      Loaders.showSnackbar(context, _msg);
    }
    // _hideLoader();
  }
}
