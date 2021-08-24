import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:ccarev2_frontend/user/domain/user_service_contract.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class IAuthPageAdapter {
  void onAuthSuccess(
      BuildContext context, UserType userType); //, UserService userService
  void onSplashScreenComplete(BuildContext context, UserType userType);
}

class AuthPageAdapter extends IAuthPageAdapter {
  final Widget Function(UserType userType)
      onUserAuthenticated; //UserService userService
  final Widget Function(UserType userType) authPage;

  AuthPageAdapter(this.onUserAuthenticated, this.authPage);
  @override
  void onAuthSuccess(
    BuildContext context,
    UserType userType,
  ) {
    //     UserService userService) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>
                onUserAuthenticated(userType)), //     userService)),
        (Route<dynamic> route) => false);
  }

  @override
  void onSplashScreenComplete(BuildContext context, UserType userType) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => authPage(userType)),
        (Route<dynamic> route) => false);
  }
}
