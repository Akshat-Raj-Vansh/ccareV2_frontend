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
  final IAuthPageAdapter pageAdatper;
  const AuthPage({
    required this.authManger,
    // required this.signUpService,
    required this.pageAdatper,
  });
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  String email = "";

  String password = "";

  String name = "";
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
                    // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> ProfileUpdateScreen()) ,(route) => false);
                    widget.pageAdatper.onAuthSuccess(context, service);
                    print(state.details.toString());
                  } else if (state is SignUpSuccessState) {
                    _hideLoader();
                    var cubit = CubitProvider.of<ProfileCubit>(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileUpdateScreen(cubit)));
                    //widget.pageAdatper.onAuthSuccess(context, service);
                    print(state.details.toString());
                  } else if (state is OTPState) {
                    _hideLoader();
                    print("otpstate");
                    var cubit = CubitProvider.of<AuthCubit>(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OtpScreen(
                                cubit, email, widget.authManger.service())));
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
                    widget.pageAdatper
                        .onAuthSuccess(context, widget.authManger.service());
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
          children: [_signIn(context), _signUp(context)],
        ),
      );

  _signIn(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formkey,
          child: Column(children: [
            ..._emailandpassword(context),
            SizedBox(height: 10),
            Align(
                alignment: Alignment.centerRight,
                child: FlatButton(
                    onPressed: () {},
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.blue),
                    ))),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              onPressed: () async {
                setState(() {
                  service = widget.authManger.service();
                });
                (service as EmailAuth)
                    .credential(email: email, password: password);
                if (_formkey.currentState!.validate()) {
                  CubitProvider.of<AuthCubit>(context).signin(service);
                }
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.all(0),
              child: Container(
                width: MediaQuery.of(context).size.width / 1.5,
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 8, bottom: 8),
                decoration: ShapeDecoration(
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text("-or-", style: TextStyle(color: Colors.blue, fontSize: 16)),
            SizedBox(height: 20),
            IconButton(
                icon: Image.asset("assets/Google_logo.png"),
                onPressed: () {
                  try {
                    setState(() {
                      service = widget.authManger.service(AuthType.google);
                    });

                    print("inside");
                    CubitProvider.of<AuthCubit>(context)
                        .signin(service, AuthType.google);
                  } catch (error) {
                    print(error);
                  }
                }),
            SizedBox(
              height: 10,
            ),
            RichText(
                text: TextSpan(
                    text: "Don't have a account?",
                    style: Theme.of(context).textTheme.caption!.copyWith(
                        color: Colors.lightGreen[500],
                        fontWeight: FontWeight.normal,
                        fontSize: 18),
                    children: [
                  TextSpan(
                      text: " Sign Up",
                      style: TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          _controller.nextPage(
                              duration: Duration(microseconds: 1000),
                              curve: Curves.elasticIn);
                        })
                ]))
          ]),
        ),
      );

  _signUp(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formkey,
          child: Column(children: [
            CustomTextFormField(
                hint: "Enter Username",
                obscureText: false,
                keyboardType: TextInputType.text,
                color: Colors.white,
                icon: Icon(
                  Icons.supervised_user_circle,
                  color: Colors.white,
                ),
                width: MediaQuery.of(context).size.width / 1.5,
                backgroundColor: Colors.blue,
                onChanged: (value) {
                  name = value;
                },
                validator: (name) =>
                    name.isEmpty ? "Please enter a username" : null),
            SizedBox(height: 20),
            ..._emailandpassword(context),
            SizedBox(height: 20),
            // Align(
            //     alignment: Alignment.centerRight,
            //     child: TextButton(
            //         onPressed: () {},
            //         child: Text(
            //           "Forgot Password?",
            //           style: TextStyle(color: Theme.of(context).accentColor),
            //         ))),
            // SizedBox(
            //   height: 10,
            // ),
            RaisedButton(
              onPressed: () async {
                if (_formkey.currentState!.validate()) {
                  final user =
                      User(email: email, password: password, name: name);
                  CubitProvider.of<AuthCubit>(context)
                      .signup(widget.signUpService, user);
                }
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.all(0),
              child: Container(
                width: MediaQuery.of(context).size.width / 1.5,
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 8, bottom: 8),
                decoration: ShapeDecoration(
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: Text(
                  "Sign Up",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text("-or-", style: TextStyle(color: Colors.blue, fontSize: 16)),
            SizedBox(height: 20),
            IconButton(
                icon: Image.asset("assets/Google_logo.png"),
                onPressed: () {
                  try {
                    service = widget.authManger.service(AuthType.google);
                    print("inside");
                    CubitProvider.of<AuthCubit>(context)
                        .signin(service, AuthType.google);
                  } catch (error) {
                    print(error);
                  }
                }),
            SizedBox(
              height: 20,
            ),
            RichText(
                text: TextSpan(
                    text: "Already  have an account?",
                    style: Theme.of(context).textTheme.caption!.copyWith(
                        color: Colors.lightGreen[500],
                        fontWeight: FontWeight.normal,
                        fontSize: 18),
                    children: [
                  TextSpan(
                      text: " Sign In",
                      style: TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          _controller.previousPage(
                              duration: Duration(microseconds: 1000),
                              curve: Curves.elasticIn);
                        })
                ]))
          ]),
        ),
      );

  List<Widget> _emailandpassword(BuildContext context) => [
        CustomTextFormField(
            hint: "Enter Email",
            obscureText: false,
            keyboardType: TextInputType.emailAddress,
            color: Colors.white,
            icon: Icon(Icons.email, color: Colors.white),
            width: MediaQuery.of(context).size.width / 1.5,
            backgroundColor: Colors.blue,
            onChanged: (value) {
              email = value;
            },
            validator: (email) =>
                email.isEmpty ? "Please Enter an Email" : null),
        SizedBox(height: 20),
        CustomTextFormField(
            hint: "Enter Password",
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            color: Colors.white,
            icon: Icon(Icons.lock, color: Colors.white),
            width: MediaQuery.of(context).size.width / 1.5,
            backgroundColor: Colors.blue,
            onChanged: (value) {
              password = value;
            },
            validator: (password) => password.length < 6
                ? "Please enter a password\n of length > 6"
                : null),
      ];
}
