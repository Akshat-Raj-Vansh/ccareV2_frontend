//@dart=2.9
import 'package:ccarev2_frontend/services/Notifications/notificationContoller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';

import 'composition_root.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await CompositionRoot.configure();
  var startPage = await CompositionRoot.start();
  await Firebase.initializeApp();
  await NotificationController.createChannels();
  print(await NotificationController.getFCMToken);
  runApp(MyApp(startPage));
}
class MyApp extends StatelessWidget {
  final Widget startPage;

  const MyApp(this.startPage);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'CardioCare',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            textTheme:
                GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
            accentColor: Colors.green,
            visualDensity: VisualDensity.adaptivePlatformDensity),
        home: this.startPage);
  }
}
