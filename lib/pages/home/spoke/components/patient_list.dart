import 'dart:developer';

import 'package:ccarev2_frontend/main/domain/edetails.dart';
import 'package:ccarev2_frontend/pages/home/spoke/components/patient_info.dart';
import 'package:ccarev2_frontend/services/Notifications/notificationContoller.dart';
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/state_management/main/main_state.dart';
import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:ccarev2_frontend/user/domain/hub_doc_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';

class PatientList extends StatefulWidget {
  const PatientList();

  @override
  State<PatientList> createState() => _PatientListState();
}

class _PatientListState extends State<PatientList> {
  List<PatientDetails> _patients = [];
  static bool loader = false;
  static dynamic currentState = null;

  @override
  void initState() {
    super.initState();
    CubitProvider.of<MainCubit>(context).getAllPatients();
    NotificationController.configure(
        CubitProvider.of<MainCubit>(context), UserType.SPOKE, context);
    NotificationController.fcmHandler();
    // CubitProvider.of<MainCubit>(context).fetchToken();
  }

  _showLoader() {
    loader = true;
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

  _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).accentColor,
      content: Text(
        msg,
        style: Theme.of(context)
            .textTheme
            .caption
            ?.copyWith(color: Colors.white, fontSize: 16),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return CubitConsumer<MainCubit, MainState>(builder: (_, state) {
      if (state is PatientsLoaded) {
        currentState = PatientsLoaded;
        _patients = state.patients;
      }
      if (state is NormalState) {
        //   _hideLoader();
        currentState = NormalState;
      }
      if (currentState == null)
        return Center(child: CircularProgressIndicator());
      return _buildList(context);
    }, listener: (context, state) async {
      if (state is LoadingState) {
        print("Loading State Called");
        log('LOG > doctor_spoke.dart > 197 > state: ${state.toString()}');
        _showLoader();
      } else if (state is ErrorState) {
        _hideLoader();
        log('LOG > doctor_spoke.dart > 204 > state: ${state.toString()}');
      }
    });
  }

  _buildList(context) => ListView.builder(
        itemCount: _patients.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => CubitProvider<MainCubit>(
                  create: (ctx) => CubitProvider.of<MainCubit>(context),
                  child: PatientInfo(_patients[index].id),
                ),
              ),
            ),
            child: ListTile(
                leading: Icon(Icons.person),
                trailing: Text(
                  _patients[index].name,
                  style: TextStyle(color: Colors.green, fontSize: 15),
                ),
                title: Text(_patients[index].name)),
          );
        },
      );
}
