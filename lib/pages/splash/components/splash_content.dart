//@dart=2.9
import 'package:flutter/material.dart';
import '../../../utils/size_config.dart';
import '../../../utils/constants.dart';
import 'package:sizer/sizer.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({
    Key key,
    this.text,
    this.image,
  }) : super(key: key);
  final String text, image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Spacer(),
        Text(
          "CardioCare",
          style: TextStyle(
            fontSize :24.sp,
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacer(flex: 1),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize :12.sp,
            
          ),
        ),
        Spacer(flex: 1),
        Image.asset(
          image,
          height: 45.h,
          width: 80.w,
        ),
      ],
    );
  }
}
