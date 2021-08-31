import 'package:ccarev2_frontend/pages/home/home_page_adapter.dart';
import 'package:ccarev2_frontend/pages/profile/components/doctor.dart';
import 'package:ccarev2_frontend/pages/profile/components/driver.dart';
import 'package:ccarev2_frontend/pages/profile/components/patient.dart';
import 'package:ccarev2_frontend/state_management/profile/profile_cubit.dart';
import 'package:ccarev2_frontend/user/domain/credential.dart';
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
    switch (userType) {
      case UserType.patient:
        return PatientProfileScreen(cubit);
      case UserType.doctor:
        return DoctorProfileScreen(cubit);
      default:
        return DriverProfileScreen(cubit);
    }
  }
}
