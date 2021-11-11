import 'package:ccarev2_frontend/pages/profile/profile_page_adapter.dart';
import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:ccarev2_frontend/user/domain/details.dart';
import 'package:ccarev2_frontend/user/domain/user_service_contract.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class IAuthPageAdapter {
  void onAuthSuccess(BuildContext context, Details details);
  void onLoginSuccess(BuildContext context, Details details);
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
    Details details,
  ) {
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(builder: (context) => onUserAuthenticated(userType)),
    //     (Route<dynamic> route) => false);

    profilePageAdapter.onLoginSuccess(context, details);
  }

  @override
  void onLoginSuccess(
    BuildContext context,
    Details details,
  ) {
    profilePageAdapter.onProfileCompletion(context, details);
  }

  @override
  void onSplashScreenComplete(BuildContext context, UserType userType) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => authPage(userType)),
        (Route<dynamic> route) => false);
  }
}
