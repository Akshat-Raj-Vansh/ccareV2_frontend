//@dart=2.9
// import 'package:camera/camera.dart';
import 'dart:io';

import 'package:ccarev2_frontend/firebase_options.dart';
import 'package:ccarev2_frontend/pages/chat/testChatScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:ccarev2_frontend/services/Notifications/notificationContoller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './utils/constants.dart';
import 'composition_root.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CompositionRoot.configure();
  var startPage = await CompositionRoot.start();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  if (Platform.isIOS) {
    await messaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
  } else if (Platform.isAndroid) {
    await NotificationController.createChannels();
  }
  print('FCM Token: ' + await NotificationController.getFCMToken);
  // print('User granted permission: ${settings.authorizationStatus}');
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  // cameras = await availableCameras();
  runApp(MyApp(startPage));
}

// Platform  Firebase App Id
// web       1:797374976435:web:c4dab694ff35ea28d27bc6
// android   1:797374976435:android:fc764f328698da40d27bc6
// ios       1:797374976435:ios:9e5ec16a3e816da6d27bc6

class MyApp extends StatelessWidget {
  final Widget startPage;

  const MyApp(this.startPage);
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) => MaterialApp(
          title: 'CardioCare',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              textTheme:
                  GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
              accentColor: kAccentColor,
              primaryColor: kPrimaryColor,
              visualDensity: VisualDensity.adaptivePlatformDensity),
          home:
              // ChatScreen()
              this.startPage),
    );
  }
}
