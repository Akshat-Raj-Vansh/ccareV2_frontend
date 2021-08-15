import 'package:flutter/material.dart';

bottomLoader() => Container(
      alignment: Alignment.center,
      child: Center(
          child: SizedBox(
        child: CircularProgressIndicator(
          strokeWidth: 1.5,
        ),
        width: 30,
        height: 30,
      )));