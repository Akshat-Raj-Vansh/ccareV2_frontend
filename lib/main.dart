//@dart=2.9
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'composition_root.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await CompositionRoot.configure();
  var startPage = await CompositionRoot.start();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);


  print("FCM Token " + await FirebaseMessaging.instance.getToken());
  runApp(MyApp(startPage));
}
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
   

  print("Handling a background message: ${message.data}");
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
