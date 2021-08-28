//@dart=2.9s
import 'package:ccarev2_frontend/composition_root.dart';
import 'package:ccarev2_frontend/pages/home/components/doctor.dart';
import 'package:ccarev2_frontend/pages/home/components/driver.dart';
import 'package:ccarev2_frontend/pages/home/components/patient.dart';
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/state_management/user/user_cubit.dart';
import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:flutter/material.dart';

import 'package:flutter_cubit/flutter_cubit.dart';

class HomeScreen extends StatefulWidget {
  final UserType userType;
  final Widget AuthPage;
  HomeScreen(this.userType, this.AuthPage);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
   
  @override
  Widget build(BuildContext context) {
    print(widget.userType);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            CubitProvider.of<UserCubit>(context).signOut();

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => this.widget.AuthPage),
                (route) => false);
          },
          icon: Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
        ),
        title: const Text('Cardio Care'),
      ),
      body: widget.userType == UserType.patient
          ? PatientSide(CubitProvider.of<MainCubit>(context))
          : widget.userType == UserType.doctor
              ? DoctorSide(CubitProvider.of<MainCubit>(context))
              : DriverSide(CubitProvider.of<MainCubit>(context)),
    );
  }
}
