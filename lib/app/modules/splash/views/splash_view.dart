import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../utils/constants.dart';
import '../controllers/splash_controller.dart';
import 'components/splash_content.dart';

class SplashView extends GetView<SplashController> {
  final List<Map<String, String>> splashData = [
    {
      "text": "Welcome to CardioCare,\n Let’s take care of your heart!",
      "image": "assets/images/sp1e.png"
    },
  ];

  SplashView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Padding(
              padding: EdgeInsets.only(top: 12, left: 6),
              child: Text('Are you sure?'),
            ),
            content: const Padding(
              padding: EdgeInsets.only(left: 6),
              child: Text('Do you want to exit an App'),
            ),
            actions: <Widget>[
              GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Text("NO"),
                ),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(true),
                child: const Padding(
                  padding: EdgeInsets.only(right: 12.0, bottom: 12),
                  child: Text("YES"),
                ),
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: SplashContent(
                    key: UniqueKey(),
                    image: splashData[0]["image"],
                    text: splashData[0]['text'],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Column(
                        children: <Widget>[
                          const Spacer(flex: 1),
                          Text(
                            "Let's get started",
                            style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: kPrimaryColor),
                          ),
                          SizedBox(height: 3.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _button(text: "Login", press: () {}),
                            ],
                          ),
                          const Spacer(),
                        ],
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _button({required String text, required Function? press}) => SizedBox(
        height: 10.h,
        child: TextButton(
          onPressed: () => press,
          child: Container(
            width: 60.w,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: kPrimaryColor,
            ),
            // background: kPrimaryColor,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
}
