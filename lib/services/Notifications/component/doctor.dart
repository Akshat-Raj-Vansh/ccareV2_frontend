//@dart=2.9
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:ccarev2_frontend/main.dart';
import 'package:ccarev2_frontend/state_management/emergency/emergency_cubit.dart';
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/user/domain/location.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class DoctorNotificationHandler {
  static MainCubit mainCubit;
  static EmergencyCubit emergencyCubit;
  static BuildContext context;
  static configure(
      MainCubit mainCubit, EmergencyCubit emergencyCubit, BuildContext c) {
    mainCubit = mainCubit;
    emergencyCubit = emergencyCubit;
    context = c;
  }

  static Future<void> backgroundMessageHandler(RemoteMessage message) async {
    print("Handling a background message for doctor: ${message.data}");
  }

  static Future<void> foregroundMessageHandler(RemoteMessage message) async {
    print("Handling a foreground message for doctor: ${message.data}");
    if (message.data['type'] == 'Emergency') {
      if (message.data["user"] == "PATIENT") {
        print("inside");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Theme.of(context).accentColor,
          content: Text(
            'Patient in emergency!! Accepting the emergency',
            style: Theme.of(context)
                .textTheme
                .caption
                .copyWith(color: Colors.white, fontSize: 16),
          ),
        ));
        await emergencyCubit.acceptPatientByDoctor(message.data["_patientID"]);
      }
      if (message.data["user"] == "DRIVER") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Theme.of(context).accentColor,
          content: Text(
            message.notification.body,
            style: Theme.of(context)
                .textTheme
                .caption
                .copyWith(color: Colors.white, fontSize: 16),
          ),
        ));

        emergencyCubit
            .driverAccepted(Location.fromJson(message.data["location"]));
      }
      mainCubit.acceptedPatient();
    }
  }

  static Future<void> onMessageOpenedHandler(RemoteMessage message) async {
    if (message.data['type'] == 'Emergency') {
      mainCubit.acceptedPatient();
      await emergencyCubit.acceptPatientByDoctor(message.data["_patientID"]);
    }
  }
}
