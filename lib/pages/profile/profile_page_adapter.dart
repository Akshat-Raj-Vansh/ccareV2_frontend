import 'package:ccarev2_frontend/pages/home/home_page_adapter.dart';
import 'package:ccarev2_frontend/pages/profile/components/doctor_dummy.dart';
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
  void onProfileCompletion(BuildContext context, Details details);
  Widget loadProfiles(
      BuildContext context, Details details, ProfileCubit cubit);
  void onLoginSuccess(BuildContext context, Details details);
}

class ProfilePageAdapter extends IProfilePageAdapter {
  final HomePageAdapter homePageAdapter;
  final Widget Function(Details details) profilePage;

  ProfilePageAdapter(this.homePageAdapter, this.profilePage);

  @override
  void onProfileCompletion(BuildContext context, Details details) {
    homePageAdapter.loadHomeUI(context, details);
  }

  @override
  void onLoginSuccess(BuildContext context, Details details) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => profilePage(details)),
        (Route<dynamic> route) => false);
  }

  @override
  Widget loadProfiles(
      BuildContext context, Details details, ProfileCubit cubit) {
    UserType userType = details.user_type;
    switch (userType) {
      case UserType.patient:
        return PatientProfileScreen(cubit);
      case UserType.doctor:
        return DoctorProfileScreen(cubit, details.phone_number);
      default:
        return DriverProfileScreen(cubit);
    }
  }
}
