import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../pages/home/components/driver.dart';
import '../../pages/home/components/doctor.dart';
import '../../pages/home/components/patient.dart';
import '../../user/domain/credential.dart';
import '../../state_management/user/user_cubit.dart';
import '../../state_management/main/main_cubit.dart';

abstract class IHomePageAdapter {
  Widget onLoginSuccess(BuildContext context);
  Drawer getSideNav(BuildContext context);
  void onLogout(BuildContext context);
}

class HomePageAdapter extends IHomePageAdapter {
  final UserType userType;
  final MainCubit mainCubit;
  final UserCubit userCubit;
  final Widget Function() splashScreen;

  HomePageAdapter(
      this.userType, this.mainCubit, this.userCubit, this.splashScreen);

  Widget getScreen() {
    switch (userType) {
      case UserType.patient:
        return PatientSide(mainCubit);
      case UserType.doctor:
        return DoctorSide(mainCubit);
      default:
        return DriverSide(mainCubit);
    }
  }

  @override
  Widget onLoginSuccess(BuildContext context) {
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(builder: (context) => getScreen()),
    //     (Route<dynamic> route) => false);
    return getScreen();
  }

  @override
  Drawer getSideNav(BuildContext context) {
    return Drawer();
  }

  @override
  void onLogout(BuildContext context) {
    userCubit.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => splashScreen()),
        (Route<dynamic> route) => false);
  }
}
