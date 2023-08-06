import 'package:ccarev2_frontend/pages/profile/profile_page_adapter.dart';
import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

abstract class IAuthPageAdapter {
  void onAuthSuccess(BuildContext context, UserType userType);
  void onLoginSuccess(BuildContext context, UserType userType);
  void onLoginButtonPressed(BuildContext context);
}

class AuthPageAdapter extends IAuthPageAdapter {
  // final Widget Function(UserType userType)
  //     onUserAuthenticated; //UserService userService
  final ProfilePageAdapter profilePageAdapter;
  final Widget Function() authPage;

  AuthPageAdapter(this.profilePageAdapter, this.authPage);
  @override
  void onAuthSuccess(
    context,
    userType,
  ) {
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(builder: (context) => onUserAuthenticated(userType)),
    //     (Route<dynamic> route) => false);

    profilePageAdapter.onLoginSuccess(context, userType);
  }

  @override
  void onLoginSuccess(
    context,
    userType,
  ) {
    profilePageAdapter.onProfileCompletion(context, userType);
  }

  // @override
  void onLoginButtonPressed(context) {
    Get.offAll(() => authPage());
    // Navigator.push(context, MaterialPageRoute(builder: (context) => authPage(userType)));
  }
}
