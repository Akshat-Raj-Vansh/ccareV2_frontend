//@dart=2.9
import 'dart:developer';

import 'package:ccarev2_frontend/main/domain/edetails.dart';
import 'package:ccarev2_frontend/pages/chat/chatScreen.dart';
import 'package:ccarev2_frontend/pages/home/components/hub/hub_patient_list.dart';
import 'package:ccarev2_frontend/pages/home/components/hub/hub_request_list.dart';
import 'package:ccarev2_frontend/pages/home/home_page_adapter.dart';
import 'package:ccarev2_frontend/pages/spoke_form/patient_exam_screen.dart';
import 'package:ccarev2_frontend/pages/spoke_form/patient_history_screen.dart';
import 'package:ccarev2_frontend/pages/spoke_form/patient_report_screen.dart';
import 'package:ccarev2_frontend/services/Notifications/notificationContoller.dart';
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/state_management/main/main_state.dart';
import 'package:ccarev2_frontend/state_management/main/main_state.dart';
import 'package:ccarev2_frontend/state_management/user/user_cubit.dart';
import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:ccarev2_frontend/utils/constants.dart';
import 'package:sizer/sizer.dart';

import 'package:ccarev2_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';

class HomeScreenHub extends StatefulWidget {
  final MainCubit mainCubit;
  final UserCubit userCubit;
  final IHomePageAdapter homePageAdapter;

  const HomeScreenHub(this.mainCubit, this.userCubit, this.homePageAdapter);

  @override
  _HomeScreenHubState createState() => _HomeScreenHubState();
}

class _HomeScreenHubState extends State<HomeScreenHub> {
  List<EDetails> eDetails;
  List<EDetails> rDetails;
  // static bool _patientAccepted = false;
  bool patientsLoaded = false;
  bool requestsLoaded = false;

  dynamic currentState = null;
  bool loader = false;
  String token;

  @override
  void initState() {
    super.initState();
    CubitProvider.of<MainCubit>(context).fetchHubPatientDetails();
    CubitProvider.of<MainCubit>(context).fetchHubRequests();
    CubitProvider.of<MainCubit>(context).fetchToken();
    NotificationController.configure(widget.mainCubit, UserType.HUB, context);
    NotificationController.fcmHandler();
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
            .copyWith(color: Colors.white, fontSize: 12.sp),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('CardioCare - HUB'),
          backgroundColor: kPrimaryColor,
          actions: [
            IconButton(
              onPressed: () async {
                await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                          'Are you sure?',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                          ),
                        ),
                        content: Text(
                          'Do you want to logout?',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 12.sp,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text(
                              'Cancel',
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              widget.homePageAdapter
                                  .onLogout(context, widget.userCubit);
                            },
                            child: Text(
                              'Yes',
                            ),
                          ),
                        ],
                      ),
                    ) ??
                    false;
              },
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        body: CubitConsumer<MainCubit, MainState>(builder: (_, state) {
          if (state is HubPatientsLoaded) {
            print('LOG > doctor_hub.dart > 139 > state: ${state.toString()}');
            currentState = state;
            print(state);
            eDetails = state.details;
            patientsLoaded = true;
          }
          if (state is HubRequestsLoaded) {
            print('LOG > doctor_hub.dart > 146 > state: ${state.toString()}');
            currentState = state;
            rDetails = state.details;
            print('LOG > doctor_hub.dart > 149 > rDetails: ${rDetails}');
            requestsLoaded = true;
          }
          if (state is TokenLoadedState) {
            print('LOG > doctor_hub.dart > 153 > state: ${state.toString()}');
            token = state.token;
            print("Inside TokensLoaded State");
            print(token);
          }
          if (state is NewErrorState) {
            print('New Error Satet');
            if (state.prevState == "HUB REUQESTS") requestsLoaded = false;
            if (state.prevState == "HUB PATIENTS") patientsLoaded = false;
          }
          if (state is NoPatientAccepted) {
            print('NoPatientAccepted');
            patientsLoaded = false;
            currentState = state;
          }
          if (state is NoPatientRequested) {
            print('NoPatientRequested');
            requestsLoaded = false;
            currentState = state;
          }
          if (currentState == null) {
            return Center(child: CircularProgressIndicator());
          }

          return _buildUI(context);
        }, listener: (context, state) async {
          // if (state is LoadingState) {
          //   //print("Loading State Called");
          //   _showLoader();
          // }
          log('LOG > doctor_hub.dart > 165 > state: ${state.toString()}');
          if (state is ErrorState) {
            print("Error State Called HUB DOCTORr");
            // // _hideLoader();
          } else if (state is HubPatientsLoaded) {
            currentState = state;
            eDetails = state.details;
            patientsLoaded = true;
          } else if (state is HubRequestsLoaded) {
            currentState = state;
            rDetails = state.details;
            requestsLoaded = true;
          } else if (state is PatientAcceptedHub) {
            print('PatientAcceptedHUb state claled');
            widget.mainCubit.fetchHubPatientDetails();
            widget.mainCubit.fetchHubRequests();
            setState(() {
              
            });
          } else if (state is TokenLoadedState) {
            token = state.token;
            print("Inside TokensLoaded State");
            print(token);
          } else if (state is AcceptState) {
            // // _hideLoader();
            print("Accept State Called");
            await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      'Are you sure?',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                      ),
                    ),
                    content: Text(
                      'Do you want to accept the patient?',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 12.sp,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text(
                          'Cancel',
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          // make api for accept patient by Hub
                          // widget.mainCubit.acceptPatientByHub(state.patientID);
                          // setState(() {});
                          print('AcceptState');
                          // widget.mainCubit.acceptPatientByHub(state.patientID);
                          widget.mainCubit.fetchHubPatientDetails();
                          widget.mainCubit.fetchHubRequests();
                          Navigator.of(context).pop(false);
                        },
                        child: Text(
                          'Yes',
                        ),
                      ),
                    ],
                  ),
                ) ??
                false;
            //Create new state PatientAccepted by Hub
          } else if (state is PatientAccepted) {
            // // _hideLoader();
            print("Inside patient accepted by Doctor state");
            widget.mainCubit.fetchHubPatientDetails();
          }
        }));
  }

  _buildUI(BuildContext buildContext) => Stack(children: [
        SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: SizeConfig.screenWidth,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Text(
                "Patient Request List",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18.sp, color: kPrimaryColor),
              ),
            ),
            requestsLoaded
                ? RequestPatientList(
                    patients: rDetails
                        .map<PatientDetails>((e) => e.patientDetails)
                        .toList(),
                    mainCubit: widget.mainCubit)
                : Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                    child: Text("No Patients"),
                  ),
            Container(
              width: SizeConfig.screenWidth,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Text(
                "Patient Accepted List",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18.sp, color: kPrimaryColor),
              ),
            ),
            patientsLoaded
                ? AcceptedPatientList(
                    eDetails, CubitProvider.of<MainCubit>(context))
                : Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                    child: Text("No Patients"),
                  ),
          ]),
        ),
      ]);
}
