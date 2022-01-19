import 'package:ccarev2_frontend/pages/home/home_page_adapter.dart';
import 'package:ccarev2_frontend/pages/profile/components/doctor.dart';
import 'package:ccarev2_frontend/pages/profile/components/driver.dart';
import 'package:ccarev2_frontend/pages/profile/components/patient.dart';
import 'package:ccarev2_frontend/services/Notifications/notificationContoller.dart';
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/state_management/profile/profile_cubit.dart';
import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:ccarev2_frontend/user/domain/details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class IProfilePageAdapter {
  void onProfileCompletion(BuildContext context, UserType userType);
  Widget loadProfiles(
      BuildContext context, UserType userType, ProfileCubit cubit);
  void onLoginSuccess(BuildContext context, UserType userType);
}

class ProfilePageAdapter extends IProfilePageAdapter {
  final HomePageAdapter homePageAdapter;
  final Widget Function(UserType userType) profilePage;

  ProfilePageAdapter(this.homePageAdapter, this.profilePage);

  @override
  void onProfileCompletion(BuildContext context, UserType userType) {
    homePageAdapter.loadHomeUI(context, userType);
  }

  @override
  void onLoginSuccess(BuildContext context, UserType userType) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => profilePage(userType)),
        (Route<dynamic> route) => false);
  }

  @override
  Widget loadProfiles(
      BuildContext context, UserType userType, ProfileCubit cubit) {
        //print("Profile Adapter $userType");
    switch (userType) {
      case UserType.PATIENT:
        return PatientProfileScreen(cubit);
      case UserType.SPOKE:
        return DoctorProfileScreen(cubit, userType);
      case UserType.HUB:
         return DoctorProfileScreen(cubit, userType);
      default:
        return DriverProfileScreen(cubit);
    }
  }
}
