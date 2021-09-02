//@dart=2.9
import 'package:ccarev2_frontend/components/rounded_image_btn.dart';
import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:location/location.dart';

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
      "image": "assets/images/sp1.png"
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
                    horizontal: getProportionateScreenWidth(20)),
                child: Column(
                  children: <Widget>[
                    const Spacer(flex: 1),
                    const Text(
                      "I'm a",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _button(
                          text: "Patient",
                          press: () => widget.pageAdapter
                              .onSplashScreenComplete(
                                  context, UserType.patient),
                        ),
                        _button(
                          text: "Doctor",
                          press: () => widget.pageAdapter
                              .onSplashScreenComplete(context, UserType.doctor),
                        ),
                        _button(
                          text: "Driver",
                          press: () => widget.pageAdapter
                              .onSplashScreenComplete(context, UserType.driver),
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
        width: getProportionateScreenWidth(90),
        height: getProportionateScreenHeight(42),
        child: FlatButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Colors.blue,
          onPressed: press,
          child: Text(
            text,
            style: TextStyle(
              fontSize: getProportionateScreenWidth(16),
              color: Colors.white,
            ),
          ),
        ),
      );
}
