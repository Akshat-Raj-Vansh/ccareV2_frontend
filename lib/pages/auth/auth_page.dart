//@dart=2.9
import 'package:ccarev2_frontend/pages/profile/profile_page_adapter.dart';
import 'package:ccarev2_frontend/pages/profile/profile_screen.dart';
import 'package:ccarev2_frontend/pages/splash/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../customBuilds/customtextformfield.dart';
import '../../state_management/profile/profile_cubit.dart';
import '../../state_management/profile/profile_state.dart' as profileState;
import '../../state_management/user/user_state.dart';
import '../../user/domain/credential.dart';
import '../../user/domain/token.dart';
import '../../user/infra/user_api.dart';
import '../../state_management/user/user_cubit.dart';
import 'auth_page_adapter.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import '../../utils/size_config.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  final IAuthPageAdapter pageAdatper;
  final UserType userType;
  AuthPage({
    this.pageAdatper,
    this.userType,
  });
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with TickerProviderStateMixin {
  String _verificationCode = "";
  String _otp = "";
  String _phone = "";
  String _fcmToken = "";

  int hex(String color) {
    return int.parse("FF" + color.toUpperCase(), radix: 16);
  }

  String get timeString {
    Duration duration =
        animationController.duration * animationController.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  AnimationController animationController;
  final PageController _controller = PageController();

  final _formkey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: const Duration(minutes: 2));
    animationController.reverse(
        from: animationController.value == 0 ? 1.0 : animationController.value);
    FirebaseMessaging.instance.getToken().then((value) => _fcmToken = value);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
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
                      var cubit = CubitProvider.of<UserCubit>(context);
                      return _buildUI(context, cubit);
                    },
                    listener: (context, state) {
                      if (state is LoadingState) {
                        print("Loading State Called");
                        _showLoader();
                      } else if (state is LoginSuccessState) {
                        print("Login Success State Called");
                        _hideLoader();
                        // var cubit = CubitProvider.of<ProfileCubit>(context);
                        print(widget.userType);
                        state.details.newUser
                            ? widget.pageAdatper
                                .onAuthSuccess(context, widget.userType)
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             ProfileScreen(cubit, state.details)))
                            : widget.pageAdatper
                                .onLoginSuccess(context, widget.userType);
                        print(state.details.toString());
                      } else if (state is PhoneVerificationState) {
                        _hideLoader();
                        print("PhoneVerification State Called");
                        _showLoader();
                        _verifyPhone(_phone);
                      } else if (state is OTPVerificationState) {
                        print("OTP State Called");
                        _hideLoader();
                        _controller.nextPage(
                            duration: const Duration(microseconds: 1000),
                            curve: Curves.elasticIn);
                      } else {
                        _hideLoader();
                        if (state is ErrorState) {
                          print("Error State Called");
                          print(state.error);
                          _showMessage(state.error);
                        }
                      }
                    },
                  ),
                ),
                CubitListener<ProfileCubit, profileState.ProfileState>(
                  child: Container(),
                  listener: (context, state) {
                    if (state is profileState.LoadingState) {
                      print("LoadingStateCalled");
                      _showLoader();
                    } else if (state is profileState.AddProfileState) {
                      widget.pageAdatper
                          .onLoginSuccess(context, widget.userType);
                    } else {
                      _hideLoader();
                      if (state is profileState.ErrorState) {
                        print("ErrorState");
                        print(state.error);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Theme.of(context).accentColor,
                          content: Text(
                            state.error,
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(color: Colors.white, fontSize: 16),
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

  _onBackPressed(BuildContext context) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SplashScreen(widget.pageAdatper)),
      (Route<dynamic> route) => false);

  _showLoader() {
    var alert = const AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Center(
          child: CircularProgressIndicator(
        backgroundColor: Colors.green,
      )),
    );

    showDialog(
        context: context, barrierDismissible: true, builder: (_) => alert);
  }

  _hideLoader() {
    Navigator.of(context, rootNavigator: true).pop();
  }

  _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).accentColor,
      content: Text(
        msg,
        style: Theme.of(context)
            .textTheme
            .caption
            .copyWith(color: Colors.white, fontSize: 16),
      ),
    ));
  }

  _showBackground(BuildContext context) => Container(
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Text(
              "CardioCare",
              style: TextStyle(
                fontSize: getProportionateScreenWidth(36),
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 38),
            const Text(
              "Welcome to CardioCare,\n Let’s take care of your heart!",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 38),
            Image.asset(
              "assets/images/sp1.png",
              height: getProportionateScreenHeight(400),
              width: getProportionateScreenWidth(285),
            ),
          ],
        ),
      );

  _buildUI(BuildContext context, UserCubit cubit) => Container(
        height: 300,
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: PageView(
          controller: _controller,
          physics: NeverScrollableScrollPhysics(),
          children: [_phoneForm(context, cubit), _otpForm(context, cubit)],
        ),
      );

  _phoneForm(BuildContext context, UserCubit cubit) => Container(
        height: 300,
        color: Colors.white,
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => _onBackPressed(context),
                        icon: const Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                      ),
                      const Text(
                        'Enter Mobile Number',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        '+91',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                        ),
                      ),
                      CustomTextFormField(
                          hint: "Mobile Number",
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          color: Colors.blue,
                          width: MediaQuery.of(context).size.width * 0.70,
                          backgroundColor: Colors.white,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            _phone = value;
                          },
                          validator: (phone) => phone.isEmpty
                              ? "Please enter a Phone Number"
                              : null),
                    ],
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.06),
                  RaisedButton(
                    onPressed: () async {
                      if (_formkey.currentState.validate()) {
                        cubit.verifyPhone();
                      }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.all(0),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.5,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      decoration: ShapeDecoration(
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  _otpForm(BuildContext context, UserCubit cubit) {
    animationController.reverse(
        from: animationController.value == 0 ? 1.0 : animationController.value);
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
              Row(
                children: [
                  IconButton(
                    onPressed: () => _controller.previousPage(
                        duration: const Duration(microseconds: 1000),
                        curve: Curves.elasticIn),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                    ),
                  ),
                  const Text(
                    'Enter OTP',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomTextFormField(
                      hint: "OTP",
                      obscureText: false,
                      keyboardType: TextInputType.number,
                      color: Colors.blue,
                      width: MediaQuery.of(context).size.width * 0.40,
                      backgroundColor: Colors.white,
                      textAlign: TextAlign.center,
                      initialValue: "",
                      onChanged: (value) {
                        _otp = value;
                      },
                      validator: (otp) => otp.isEmpty
                          ? "Please enter the OTP"
                          : otp.length != 6
                              ? "Please enter a valid OTP"
                              : null),
                  buildTimer(),
                ],
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.02),
              Text(
                "We sent your code to - $_phone",
                style: const TextStyle(color: Colors.green, fontSize: 16),
              ),
              GestureDetector(
                onTap: () {
                  animationController.reverse(
                      from: animationController.value == 0
                          ? 1.0
                          : animationController.value);
                  cubit.verifyPhone();
                },
                child: const Text(
                  "Resend OTP Code",
                  style: TextStyle(
                      color: Colors.green,
                      decoration: TextDecoration.underline),
                ),
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.02),
              RaisedButton(
                // onPressed: () async {
                //   if (_otp != null || _otp.length == 6)
                //     _verifyOTP(_otp, _verificationCode);
                //   else
                //     _showMessage("ERROR: INVALID OTP");
                // },
                onPressed: _otp != null && _otp != ""
                    ? () {
                        _verifyOTP(_otp, _verificationCode);
                      }
                    : null,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.all(0),
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  decoration: ShapeDecoration(
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text(
                    "Verify",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
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
        const Text("Resend OTP in ",
            style: TextStyle(fontSize: 16, color: Colors.blue)),
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

  _verifyPhone(String phone) async {
    print('INSIDE VERIFY PHONE');
    String _msg = "VERIFICATION INCOMPLETE";
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: "+91 " + _phone,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await FirebaseAuth.instance
                .signInWithCredential(credential)
                .then((value) async {
              if (value.user != null) {
                _msg = "VERIFICATION SUCCESSFUL " + value.user.uid;
                CubitProvider.of<UserCubit>(context).login(Credential(
                    _phone,
                    widget.userType,
                    _fcmToken,
                    Token(value.user.uid.toString())));
              }
            });
          },
          verificationFailed: (FirebaseAuthException e) {
            _msg = "VERIFICATION FAILED " + e.toString();
            _hideLoader();
            _showMessage(_msg);
          },
          codeSent: (String verificationID, int resendToken) {
            setState(() {
              _msg = "CODE SENT " + verificationID;
              _verificationCode = verificationID;
              CubitProvider.of<UserCubit>(context).verifyOTP();
            });
          },
          codeAutoRetrievalTimeout: (String verificationID) {},
          timeout: const Duration(seconds: 30));
    } catch (e) {
      _msg = "VERIFICATION FAILED " + e.toString();
      _hideLoader();
      _showMessage(_msg);
    }
  }

  _verifyOTP(String otp, String vid) async {
    String _msg = "OTP VERIFICATION INCOMPLETE";
    print('INSIDE VERIFY OTP');
    try {
      await FirebaseAuth.instance
          .signInWithCredential(
              PhoneAuthProvider.credential(verificationId: vid, smsCode: otp))
          .then((value) async {
        if (value.user != null) {
          _msg = "VERIFICATION SUCCESSFUL " + value.user.uid;
          CubitProvider.of<UserCubit>(context).login(Credential(_phone,
              widget.userType, _fcmToken, Token(value.user.uid.toString())));
        } else {
          _msg = "VERIFICATION FAILED. INVALID OTP.";
          _hideLoader();
          _showMessage(_msg);
        }
      });
    } catch (e) {
      _msg = "VERIFICATION FAILED " + e.toString();
      _hideLoader();
      _showMessage(_msg);
    }
  }
}
