//@dart=2.9
import 'package:ccarev2_frontend/components/rounded_image_btn.dart';
import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:ccarev2_frontend/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:location/location.dart';
import 'package:sizer/sizer.dart';
// This is the best practice
import '../components/splash_content.dart';
import '../../../components/default_button.dart';

import '../../auth/auth_page_adapter.dart';
import '../../../utils/size_config.dart';

class Body extends StatefulWidget {
  final IAuthPageAdapter pageAdapter;

  const Body(this.pageAdapter);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentPage = 0;
  PageController controller = PageController();
  Location location = Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  List<Map<String, String>> splashData = [
    {
      "text": "Welcome to CardioCare,\n Let’s take care of your heart!",
      "image": "assets/images/sp1e.png"
    },
  ];

  @override
  void initState() {
    super.initState();
    _getLocationPermission();
  }

  _getLocationPermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: SplashContent(
                image: splashData[0]["image"],
                text: splashData[0]['text'],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal:5.w),
                child: Column(
                  children: <Widget>[
                    const Spacer(flex: 1),
                    Text(
                      "I'm a",
                      style: TextStyle(
                          fontSize :18.sp,
                          fontWeight: FontWeight.w700,
                          color: kPrimaryColor),
                    ),
                    SizedBox(height: 3.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _button(
                          text: "Patient",
                          press: () => widget.pageAdapter
                              .onSplashScreenComplete(
                                  context, UserType.PATIENT),
                        ),
                        _button(
                            text: "Doctor",
                            press: () async {
                              await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text(
                                        'Doctor Type',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize :16.sp,
                                        ),
                                      ),
                                      content:  Text(
                                        'Choose the type of doctor-',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize :12.sp,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => widget.pageAdapter
                                              .onSplashScreenComplete(
                                                  context, UserType.SPOKE),
                                          child: Text(
                                            'SPOKE',
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () => widget.pageAdapter
                                              .onSplashScreenComplete(
                                                  context, UserType.HUB),
                                          child: Text(
                                            'HUB',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ) ??
                                  false;
                              // widget.pageAdapter.onSplashScreenComplete(
                              //     context, UserType.DOCTOR);
                            }),
                        _button(
                          text: "Driver",
                          press: () => widget.pageAdapter
                              .onSplashScreenComplete(context, UserType.DRIVER),
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _button({String text, Function press}) => SizedBox(
        width: 25.w,
        height:5.h,
        child: FlatButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: kPrimaryColor,
          onPressed: press,
          child: Text(
            text,
            style: TextStyle(
              fontSize :12.sp,
              color: Colors.white,
            ),
          ),
        ),
      );
}
