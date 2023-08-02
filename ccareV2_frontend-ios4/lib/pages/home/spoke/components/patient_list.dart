import 'dart:developer';

import 'package:ccarev2_frontend/pages/home/home_page_adapter.dart';
import 'package:ccarev2_frontend/pages/home/spoke/components/patient_info.dart';
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/state_management/main/main_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:ccarev2_frontend/user/domain/patient_list_info.dart';
import 'package:ccarev2_frontend/utils/constants.dart';
import 'package:ccarev2_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class PatientList extends StatefulWidget {
  final IHomePageAdapter homePageAdapter;

  const PatientList(this.homePageAdapter);

  @override
  State<PatientList> createState() => _PatientListState();
}

class _PatientListState extends State<PatientList> {
  List<PatientListInfo> _patients = [];
  bool loader = false;
  dynamic currentState = null;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MainCubit>(context).getAllPatients();
    // NotificationController.configure(
    //     CubitProvider.of<MainCubit>(context), UserType.SPOKE, context);
    // NotificationController.fcmHandler();
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
      backgroundColor: Theme.of(context).colorScheme.secondary,
      content: Text(
        msg,
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: Colors.white, fontSize: 12.sp),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('CardioCare - My Patients'),
        backgroundColor: kPrimaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: BlocConsumer<MainCubit, MainState>(
        builder: (_, state) {
          if (state is PatientsLoaded) {
            //  // _hideLoader();
            currentState = PatientsLoaded;
            _patients = state.patients;
            //print(_patients);
          }
          if (state is NormalState) {
            //   // _hideLoader();
            currentState = NormalState;
          }
          if (currentState == null)
            return Center(child: CircularProgressIndicator());
          return _buildList(context);
        },
        listener: (context, state) async {
          if (state is LoadingState) {
            //print("Loading State Called Patient List");
            log('LOG > doctor_spoke.dart > 197 > state: ${state.toString()}');
//_showLoader();
          } else if (state is ErrorState) {
            // _hideLoader();
            log('LOG > patient_list.dart > 110 > state: ${state.toString()}');
            _hideLoader();
          }
        },
      ),
    );
  }

  _buildList(context) => Container(
        decoration: BoxDecoration(
            color: Colors.green[100], borderRadius: BorderRadius.circular(20)),
        width: SizeConfig.screenWidth,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: ListView.builder(
          itemCount: _patients.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => PatientInfo(
                      patientID: _patients[index].id,
                      mainCubit: BlocProvider.of<MainCubit>(context),
                      homePageAdapter: widget.homePageAdapter),
                ),
              ),
              child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text(
                    _patients[index].name,
                    style: TextStyle(color: Colors.green, fontSize: 12.sp),
                  ),
                  trailing: Text(_patients[index].gender.toString() +
                      '   ' +
                      _patients[index].age.toString())),
            );
          },
        ),
      );
}
