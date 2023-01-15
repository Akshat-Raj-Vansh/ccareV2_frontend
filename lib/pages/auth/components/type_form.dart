//@dart=2.9
import 'package:ccarev2_frontend/customBuilds/customtextformfield.dart';
import 'package:ccarev2_frontend/state_management/user/user_cubit.dart';
import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:ccarev2_frontend/utils/constants.dart';
import 'package:ccarev2_frontend/utils/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:flutter_cubit/flutter_cubit.dart';

class TypeForm extends StatefulWidget {
  final Function launchPhoneForm;
  final Function backPressed;
  // final BuildContext context;
  const TypeForm(this.launchPhoneForm, this.backPressed);

  @override
  _TypeFormState createState() => _TypeFormState();
}

class _TypeFormState extends State<TypeForm> {
  UserType userType = UserType.PATIENT;
  List<UserType> userTypes = [
    UserType.PATIENT,
    UserType.SPOKE,
    UserType.HUB,
    //  UserType.DRIVER
  ];
  @override
  void initState() {
    print('INSIDE TYPE FORM');
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
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      widget.backPressed(context);
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'I am a ',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Text(
                '(Choose from the following)',
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontSize: 12.sp, fontWeight: FontWeight.normal),
              ),
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40.w,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: kPrimaryColor,
                        width: 1,
                      ),
                    ),
                    child: DropdownButton<UserType>(
                      value: userType,
                      isDense: false,
                      onChanged: (UserType newValue) {
                        setState(() {
                          userType = newValue;
                        });
                      },
                      items: userTypes.map((UserType value) {
                        return DropdownMenuItem<UserType>(
                          value: value,
                          child: Text(
                            value.toString().split('.')[1],
                            textAlign: TextAlign.center,
                            style: TextStyle(color: kPrimaryColor),
                          ),
                          alignment: AlignmentDirectional.center,
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.06),
              GestureDetector(
                onTap: () async {
                  //widget.cubit.verifyPhone(_phone);
                  // CubitProvider.of<UserCubit>(widget.context).verifyPhone(_phone);
                  print(userType);
                  widget.launchPhoneForm(userType);
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
                    "Next",
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
}
