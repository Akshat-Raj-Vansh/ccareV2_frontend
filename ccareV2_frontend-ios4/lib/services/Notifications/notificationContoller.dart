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
        SpokeNotificationHandler().configure(mainCubit);
        break;
      case UserType.HUB:
        HubNotificationHandler().configure(mainCubit);
        break;
      default:
        DriverNotificationHandler().configure(mainCubit);
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
        selected = SpokeNotificationHandler().backgroundMessageHandler;
        break;
      case UserType.HUB:
        selected = HubNotificationHandler().backgroundMessageHandler;
        break;
      default:
        selected = DriverNotificationHandler().backgroundMessageHandler;
        break;
    }
    FirebaseMessaging.onBackgroundMessage(selected);
  }

  onMessageHandler() {
    Future<void> Function(RemoteMessage) selected;
    switch (userType) {
      case UserType.PATIENT:
        selected = patientNotificationHandler.foregroundMessageHandler;
        break;
      case UserType.SPOKE:
        selected = SpokeNotificationHandler().foregroundMessageHandler;
        break;
      case UserType.HUB:
        selected = HubNotificationHandler().foregroundMessageHandler;
        break;
      default:
        selected = DriverNotificationHandler().foregroundMessageHandler;
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
        selected = SpokeNotificationHandler().onMessageOpenedHandler;
        break;
      case UserType.HUB:
        selected = HubNotificationHandler().onMessageOpenedHandler;
        break;
      default:
        selected = DriverNotificationHandler().onMessageOpenedHandler;
        break;
    }
    FirebaseMessaging.onMessageOpenedApp.listen(selected);
  }
}
