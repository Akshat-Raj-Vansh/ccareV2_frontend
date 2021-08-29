import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../user/domain/credential.dart';
import '../../state_management/user/user_cubit.dart';
import '../../state_management/main/main_cubit.dart';

abstract class IHomePageAdapter {
  void loadHomeUI(BuildContext context, UserType userType);
  void onLogout(BuildContext context, UserCubit userCubit);
}

class HomePageAdapter extends IHomePageAdapter {
  final Widget Function() patientHomeScreen;
  final Widget Function() doctorHomeScreen;
  final Widget Function() driverHomeScreen;
  final Widget Function() splashScreen;

  HomePageAdapter(this.patientHomeScreen, this.doctorHomeScreen,
      this.driverHomeScreen, this.splashScreen);

  @override
  void loadHomeUI(BuildContext context, UserType userType) {
    if (userType == UserType.patient)
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => patientHomeScreen()),
          (Route<dynamic> route) => false);
    else if (userType == UserType.doctor)
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => doctorHomeScreen()),
          (Route<dynamic> route) => false);
    else
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => driverHomeScreen()),
          (Route<dynamic> route) => false);
  }

  @override
  void onLogout(BuildContext context, UserCubit userCubit) {
    userCubit.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => splashScreen()),
        (Route<dynamic> route) => false);
  }
}
