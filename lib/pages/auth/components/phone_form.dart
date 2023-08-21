import 'package:ccarev2_frontend/customBuilds/customtextformfield.dart';
import 'package:ccarev2_frontend/state_management/user/user_cubit.dart';
import 'package:ccarev2_frontend/utils/constants.dart';
import 'package:ccarev2_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

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
  // final _formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();

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
                    Container(
                      width: MediaQuery.of(context).size.width * 0.70,
                      child: TextFormField(
                        style: TextStyle(
                            backgroundColor: Colors.white,
                            color: kPrimaryColor),
                        obscureText: false,
                        keyboardType: TextInputType.number,
                        controller: phoneController,
                        decoration: InputDecoration(
                          hintText: "Mobile Number",
                        ),
                        onChanged: (value) {
                          setState(() {
                            phoneController.text == value;
                          });
                        },

                        textAlign: TextAlign.center,
                        maxLength: 10,
                        // validator: (phone) => phone.isEmpty
                        //     ? "Please enter a Phone Number"
                        //     : phone.length != 10
                        //         ? "Please enter a valid Phone Number"
                        //         : null, icon: Icon(Icons.phone), key: _formKey, initialValue: '', onSubmitted: (String value) {  }, textInputAction: TextInputAction.done,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.06),
                GestureDetector(
                  onTap: phoneController.text.length == 10
                      ? () async {
                          print('LOGIN BUTTON CLICKED');
                          FocusManager.instance.primaryFocus?.unfocus();

                          widget.phoneVerificationState(phoneController.text);
                          // widget.cubit.verifyPhone(phone);
                          // CubitProvider.of<UserCubit>(widget.context).verifyPhone(phone);
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
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
