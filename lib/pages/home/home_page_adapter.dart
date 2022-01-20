import 'package:ccarev2_frontend/user/domain/details.dart';
import 'package:ccarev2_frontend/user/domain/location.dart';
import 'package:ccarev2_frontend/user/domain/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../user/domain/credential.dart';
import '../../state_management/user/user_cubit.dart';
import '../../state_management/main/main_cubit.dart';

abstract class IHomePageAdapter {
  void loadHomeUI(BuildContext context, UserType userType);
  void onLogout(BuildContext context, UserCubit userCubit);
  void loadEmergencyScreen(
      BuildContext context, UserType userType, Location location);
}

class HomePageAdapter extends IHomePageAdapter {
  final Widget Function() patientHomeScreen;
  final Widget Function() doctorSpokeHomeScreen;
  final Widget Function() doctorHubHomeScreen;
  final Widget Function() driverHomeScreen;
  final Widget Function(UserType userType, Location location) emergencyScreen;
  final Widget Function() splashScreen;

  HomePageAdapter(
      this.patientHomeScreen,
      this.doctorSpokeHomeScreen,
      this.doctorHubHomeScreen,
      this.driverHomeScreen,
      this.emergencyScreen,
      this.splashScreen);



  @override
  void loadHomeUI(BuildContext context, UserType userType) {
    //print('HOME PAGE ADAPTER/LOAD HOME UI');
    //print('USERTYPE:');
    //print(userType.toString());
    if (userType == UserType.PATIENT)
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => patientHomeScreen()),
          (Route<dynamic> route) => false);
    else if (userType == UserType.SPOKE) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => doctorSpokeHomeScreen()),
          (Route<dynamic> route) => false);
    } else if (userType == UserType.HUB)
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => doctorHubHomeScreen()),
          (Route<dynamic> route) => false);
    else
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => driverHomeScreen()),
          (Route<dynamic> route) => false);
  }

  @override
  void loadEmergencyScreen(
      BuildContext context, UserType userType, Location location) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => emergencyScreen(userType, location)),
    );
  }

  @override
  void onLogout(BuildContext context, UserCubit userCubit) {
    userCubit.signOut();
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(builder: (context) => splashScreen()),
    //     (Route<dynamic> route) => false);
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  
}
