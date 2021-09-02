import 'package:ccarev2_frontend/pages/home/home_page_adapter.dart';
import 'package:ccarev2_frontend/services/Notifications/notificationContoller.dart';
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/state_management/main/main_state.dart';
import 'package:ccarev2_frontend/state_management/user/user_cubit.dart';
import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';

class PatientHomeUI extends StatefulWidget {
  final MainCubit mainCubit;
  final UserCubit userCubit;
  final IHomePageAdapter homePageAdapter;
  const PatientHomeUI(this.mainCubit, this.userCubit, this.homePageAdapter);

  @override
  State<PatientHomeUI> createState() => _PatientHomeUIState();
}

class _PatientHomeUIState extends State<PatientHomeUI> {
  @override
    void initState(){
    super.initState();
    NotificationController.configure(widget.mainCubit, UserType.patient,context);
    NotificationController.fcmHandler();
  }

  @override
  Widget build(BuildContext context) {
    return CubitConsumer<MainCubit, MainState>(builder: (_, state) {
      return _buildUI(context);
    }, listener: (context, state) {
      if (state is LoadingState) {
        print("Loading State Called");
        _showLoader();
      } else if (state is EmergencyState) {
        print("Emergency State Called");
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

  _buildUI(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Patient Home UI'),
          leading: IconButton(
            onPressed: () =>
                widget.homePageAdapter.onLogout(context, widget.userCubit),
            icon: Icon(Icons.logout),
          ),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Theme.of(context).accentColor,
                content: Text(
                  'This button is used for sending emergency SOS',
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(color: Colors.white, fontSize: 16),
                ),
              ));
              await widget.mainCubit.notify();
            },
            child: const Text('Emergency'),
          ),
        ),
      );
}
