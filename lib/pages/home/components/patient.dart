import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/state_management/main/main_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';

class PatientSide extends StatefulWidget {
  const PatientSide({Key? key}) : super(key: key);

  @override
  State<PatientSide> createState() => _PatientSideState();
}

class _PatientSideState extends State<PatientSide> {
  @override
  Widget build(BuildContext context) {
    return CubitConsumer<MainCubit, MainState>(builder: (_, state) {
      var cubit = CubitProvider.of<MainCubit>(context);
      return _buildUI(context, cubit);
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

  _buildUI(BuildContext context, MainCubit cubit) => Center(
        child: RaisedButton(
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
            //  cubit.api.notify(token);
          },
          child: const Text('Alert Button'),
        ),
      );
}
