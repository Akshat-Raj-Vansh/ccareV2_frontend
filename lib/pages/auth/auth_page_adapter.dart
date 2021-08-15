import 'package:auth/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class IAuthPageAdapter {
  void onAuthSuccess(BuildContext context, IAuthService authService);
  void onSplashScreenComplete(BuildContext context);
}

class AuthPageAdapter extends IAuthPageAdapter {
  final Widget Function(IAuthService authService) onUserAuthenticated;
  final Widget Function() authPage;

  AuthPageAdapter(this.onUserAuthenticated,this.authPage);
  @override
  void onAuthSuccess(BuildContext context, IAuthService authService) {
   
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => this.onUserAuthenticated(authService)),
        (Route<dynamic> route) => false);
  }

  @override
  void onSplashScreenComplete(BuildContext context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => this.authPage()),
        (Route<dynamic> route) => false);
  }
}
