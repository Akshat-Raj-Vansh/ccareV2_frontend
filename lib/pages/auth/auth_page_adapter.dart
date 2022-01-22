import 'package:ccarev2_frontend/pages/profile/profile_page_adapter.dart';
import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:ccarev2_frontend/user/domain/details.dart';
import 'package:ccarev2_frontend/user/domain/user_service_contract.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class IAuthPageAdapter {
  void onAuthSuccess(BuildContext context, UserType userType);
  void onLoginSuccess(BuildContext context, UserType userType);
  void onSplashScreenComplete(BuildContext context, UserType userType);
}

class AuthPageAdapter extends IAuthPageAdapter {
  // final Widget Function(UserType userType)
  //     onUserAuthenticated; //UserService userService
  final ProfilePageAdapter profilePageAdapter;
  final Widget Function(UserType userType) authPage;

  AuthPageAdapter(this.profilePageAdapter, this.authPage);
  @override
  void onAuthSuccess(
    BuildContext context,
    UserType userType,
  ) {
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(builder: (context) => onUserAuthenticated(userType)),
    //     (Route<dynamic> route) => false);

    profilePageAdapter.onLoginSuccess(context, userType);
  }

  @override
  void onLoginSuccess(
    BuildContext context,
    UserType userType,
  ) {
    profilePageAdapter.onProfileCompletion(context, userType);
  }

  @override
  void onSplashScreenComplete(BuildContext context, UserType userType) {
    //print('AUTH PAGE ADAPTER/ON SPLASH SCREEN COMPLETE');
    //print("USERTYPE:");
    //print(userType);
    print(context);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => authPage(userType)),
        (Route<dynamic> route) => false);
    // Navigator.push(context, MaterialPageRoute(builder: (context) => authPage(userType)));
  }
}
