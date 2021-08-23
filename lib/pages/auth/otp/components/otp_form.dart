//@dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:auth/auth.dart';
import '../../../../state_management/auth/auth_cubit.dart';
import '../../../../state_management/auth/auth_state.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/size_config.dart';

class OtpForm extends StatefulWidget {
  final AuthCubit authCubit;
  // final RegisterService registerService;
  final PhoneAuth phoneAuth;
  const OtpForm(this.authCubit, this.phoneAuth);

  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  List<String> otp = new List.filled(6, "?");
  FocusNode pin2FocusNode;
  FocusNode pin3FocusNode;
  FocusNode pin4FocusNode;
  FocusNode pin5FocusNode;
  FocusNode pin6FocusNode;
  FocusNode pin1FocusNode;

  @override
  void initState() {
    super.initState();
    pin1FocusNode = FocusNode();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
    pin5FocusNode = FocusNode();
    pin6FocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    pin2FocusNode.dispose();
    pin3FocusNode.dispose();
    pin4FocusNode.dispose();
    pin5FocusNode.dispose();
    pin6FocusNode.dispose();
    pin1FocusNode.dispose();
  }

  void nextField(
      String value, FocusNode rightfocusNode, FocusNode leftFocusNode) {
    if (value.length == 1) {
      rightfocusNode.requestFocus();
    } else
      leftFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return buildForm();
  }

  Form buildForm() {
    return Form(
      child: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.02),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: getProportionateScreenWidth(35),
                  child: TextFormField(
                    focusNode: pin1FocusNode,
                    maxLength: 1,
                    autofocus: true,
                    style: TextStyle(fontSize: 18, color: Colors.green),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: otpInputDecoration,
                    onChanged: (value) {
                      nextField(value, pin2FocusNode, pin1FocusNode);
                      otp[0] = value;
                    },
                  ),
                ),
                SizedBox(
                  width: getProportionateScreenWidth(35),
                  child: TextFormField(
                    maxLength: 1,
                    focusNode: pin2FocusNode,
                    style: TextStyle(fontSize: 18, color: Colors.green),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: otpInputDecoration,
                    onChanged: (value) {
                      otp[1] = value;
                      nextField(value, pin3FocusNode, pin1FocusNode);
                      // Then you need to check is the code is correct or not
                    },
                  ),
                ),
                SizedBox(
                  width: getProportionateScreenWidth(35),
                  child: TextFormField(
                    maxLength: 1,
                    focusNode: pin3FocusNode,
                    style: TextStyle(fontSize: 18, color: Colors.green),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: otpInputDecoration,
                    onChanged: (value) {
                      otp[2] = value;
                      nextField(value, pin4FocusNode, pin2FocusNode);
                      // Then you need to check is the code is correct or not
                    },
                  ),
                ),
                SizedBox(
                  width: getProportionateScreenWidth(35),
                  child: TextFormField(
                    maxLength: 1,
                    focusNode: pin4FocusNode,
                    style: TextStyle(fontSize: 18, color: Colors.green),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: otpInputDecoration,
                    onChanged: (value) {
                      otp[3] = value;
                      nextField(value, pin5FocusNode, pin3FocusNode);
                      // Then you need to check is the code is correct or not
                    },
                  ),
                ),
                SizedBox(
                  width: getProportionateScreenWidth(35),
                  child: TextFormField(
                    maxLength: 1,
                    focusNode: pin5FocusNode,
                    style: TextStyle(fontSize: 18, color: Colors.green),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: otpInputDecoration,
                    onChanged: (value) {
                      otp[4] = value;
                      nextField(value, pin6FocusNode, pin4FocusNode);
                    },
                  ),
                ),
                SizedBox(
                  width: getProportionateScreenWidth(35),
                  child: TextFormField(
                      maxLength: 1,
                      focusNode: pin6FocusNode,
                      style: TextStyle(fontSize: 18, color: Colors.green),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: otpInputDecoration,
                      onChanged: (value) {
                        otp[5] = value;
                        if (value.length == 1)
                          pin6FocusNode.unfocus();
                        else
                          pin5FocusNode.requestFocus();
                      }),
                ),
              ],
            ),
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.02),
          RaisedButton(
            onPressed: () {
              if (!otp.join().contains("?")) {
                this.widget.authCubit.verify(widget.phoneAuth, otp.join());
              }
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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
                "Continue",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
