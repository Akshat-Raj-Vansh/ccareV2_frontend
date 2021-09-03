//@dart=2.9
import 'dart:convert';

import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/user/domain/location.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PatientNotificationHandler {
  static MainCubit mainCubit;
  static BuildContext context;
  static configure(MainCubit cubit, BuildContext c) {
    mainCubit = cubit;
    context = c;
  }

  static Future<void> backgroundMessageHandler(RemoteMessage message) async {
    print("Handling a background message for patient: ${message.data}");
  }

  static Future<void> foregroundMessageHandler(RemoteMessage message) async {
    print("Handling a foreground message for patient: ${message.data}");
    if (message.data['type'] == 'Emergency') {
      if (message.data["from"] == "DOCTOR") {
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
        mainCubit.doctorAccepted(Location.fromJson(message.data["location"]));
      }
      if (message.data["from"] == "DRIVER") {
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
        mainCubit.driverAccepted(Location.fromJson(message.data["location"]));
      }
    }
  }
}
