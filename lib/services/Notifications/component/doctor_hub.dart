//@dart=2.9
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class HubNotificationHandler {
  static MainCubit mainCubit;
  static BuildContext context;
  static configure(MainCubit cubit, BuildContext c) {
    mainCubit = cubit;
    context = c;
  }

  static Future<void> backgroundMessageHandler(RemoteMessage message) async {
    //print("Handling a background message for spoke: ${message.data}");
  }

  static Future<void> foregroundMessageHandler(RemoteMessage message) async {
    //print("Handling a foreground message for spoke: ${message.data}");
    if (message.data['type'] == 'Consult') {
      if (message.data["user"] == "SPOKE") {
        // //print("inside");
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   backgroundColor: Theme.of(context).accentColor,
        //   content: Text(
        //     'Patient in emergency!! Accepting the emergency',
        //     style: Theme.of(context)
        //         .textTheme
        //         .caption
        //         .copyWith(color: Colors.white, fontSize :8.sp),
        //   ),
        // ));
        await mainCubit.acceptPatientByHub(message.data["_patientID"]);
      }
    }
  }

  static Future<void> onMessageOpenedHandler(RemoteMessage message) async {
    if (message.data['type'] == 'Consult') {
      //print("Not supposed to be here");
      await mainCubit.acceptPatientByHub(message.data["_patientID"]);
    }
  }
}
