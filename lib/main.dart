//@dart=2.9
<<<<<<< HEAD
=======
import 'package:firebase_messaging/firebase_messaging.dart';
>>>>>>> a5d6830502fbeadaaa7b426cfad815707f0a6384
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

<<<<<<< HEAD
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

=======
>>>>>>> a5d6830502fbeadaaa7b426cfad815707f0a6384
  print("FCM Token " + await FirebaseMessaging.instance.getToken());
  runApp(MyApp(startPage));
}
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
   

<<<<<<< HEAD
  print("Handling a background message: ${message.data}");
}
=======
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.data}");
}

>>>>>>> a5d6830502fbeadaaa7b426cfad815707f0a6384
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
