import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
bottomLoader() => Container(
      alignment: Alignment.center,
      child: Center(
          child: SizedBox(
        child: CircularProgressIndicator(
          strokeWidth: 1.5,
        ),
        width : 8.w,
        height : 5.h,
      )));