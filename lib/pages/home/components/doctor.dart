import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/state_management/main/main_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
class DoctorSide extends StatefulWidget {
  final MainCubit cubit;
  const DoctorSide(this.cubit);

  @override
  State<DoctorSide> createState() => _DoctorSideState();
}

class _DoctorSideState extends State<DoctorSide> {
   Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }
  
  void _handleMessage(RemoteMessage message) async  {
    if (message.data['type'] == 'Emergency') {
      await widget.cubit.acceptPatientByDoctor(message.data["_patientID"]);
    }
  }


  @override
  void initState() {
    super.initState();
    setupInteractedMessage();
  }
  @override
  Widget build(BuildContext context) {
    return CubitConsumer<MainCubit, MainState>(builder: (_, state) {
   
      return _buildUI(context);
    }, listener: (context, state) {
      if (state is LoadingState) {
        print("Loading State Called");
        _showLoader();
      } else if (state is AcceptState) {
        print("Accept State Called");
        _hideLoader();
      } else if (state is AllPatientsState) {
        print("AllPatientsState State Called");
        _hideLoader();
      }
    });
  }

  _showLoader() {
    var alert = const AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Center(
          child: CircularProgressIndicator(
        backgroundColor: Colors.green,
      )),
    );
    showDialog(
        context: context, barrierDismissible: true, builder: (_) => alert);
  }

  _hideLoader() {
    Navigator.of(context, rootNavigator: true).pop();
  }

  _buildUI(BuildContext buildContext) => Center(
        child: RaisedButton(
          onPressed: () async {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Theme.of(context).accentColor,
              content: Text(
                'This button is used for accepting emergency SOS',
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: Colors.white, fontSize: 16),
              ),
            ));
          },
          child: const Text('Alert Button'),
        ),
      );
}
