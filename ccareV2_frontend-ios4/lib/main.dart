import 'dart:io';
import 'package:ccarev2_frontend/firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import './utils/constants.dart';
import 'composition_root.dart';
import 'services/Notifications/notificationContoller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final _compositionRoot = CompositionRoot();
  await _compositionRoot.configure();
  var startPage = _compositionRoot.start();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final notificationController = NotificationController();
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
    await notificationController.createChannels();
  }
  print('FCM Token: ' + await notificationController.getFCMToken);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(MyApp(await startPage));
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
      builder: (context, orientation, deviceType) => GetMaterialApp(
          title: 'CardioCare',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              textTheme:
                  GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
              useMaterial3: true,
              primaryColor: kPrimaryColor,
              visualDensity: VisualDensity.adaptivePlatformDensity),
          home:
              // ChatScreen()
              this.startPage),
    );
  }
}
