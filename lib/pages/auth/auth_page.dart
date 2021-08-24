import '../../customBuilds/customtextformfield.dart';
import '../../state_management/profile/profile_cubit.dart';
import '../../state_management/profile/profile_state.dart' as profileState;
import '../../state_management/user/user_state.dart';
import '../../user/domain/credential.dart';
import '../../user/domain/token.dart';
import '../../user/domain/user_service_contract.dart';
import '../../pages/auth/otp/otp_screen.dart';
import '../../user/infra/user_api.dart';
import '../../state_management/user/user_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_page_adapter.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import '../../utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class AuthPage extends StatefulWidget {
  final UserAPI userAPI;
  final IAuthPageAdapter pageAdatper;
  final UserType userType;
  const AuthPage({
    required this.userAPI,
    required this.pageAdatper,
    required this.userType,
  });
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  String phone = "";
  String _verificationCode = "";
  late UserService service;
  int hex(String color) {
    return int.parse("FF" + color.toUpperCase(), radix: 16);
  }

  PageController _controller = PageController();

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    return _buildUI(context, cubit, widget.userAPI);
                  },
                  listener: (context, state) {
                    if (state is LoadingState) {
                      print("LoadingStateCalled");
                      _showLoader();
                    } else if (state is LoginSuccessState) {
                      _hideLoader();
                      widget.pageAdatper.onAuthSuccess(context);
                      print(state.details.toString());
                    } else if (state is LoginSuccessState) {
                      _hideLoader();
                      // var cubit = CubitProvider.of<ProfileCubit>(context);
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) =>
                      //             ProfileUpdateScreen(cubit)));
                      print(state.details.toString());
                    } else if (state is OTPState) {
                      _hideLoader();
                      print("otpstate");
                      var cubit = CubitProvider.of<UserCubit>(context);
                      _controller.nextPage(
                          duration: const Duration(microseconds: 1000),
                          curve: Curves.elasticIn);
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) =>
                      //             OtpScreen(cubit, phone, widget.phoneAuth)));
                    } else {
                      _hideLoader();
                      if (state is ErrorState) {
                        print("ErrorState");
                        print(state.error);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Theme.of(context).accentColor,
                          content: Text(
                            state.error,
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(color: Colors.white, fontSize: 16),
                          ),
                        ));
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
                  } else if (state is profileState.ProfileUpdateState) {
                    widget.pageAdatper.onAuthSuccess(context);
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
                              .caption!
                              .copyWith(color: Colors.white, fontSize: 16),
                        ),
                      ));
                    }
                  }
                },
              )
            ],
          ),
        )));
  }

  _showLoader() {
    // print("Loader Called");
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

  _buildUI(BuildContext context, UserCubit cubit, UserAPI userAPI) => Container(
        height: 400,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: PageView(
          controller: _controller,
          physics: NeverScrollableScrollPhysics(),
          children: [_phoneForm(context), _otpForm(context, cubit, userAPI)],
          // _otpForm(context, cubit, userAPI)
        ),
      );

  _phoneForm(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Form(
          key: _formkey,
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Positioned(
                top: 40,
                child: Text(
                  'Enter Mobile Number',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Positioned(
                top: 100,
                child: CustomTextFormField(
                    hint: "Mobile Number",
                    obscureText: false,
                    keyboardType: TextInputType.text,
                    color: Colors.blue,
                    // icon: const Icon(
                    //   Icons.phone,
                    //   color: Colors.blue,
                    // ),
                    width: MediaQuery.of(context).size.width / 1.5,
                    backgroundColor: Colors.white,
                    onChanged: (value) {
                      phone = value;
                    },
                    validator: (phone) =>
                        phone.isEmpty ? "Please enter a Phone Number" : null),
              ),
              // const SizedBox(height: 80),
              Positioned(
                bottom: 40,
                child: RaisedButton(
                  onPressed: () async {
                    if (_formkey.currentState!.validate()) {
                      // final user = User(name: "ABCD", phone: phone);
                      Credential credential = Credential(
                          phone, widget.userType, "fcmtoken", Token("token"));
                      // CubitProvider.of<UserCubit>(context).login(credential);
                      _controller.nextPage(
                          duration: const Duration(microseconds: 1000),
                          curve: Curves.elasticIn);
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
              ),
            ],
          ),
        ),
      );

  _otpForm(BuildContext context, UserCubit cubit, UserService userService) {
    Credential credential =
        Credential(phone, widget.userType, "fcmtoken", Token("token"));
    return Center(
      child: RaisedButton(
        onPressed: () {
          _controller.previousPage(
              duration: Duration(microseconds: 1000), curve: Curves.elasticIn);
        },
        child: OtpScreen(cubit, credential, widget.userAPI),
      ),
    );
  }
}
