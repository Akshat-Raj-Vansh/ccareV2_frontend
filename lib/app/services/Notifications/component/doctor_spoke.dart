// //@dart=2.9
// import 'package:aligned_dialog/aligned_dialog.dart';
// import 'package:ccarev2_frontend/main/domain/edetails.dart';
// import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
// import 'package:ccarev2_frontend/user/domain/location.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';

// class SpokeNotificationHandler {
//   static MainCubit mainCubit;
//   static BuildContext context;
//   static configure(MainCubit cubit, BuildContext c) {
//     mainCubit = cubit;
//     context = c;
//   }

//   static Future<void> backgroundMessageHandler(RemoteMessage message) async {
//     print("Handling a background message for doctor: ${message.data}");
//   }

//   static Future<void> foregroundMessageHandler(RemoteMessage message) async {
//     print("Handling a foreground message for doctor: ${message.data}");

//     //  if(message.data["type"]=="Consultation" && message.data["user"]=="HUB"){
//     //   await mainCubit.hubAccepted();
//     // }
//     if (message.data['type'] == 'EmergencyStatus') {
//       //  print(message.data['status']);
//       await mainCubit.spokeStatusFetched(message.data['status']);
//     }
//     if (message.data['type'] == 'Emergency') {
//       if (message.data["user"] == "PATIENT") {
//         // //print("inside");
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: Theme.of(context).accentColor,
//           content: Text(
//             'Patient in emergency!! Accepting the emergency',
//             style: Theme.of(context)
//                 .textTheme
//                 .caption
//                 .copyWith(color: Colors.white, fontSize: 8.sp),
//           ),
//         ));
//         await mainCubit.showAcceptNotif(message.data["_patientID"]);
//       }
//       if (message.data["user"] == "DRIVER") {
//         // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         //   backgroundColor: Theme.of(context).accentColor,
//         //   content: Text(
//         //     message.notification.body,
//         //     style: Theme.of(context)
//         //         .textTheme
//         //         .caption
//         //         .copyWith(color: Colors.white, fontSize :8.sp),
//         //   ),
//         // ));
//         mainCubit.driverAccepted(Location.fromJson(message.data["location"]));
//         await mainCubit.fetchEmergencyDetails(
//             patientID: message.data["patientID"]);
//       }
//     }
//   }

//   static Future<void> onMessageOpenedHandler(RemoteMessage message) async {
//     print(
//         "Handling a message for doctor in onMessageOpenedHandler: ${message.data}");
//     // if (message.data['type'] == 'Emergency') {
//     //   //print("Not supposed to be here");
//     //   await mainCubit.showAcceptNotif(message.data["_patientID"]);
//     // }
//     // if (message.data['type'] == 'EmergencyStatus') {
//     //   await mainCubit.spokeStatusFetched(message.data['status']);
//     // }
//     // if(message.data["type"]=="Consultation" && message.data["user"]=="HUB"){
//     //   await mainCubit.hubAccepted();
//     // }
//   }
// }
