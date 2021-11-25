//@dart=2.9
import 'package:ccarev2_frontend/services/Notifications/component/doctor.dart';
import 'package:ccarev2_frontend/services/Notifications/component/driver.dart';
import 'package:ccarev2_frontend/services/Notifications/component/patient.dart';
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationController {
  static AndroidNotificationChannel highImportancechannel =
      AndroidNotificationChannel(
          'high_importance_channel', // id
          'Emergency5', // title
          'This channel is used for important notifications.', // description
          importance: Importance.max);

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static UserType userType;
  static configure(MainCubit mainCubit, UserType type, BuildContext context) {
    userType = type;
    print(type);
    switch (userType) {
      case UserType.PATIENT:
        PatientNotificationHandler.configure(mainCubit, context);
        break;
      case UserType.DOCTOR:
        DoctorNotificationHandler.configure(mainCubit, context);
        break;
      default:
        DriverNotificationHandler.configure(mainCubit, context);
        break;
    }
  }

  static get getFCMToken async => await FirebaseMessaging.instance.getToken();

  static createChannels() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        .createNotificationChannel(highImportancechannel);
  }

  static fcmHandler() {
    backgroundMessageHandler();
    onMessageHandler();
    onMessageOpenedHandler();
  }

  static backgroundMessageHandler() async {
    Future<void> Function(RemoteMessage) selected;
    switch (userType) {
      case UserType.PATIENT:
        selected = PatientNotificationHandler.backgroundMessageHandler;
        break;
      case UserType.DOCTOR:
        selected = DoctorNotificationHandler.backgroundMessageHandler;
        break;
      default:
        selected = DriverNotificationHandler.backgroundMessageHandler;
        break;
    }
    FirebaseMessaging.onBackgroundMessage(selected);
  }

  static onMessageHandler() {
    Future<void> Function(RemoteMessage) selected;
    switch (userType) {
      case UserType.PATIENT:
        selected = PatientNotificationHandler.foregroundMessageHandler;
        break;
      case UserType.DOCTOR:
        selected = DoctorNotificationHandler.foregroundMessageHandler;
        break;
      default:
        selected = DriverNotificationHandler.foregroundMessageHandler;
        break;
    }
    FirebaseMessaging.onMessage.listen(selected);
  }

  static onMessageOpenedHandler() {
    Future<void> Function(RemoteMessage) selected;
    switch (userType) {
      // case UserType.PATIENT:
      //   selected = PatientNotificationHandler.foregroundMessageHandler;
      //   break;
      case UserType.DOCTOR:
        selected = DoctorNotificationHandler.onMessageOpenedHandler;
        break;
      default:
        selected = DriverNotificationHandler.onMessageOpenedHandler;
        break;
    }
    FirebaseMessaging.onMessageOpenedApp.listen(selected);
  }
}
