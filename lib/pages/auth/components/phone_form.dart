import 'package:ccarev2_frontend/customBuilds/customtextformfield.dart';
import 'package:ccarev2_frontend/state_management/user/user_cubit.dart';
import 'package:ccarev2_frontend/utils/constants.dart';
import 'package:ccarev2_frontend/utils/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:flutter_cubit/flutter_cubit.dart';

import '../../../utils/loaders.dart';

class PhoneForm extends StatefulWidget {
  final PageController controller;
  final UserCubit cubit;
  final Function verifyPhone;
  final Function phoneVerificationState;
  final Function backPressed;
  // final BuildContext context;
  const PhoneForm(this.controller, this.cubit, this.verifyPhone,
      this.phoneVerificationState, this.backPressed);

  @override
  phoneFormState createState() => phoneFormState();
}

class phoneFormState extends State<PhoneForm> {
  final _formKey = GlobalKey<FormState>();
  String phone = "";

  @override
  void initState() {
    print('INSIDE PHONE FORM');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.context);
    return Container(
      height: 45.h,
      color: Colors.white,
      width: double.infinity,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
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
                      'Enter Mobile Number',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      '+91',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 14.sp,
                      ),
                    ),
                    CustomTextFormField(
                        hint: "Mobile Number",
                        obscureText: false,
                        keyboardType: TextInputType.number,
                        color: kPrimaryColor,
                        width: MediaQuery.of(context).size.width * 0.70,
                        backgroundColor: Colors.white,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          if (value.length > 10)
                            _formKey.currentState!.validate();
                          phone = value;
                        },
                        validator: (phone) => phone.isEmpty
                            ? "Please enter a Phone Number"
                            : phone.length != 10
                                ? "Please enter a valid Phone Number"
                                : null),
                  ],
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.06),
                GestureDetector(
                  onTap: () async {
                    print('LOGIN BUTTON CLICKED');
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (_formKey.currentState!.validate()) {
                      print('NOT COMING INSIDE');
                      widget.phoneVerificationState(phone);
                      // widget.cubit.verifyPhone(phone);
                      // CubitProvider.of<UserCubit>(widget.context).verifyPhone(phone);
                    }
                  },
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
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
