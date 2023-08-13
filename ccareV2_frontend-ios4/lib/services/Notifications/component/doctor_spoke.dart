import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/user/domain/location.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class SpokeNotificationHandler {
  MainCubit? mainCubit;
  // BuildContext context = BuildContext as BuildContext;
  configure(MainCubit cubit) {
    mainCubit = cubit;
    // context = c;
  }

  Future<void> backgroundMessageHandler(RemoteMessage message) async {
    print("Handling a background message for doctor: ${message.data}");
  }

  Future<void> foregroundMessageHandler(RemoteMessage message) async {
    print("Handling a foreground message for doctor: ${message.data}");

    //  if(message.data["type"]=="Consultation" && message.data["user"]=="HUB"){
    //   await mainCubit.hubAccepted();
    // }
    if (message.data['type'] == 'EmergencyStatus') {
      //  print(message.data['status']);
      await mainCubit!.spokeStatusFetched(message.data['status']);
    }
    if (message.data['type'] == 'Emergency') {
      if (message.data["user"] == "PATIENT") {
        // //print("inside");
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   backgroundColor: Theme.of(context).colorScheme.secondary,
        //   content: Text(
        //     'Patient in emergency!! Accepting the emergency',
        //     style: Theme.of(context)
        //         .textTheme
        //         .bodySmall!
        //         .copyWith(color: Colors.white, fontSize: 8.sp),
        //   ),
        // ));
        await mainCubit!.showAcceptNotif(message.data["_patientID"]);
      }
      if (message.data["user"] == "DRIVER") {
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   backgroundColor: Theme.of(context).accentColor,
        //   content: Text(
        //     message.notification.body,
        //     style: Theme.of(context)
        //         .textTheme
        //         .caption
        //         .copyWith(color: Colors.white, fontSize :8.sp),
        //   ),
        // ));
        mainCubit!.driverAccepted(Location.fromJson(message.data["location"]));
        await mainCubit!.fetchEmergencyDetails(
            patientID: message.data["patientID"]);
      }
    }
  }

  Future<void> onMessageOpenedHandler(RemoteMessage message) async {
    print(
        "Handling a message for doctor in onMessageOpenedHandler: ${message.data}");
    // if (message.data['type'] == 'Emergency') {
    //   //print("Not supposed to be here");
    //   await mainCubit.showAcceptNotif(message.data["_patientID"]);
    // }
    // if (message.data['type'] == 'EmergencyStatus') {
    //   await mainCubit.spokeStatusFetched(message.data['status']);
    // }
    // if(message.data["type"]=="Consultation" && message.data["user"]=="HUB"){
    //   await mainCubit.hubAccepted();
    // }
  }
}
