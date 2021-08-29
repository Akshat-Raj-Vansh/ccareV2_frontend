import 'package:ccarev2_frontend/pages/profile/components/doctor.dart';
import 'package:ccarev2_frontend/pages/profile/components/driver.dart';
import 'package:ccarev2_frontend/pages/profile/components/patient.dart';
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/state_management/profile/profile_cubit.dart';
import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:ccarev2_frontend/user/domain/details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class IProfilePageAdapter {
  void onProfileCompletion(BuildContext context, UserType userType);
  Widget loadProfiles(BuildContext context, UserType userType);
  void onLoginSuccess(BuildContext context, UserType userType);
}

class ProfilePageAdapter extends IProfilePageAdapter {
  final Widget Function(UserType userType) homePage;
  final Widget Function(UserType userType) profilePage;

  ProfilePageAdapter(this.homePage, this.profilePage);

  @override
  void onProfileCompletion(BuildContext context, UserType userType) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => homePage(userType)),
        (Route<dynamic> route) => false);
  }

  @override
  void onLoginSuccess(BuildContext context, UserType userType) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => profilePage(userType)),
        (Route<dynamic> route) => false);
  }

  @override
  Widget loadProfiles(BuildContext context, UserType userType) {
    switch (userType) {
      case UserType.patient:
        return PatientProfileScreen();
      case UserType.doctor:
        return DoctorProfileScreen();
      default:
        return DriverProfileScreen();
    }
  }
}
