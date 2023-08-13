import 'package:ccarev2_frontend/state_management/user/user_cubit.dart';
import 'package:ccarev2_frontend/utils/constants.dart';
import 'package:ccarev2_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:pinput/pinput.dart';

class OTPForm extends StatefulWidget {
  final PageController controller;
  final UserCubit cubit;
  final Function verifyOTP;
  final String phone;
  const OTPForm(this.controller, this.cubit, this.verifyOTP, this.phone);

  @override
  _OTPFormState createState() => _OTPFormState();
}

class _OTPFormState extends State<OTPForm> with TickerProviderStateMixin {
  late AnimationController animationController;
  // final _formKey = GlobalKey<FormState>();
  final otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: const Duration(minutes: 1));
    animationController.reverse(
        from: animationController.value == 0 ? 1.0 : animationController.value);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.h,
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
                    onPressed: () => widget.controller.previousPage(
                        duration: const Duration(microseconds: 1000),
                        curve: Curves.elasticIn),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Enter OTP',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 5.h),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.80,
                      child: Pinput(
                       
                          controller: otpController,
                        length: 6,
                        showCursor: true,
                      )),
                  buildTimer(),
                ],
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.02),
              Text(
                "We sent your code to - ${widget.phone}",
                style: TextStyle(color: Colors.green, fontSize: 12.sp),
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.02),
              GestureDetector(
                onTap: () {
                  if (animationController.value == 0) {
                    animationController.reverse(from: 1);
                    widget.cubit.verifyPhone(widget.phone);
                  }
                },
                child: Text(
                  "Resend OTP Code",
                  style: TextStyle(
                      color: Colors.green,
                      decoration: TextDecoration.underline),
                ),
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.02),
              GestureDetector(
                onTap: otpController.text.length == 6
                    ? () async {
                        //print('LOGIN BUTTON CLICKED');
                        FocusManager.instance.primaryFocus?.unfocus();
                        // if (_formKey.currentState!.validate()) {
                        //   widget.verifyOTP(_otp);
                        // }
                        print("===== OTP BUTTON =====");
                        await widget.verifyOTP(otpController.text);
                      }
                    : null,
                // shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(30)),
                // padding: const EdgeInsets.all(0),
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  decoration: ShapeDecoration(
                    color: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text(
                    "Verify",
                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get timeString {
    Duration duration =
        animationController.duration! * animationController.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  Row buildTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Resend OTP in ",
            style: TextStyle(fontSize: 12.sp, color: kPrimaryColor)),
        AnimatedBuilder(
          animation: animationController,
          builder: (_, child) {
            return Text(timeString,
                style: TextStyle(
                    fontSize: 12.sp,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold));
          },
        )
      ],
    );
  }
}
