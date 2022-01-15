//@dart=2.9
import '../utils/constants.dart';
import '../utils/size_config.dart';
import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key key,
    this.text,
    this.press,
  }) : super(key: key);
  final String text;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width : 40.w,
      height: getProportionateScreenHeight(42),
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: kButtonColor,
        onPressed: press,
        child: Text(
          text,
          style: TextStyle(
            fontSize:12.sp,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
