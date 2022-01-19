//@dart=2.9
import 'package:sizer/sizer.dart';
import 'package:ccarev2_frontend/services/Notifications/notificationContoller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './utils/constants.dart';
import 'composition_root.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CompositionRoot.configure();
  var startPage = await CompositionRoot.start();
  await Firebase.initializeApp();
  await NotificationController.createChannels();
  //print(await NotificationController.getFCMToken);
  runApp(MyApp(startPage));
}

class MyApp extends StatelessWidget {
  final Widget startPage;

  const MyApp(this.startPage);
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder:(context, orientation, deviceType)=> MaterialApp(
          title: 'CardioCare',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              textTheme:
                  GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
              accentColor: kAccentColor,
              primaryColor: kPrimaryColor,
              visualDensity: VisualDensity.adaptivePlatformDensity),
          home: this.startPage),
    );
  }
}
