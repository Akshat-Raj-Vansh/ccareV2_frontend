import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HubNotificationHandler {
  MainCubit? mainCubit;
  // BuildContext? context;
  configure(MainCubit cubit) {
    mainCubit = cubit;
    // context = c;
  }

  Future<void> backgroundMessageHandler(RemoteMessage message) async {
    print("Handling a background message for spoke: ${message.data}");
  }

  Future<void> foregroundMessageHandler(RemoteMessage message) async {
    print("Handling a foreground message for spoke: ${message.data}");
    if (message.data['type'] == 'Consultation') {
      if (message.data["user"] == "SPOKE") {
        // //print("inside");
        // ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
        //   backgroundColor: Theme.of(context!).colorScheme.secondary,
        //   content: Text(
        //     'New Patient Request Received!',
        //     style: Theme.of(context!)
        //         .textTheme
        //         .bodySmall!
        //         .copyWith(color: Colors.white, fontSize: 8.sp),
        //   ),
        // ));
        await mainCubit!.acceptPatientByHub(message.data["patientID"]);
      }
    }
  }

  Future<void> onMessageOpenedHandler(RemoteMessage message) async {
    if (message.data['type'] == 'Consultation') {
      print("Not supposed to be here");
      await mainCubit!.acceptPatientByHub(message.data["patientID"]);
    }
  }
}
