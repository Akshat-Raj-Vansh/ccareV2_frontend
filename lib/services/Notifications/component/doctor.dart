//@dart=2.9
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:ccarev2_frontend/main/domain/edetails.dart';
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/user/domain/location.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class DoctorNotificationHandler {
  static MainCubit mainCubit;
  static BuildContext context;
  static configure(MainCubit cubit, BuildContext c) {
    mainCubit = cubit;
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

        await mainCubit.acceptRequest(message.data["_patientID"]);
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
        mainCubit
            .driverAccepted(DriverDetails.fromJson(message.data["location"]));
      }
    }
  }

  static Future<void> onMessageOpenedHandler(RemoteMessage message) async {
    if (message.data['type'] == 'Emergency') {
      await mainCubit.acceptRequest(message.data["_patientID"]);
    }
  }
}
