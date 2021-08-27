//@dart=2.9s
import 'package:ccarev2_frontend/pages/home/components/doctor.dart';
import 'package:ccarev2_frontend/pages/home/components/driver.dart';
import 'package:ccarev2_frontend/pages/home/components/patient.dart';
import 'package:ccarev2_frontend/state_management/profile/profile_cubit.dart';
import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final UserType userType;
  HomeScreen(this.userType);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.more_vert,
          color: Colors.white,
        ),
        title: const Text('Cardio Care'),
      ),
      body: userType == UserType.patient
          ? PatientSide()
          : userType == UserType.doctor
              ? DoctorSide()
              : DriverSide(),
    );
  }
}
