//@dart=2.9
import 'package:flutter/material.dart';
import '../../../utils/size_config.dart';

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
            fontSize: getProportionateScreenWidth(36),
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacer(flex: 1),
        Text(
          text,
          textAlign: TextAlign.center,
        ),
        Spacer(flex: 1),
        Image.asset(
          image,
          height: getProportionateScreenHeight(400),
          width: getProportionateScreenWidth(285),
        ),
      ],
    );
  }
}
