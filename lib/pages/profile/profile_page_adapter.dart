import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import '../../pages/home/components/driver.dart';
import '../../pages/home/components/doctor.dart';
import '../../pages/home/components/patient.dart';
import '../../user/domain/credential.dart';
import '../../state_management/user/user_cubit.dart';
import '../../state_management/main/main_cubit.dart';

abstract class IProfilePageAdapter {
  void loadProfile(BuildContext context);
  void saveProfile(BuildContext context);
}

class ProfilePageAdapter extends IProfilePageAdapter {
  final UserType userType;
  final UserCubit userCubit;

  ProfilePageAdapter(this.userType, this.userCubit);

  @override
  void saveProfile(BuildContext context) {
    // TODO: implement saveProfile
  }

  @override
  void loadProfile(BuildContext context) {
    // TODO: implement loadProfile
  }
}
