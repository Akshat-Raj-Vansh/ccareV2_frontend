//@dart=2.9s
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
          ? _buildPatientSide(context)
          : _buildDoctorSide(context),
    );
  }

  _buildPatientSide(context) => Center(
        child: RaisedButton(
          onPressed: () async {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Theme.of(context).accentColor,
              content: Text(
                'This button is used for sending emergency SOS',
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: Colors.white, fontSize: 16),
              ),
            ));
          },
          child: const Text('Emergency Button'),
        ),
      );

  _buildDoctorSide(context) => Center(
        child: RaisedButton(
          onPressed: () async {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Theme.of(context).accentColor,
              content: Text(
                'This button is used for accepting emergency SOS',
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: Colors.white, fontSize: 16),
              ),
            ));
          },
          child: const Text('Alert Button'),
        ),
      );
}
