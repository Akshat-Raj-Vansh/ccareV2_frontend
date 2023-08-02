import '../utils/constants.dart';
import '../utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key? key,
    required this.text,
    required this.press,
  }) : super(key: key);
  final String text;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: 40.w,
      height: getProportionateScreenHeight(42),
      child: TextButton(
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        // color: kButtonColor,
        onPressed: () {}, //There was a press function here
        child: Container(
          width: 40.w,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: kButtonColor,
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
