import '../utils/constants.dart';
import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';
class NoAccountText extends StatelessWidget {
  const NoAccountText({
    required Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don’t have an account? ",
          style: TextStyle(fontSize: 12.sp),
        ),
        GestureDetector(
          onTap: () => {},
          child: Text(
            "Sign Up",
            style: TextStyle(
                fontSize: 12.sp,
                color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
}
