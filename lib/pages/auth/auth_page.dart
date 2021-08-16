import 'package:auth/auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import '../../models/users.dart';
import 'otp/otp_screen.dart';
import '../../customBuilds/customtextformfield.dart';
import 'auth_page_adapter.dart';
import '../../pages/auth/otp/components/otp_form.dart';
import '../../pages/profile/profile_update_screen.dart';
import '../../state_management/auth/auth_cubit.dart';
import '../../state_management/auth/auth_state.dart';
import '../../state_management/profile/profile_Cubit.dart';
import '../../state_management/profile/profile_State.dart' as profileState;

class AuthPage extends StatefulWidget {
  final AuthManger authManger;
  // final ISignUpService signUpService;
  final IRegisterService registerService;
  final IAuthPageAdapter pageAdatper;
  const AuthPage({
    required this.authManger,
    required this.registerService,
    required this.pageAdatper,
  });
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  String phone = "";
  late IAuthService service;
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
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: _showLogo(context),
              ),
              CubitConsumer<AuthCubit, AuthState>(
                builder: (_, state) {
                  return _buildUI(context);
                },
                listener: (context, state) {
                  if (state is LoadingState) {
                    print("LoadingStateCalled");
                    _showLoader();
                  } else if (state is AuthSuccessState) {
                    _hideLoader();
                    widget.pageAdatper.onAuthSuccess(context, service);
                    print(state.details.toString());
                  } else if (state is SignUpSuccessState) {
                    _hideLoader();
                    var cubit = CubitProvider.of<ProfileCubit>(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileUpdateScreen(cubit)));
                    print(state.details.toString());
                  } else if (state is OTPState) {
                    _hideLoader();
                    print("otpstate");
                    var cubit = CubitProvider.of<AuthCubit>(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OtpScreen(cubit, phone,
                                widget.authManger.service(AuthType.phone))));
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
              CubitListener<ProfileCubit, profileState.ProfileState>(
                child: Container(),
                listener: (context, state) {
                  if (state is profileState.LoadingState) {
                    print("LoadingStateCalled");
                    _showLoader();
                  } else if (state is profileState.ProfileUpdateState) {
                    widget.pageAdatper.onAuthSuccess(
                        context, widget.authManger.service(AuthType.phone));
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
    print("Loader Called");
    var alert = AlertDialog(
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

  _showLogo(BuildContext context) => Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Image(
                image: AssetImage("assets/logo.png"),
                width: 300,
                height: 280,
                fit: BoxFit.fill),
            SizedBox(height: 40),
          ],
        ),
      );

  _buildUI(BuildContext context) => Expanded(
        child: PageView(
          controller: _controller,
          physics: NeverScrollableScrollPhysics(),
          children: [Text('Hello')],
        ),
      );
}
