import 'package:auth/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class ITabPageAdatper {
  void logout(BuildContext context);
}

class TabPageAdapter extends ITabPageAdatper {
  
  final Widget Function() onUserSignsOut;

  TabPageAdapter(this.onUserSignsOut);
  @override
  void logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => this.onUserSignsOut()),
        (Route<dynamic> route) => false);
  }
}
