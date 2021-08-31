//@dart=2.9
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';

import 'composition_root.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'Emergency4', // title
  'This channel is used for important notifications.', // description
  importance: Importance.max
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await CompositionRoot.configure();
  var startPage = await CompositionRoot.start();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
  .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
  .createNotificationChannel(channel);


  print("FCM Token " + await FirebaseMessaging.instance.getToken());

  FirebaseMessaging.onMessage.listen((RemoteMessage message){
    print(message.notification);
  
  });
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
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
