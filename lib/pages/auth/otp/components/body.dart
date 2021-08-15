//@dart=2.9
import 'package:auth/auth.dart';
import '../../../../state_management/auth/auth_cubit.dart';
import '../../../../state_management/auth/auth_state.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';

import 'otp_form.dart';

class Body extends StatefulWidget {
  final AuthCubit cubit;
  final String email;
  final IAuthService authService;
  Body(
    this.cubit,
    this.email,
    this.authService,
  );

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with TickerProviderStateMixin {
  AnimationController animationController;

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
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.05),
              _showLogo(context),
              Text(
                "OTP Verification",
                style: headingStyle,
              ),
              Text(
                "We sent your code to - ",
                style: TextStyle(color: Colors.green, fontSize: 16),
              ),
              Text(
                "${this.widget.email}",
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              buildTimer(),
              OtpForm(this.widget.cubit, this.widget.authService),
              SizedBox(height: SizeConfig.screenHeight * 0.03),
              GestureDetector(
                onTap: () {
                  animationController.reverse(
                      from: animationController.value == 0
                          ? 1.0
                          : animationController.value);
                  this.widget.cubit.resend(this.widget.authService);
                },
                child: Text(
                  "Resend OTP Code",
                  style: TextStyle(
                      color: Colors.green,
                      decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _showLogo(BuildContext context) => Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Image(
                image: AssetImage("assets/logo.png"),
                width: 250,
                height: 230,
                fit: BoxFit.fill),
            // RichText(
            //   text: TextSpan(
            //       text: "Cardio",
            //       style: Theme.of(context).textTheme.caption!.copyWith(
            //           color: Colors.lightGreen[500],
            //           fontSize: 32.0,
            //           fontWeight: FontWeight.bold),
            //       children: [
            //         TextSpan(
            //           text: " Care",
            //           style: TextStyle(color: Theme.of(context).accentColor),
            //         )
            //       ]),
            // ),
            SizedBox(height: 30)
          ],
        ),
      );
  Row buildTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("This code will expired in ",
            style: TextStyle(fontSize: 16, color: Colors.green)),
        AnimatedBuilder(
          animation: animationController,
          builder: (_, child) {
            return Text(timeString,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold));
          },
        )
      ],
    );
  }
}
