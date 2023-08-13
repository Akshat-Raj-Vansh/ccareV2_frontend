import 'package:ccarev2_frontend/services/Notifications/component/doctor_hub.dart';
import 'package:ccarev2_frontend/services/Notifications/component/doctor_spoke.dart';
import 'package:ccarev2_frontend/services/Notifications/component/driver.dart';
import 'package:ccarev2_frontend/services/Notifications/component/patient.dart';
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationController {
  final patientNotificationHandler = PatientNotificationHandler();
  final spokeNotificationHandler = SpokeNotificationHandler();
  final hubNotificationHandler = HubNotificationHandler();
  final driverNotificationHandler = DriverNotificationHandler();
  AndroidNotificationChannel highImportancechannel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'Emergency5', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.max);

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  UserType? userType;
  configure(MainCubit mainCubit, UserType type, BuildContext context) {
    userType = type;
    //print(type);
    switch (userType) {
      case UserType.PATIENT:
        patientNotificationHandler.configure(mainCubit);
        break;
      case UserType.SPOKE:
        spokeNotificationHandler.configure(mainCubit);
        break;
      case UserType.HUB:
        hubNotificationHandler.configure(mainCubit);
        break;
      default:
        driverNotificationHandler.configure(mainCubit);
        break;
    }
  }

  get getFCMToken async => await FirebaseMessaging.instance.getToken();

  createChannels() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .createNotificationChannel(highImportancechannel);
  }

  fcmHandler() {
    backgroundMessageHandler();
    onMessageHandler();
    onMessageOpenedHandler();
  }

  backgroundMessageHandler() async {
    Future<void> Function(RemoteMessage) selected;
    switch (userType) {
      case UserType.PATIENT:
        selected = patientNotificationHandler.backgroundMessageHandler;
        break;
      case UserType.SPOKE:
        selected = spokeNotificationHandler.backgroundMessageHandler;
        break;
      case UserType.HUB:
        selected = hubNotificationHandler.backgroundMessageHandler;
        break;
      default:
        selected = driverNotificationHandler.backgroundMessageHandler;
        break;
    }
    print("====== SELECTED =======");
    print(selected);
    FirebaseMessaging.onBackgroundMessage(selected);
  }

  onMessageHandler() {
    Future<void> Function(RemoteMessage) selected;
    switch (userType) {
      case UserType.PATIENT:
        selected = patientNotificationHandler.foregroundMessageHandler;
        break;
      case UserType.SPOKE:
        selected = spokeNotificationHandler.foregroundMessageHandler;
        break;
      case UserType.HUB:
        selected = hubNotificationHandler.foregroundMessageHandler;
        break;
      default:
        selected = driverNotificationHandler.foregroundMessageHandler;
        break;
    }
    FirebaseMessaging.onMessage.listen(selected);
  }

  onMessageOpenedHandler() {
    Future<void> Function(RemoteMessage) selected;
    switch (userType) {
      case UserType.PATIENT:
        selected = patientNotificationHandler.foregroundMessageHandler;
        break;
      case UserType.SPOKE:
        selected = spokeNotificationHandler.onMessageOpenedHandler;
        break;
      case UserType.HUB:
        selected = hubNotificationHandler.onMessageOpenedHandler;
        break;
      default:
        selected = driverNotificationHandler.onMessageOpenedHandler;
        break;
    }
    FirebaseMessaging.onMessageOpenedApp.listen(selected);
  }
}
