//@dart=2.9
import 'dart:developer';

import 'package:ccarev2_frontend/main/domain/edetails.dart';
import 'package:ccarev2_frontend/pages/chat/chatScreen.dart';
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
  EDetails eDetails;
  EDetails rDetails;
  static bool _patientAccepted = false;
  bool patientsLoaded = false;
  bool requestsLoaded = false;
  dynamic currentState = null;
  bool loader = false;
  String token;

  @override
  void initState() {
    super.initState();
    widget.mainCubit.fetchHubRequests();
    widget.mainCubit.fetchHubPatientDetails();
    widget.mainCubit.fetchToken();
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
            .copyWith(color: Colors.white, fontSize: 16),
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
                        title: const Text(
                          'Are you sure?',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                        content: const Text(
                          'Do you want to logout?',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 15,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text(
                              'Cancel',
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              widget.homePageAdapter
                                  .onLogout(context, widget.userCubit);
                            },
                            child: const Text(
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
            log('LOG > doctor_hub.dart > 139 > state: ${state.toString()}');
            currentState = state;
            print(state);
            eDetails = state.details[0];
            patientsLoaded = true;
          }
          if (state is HubRequestsLoaded) {
            log('LOG > doctor_hub.dart > 146 > state: ${state.toString()}');
            currentState = state;
            rDetails = state.details[0];
            log('LOG > doctor_hub.dart > 149 > rDetails: ${rDetails}');
            requestsLoaded = true;
          }
          if (state is TokenLoadedState) {
            log('LOG > doctor_hub.dart > 153 > state: ${state.toString()}');
            token = state.token;
            print("Inside TokensLoaded State");
            print(token);
          }
          if (currentState == null) {
            return Center(
              child: Container(color: Colors.white, child: Text('Loading')),
            );
          }

          return _buildUI(context);
        }, listener: (context, state) async {
          // if (state is LoadingState) {
          //   print("Loading State Called");
          //   _showLoader();
          // } else
          log('LOG > doctor_hub.dart > 165 > state: ${state.toString()}');
          if (state is ErrorState) {
            print("Error State Called");
            // _hideLoader();
          } else if (state is HubPatientsLoaded) {
            eDetails = state.details[0];
            patientsLoaded = true;
          } else if (state is HubRequestsLoaded) {
            currentState = state;
            rDetails = state.details[0];
            requestsLoaded = true;
          } else if (state is PatientAcceptedHub) {
            widget.mainCubit.fetchEmergencyDetails();
            widget.mainCubit.fetchHubRequests();
          } else if (state is TokenLoadedState) {
            token = state.token;
            print("Inside TokensLoaded State");
            print(token);
          } else if (state is AcceptState) {
            // _hideLoader();
            print("Accept State Called");
            await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text(
                      'Are you sure?',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                    content: const Text(
                      'Do you want to accept the patient?',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 15,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text(
                          'Cancel',
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          // make api for accept patient by Hub
                          widget.mainCubit.acceptPatientByHub(state.patientID);
                        },
                        child: const Text(
                          'Yes',
                        ),
                      ),
                    ],
                  ),
                ) ??
                false;
            //Create new state PatientAccepted by Hub
          }
          // else if (state is PatientAccepted) {
          //   // _hideLoader();
          //   print("Inside patient accepted by Doctor state");
          //   widget.mainCubit.fetchEmergencyDetails();
          // }
        }));
  }

  _buildUI(BuildContext buildContext) => Stack(children: [
        SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // patientsLoaded ? _buildPatientLoadedUI(context) : SizedBox(),
            // patientsLoaded ? _buildChatButton() : SizedBox(),
            _buildPatientLoadedUI(context),
            _buildChatButton(),
            requestsLoaded ? _buildRequestUI(buildContext) : SizedBox(),
          ]),
        ),
      ]);

  _buildChatButton() => InkWell(
        onTap: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CubitProvider<MainCubit>(
                      create: (_) => widget.mainCubit,
                      child: ChatPage(
                          eDetails.doctorDetails.name,
                          eDetails.doctorDetails.id,
                          eDetails.patientDetails.id,
                          token))));
          // widget.mainCubit.getAllHubDoctors();
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) =>
          //           PatientReportHistoryScreen(mainCubit: widget.mainCubit),
          //     ));
        },
        child: Container(
          width: SizeConfig.screenWidth,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              color: kPrimaryLightColor,
              borderRadius: BorderRadius.circular(20)),
          child: Text(
            eDetails.doctorDetails.name,
            style: TextStyle(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
      );

  _buildPatientLoadedUI(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (!_patientAccepted) _buildHeader(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            "Patient Information",
            style: TextStyle(fontSize: 24),
          ),
        ),
        _buildPatientDetails(eDetails),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            "Spoke Doctor Information",
            style: TextStyle(fontSize: 24),
          ),
        ),

        _buildSpokeDetails(eDetails),
        //Needs to be conditional
        _buildPatientReportButton(),
        _buildPatientExamButton(),
        _buildPatientReportHistoryButton(),
      ]);
  _buildRequestUI(BuildContext buildContext) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Requests",
          style: TextStyle(fontSize: 24),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            "Patient Information",
            style: TextStyle(fontSize: 24),
          ),
        ),
        _buildPatientDetails(rDetails),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            "Spoke Doctor Information",
            style: TextStyle(fontSize: 24),
          ),
        ),
        _buildSpokeDetails(rDetails),
        _buildAcceptRequestButton()
      ]);

  _buildHeader() => Container(
      color: Colors.green[400],
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: ListTile(
        leading: Icon(CupertinoIcons.person, color: Colors.white),
        title: Text(
          "No Patients Accepted Yet!!",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        subtitle: Text(
          "Keep an eye out for the Patients",
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ));

  _buildSpokeDetails(EDetails details) => Column(children: [
        Container(
          width: SizeConfig.screenWidth,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Text(
            "Spoke Doctor's Information",
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 18),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.red[100], borderRadius: BorderRadius.circular(20)),
          width: SizeConfig.screenWidth,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Name: "),
                  Text(details.doctorDetails.name),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Contact Number: "),
                  Text(details.doctorDetails.contactNumber),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Hospital: "),
                  Text(details.doctorDetails.hospital),
                ],
              ),
            ],
          ),
        ),
      ]);

  _buildPatientDetails(EDetails details) => Column(children: [
        Container(
          width: SizeConfig.screenWidth,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Text(
            "Patient's Information",
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 18),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.red[100], borderRadius: BorderRadius.circular(20)),
          width: SizeConfig.screenWidth,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Name: "),
                  Text(details.patientDetails.name),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Contact Number: "),
                  Text(details.patientDetails.contactNumber),
                ],
              ),
            ],
          ),
        ),
      ]);

  _buildPatientReportButton() => InkWell(
        onTap: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PatientReportScreen(
                  mainCubit: widget.mainCubit,
                  user: UserType.DOCTOR,
                  patientDetails: eDetails.patientDetails,
                ),
              ));
        },
        child: Container(
          width: SizeConfig.screenWidth,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              color: kPrimaryLightColor,
              borderRadius: BorderRadius.circular(20)),
          child: Text(
            "View/Update Patient's Medical Report",
            style: TextStyle(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
      );

  _buildAcceptRequestButton() => InkWell(
        onTap: () async {
          widget.mainCubit.acceptPatientByHub(rDetails.patientDetails.id);
          setState(() {
            requestsLoaded = false;
          });
        },
        child: Container(
          width: SizeConfig.screenWidth,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              color: kPrimaryLightColor,
              borderRadius: BorderRadius.circular(20)),
          child: Text(
            "Accept Request",
            style: TextStyle(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
      );

  _buildPatientExamButton() => InkWell(
        onTap: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PatientExamScreen(
                  mainCubit: widget.mainCubit,
                  patientDetails: eDetails.patientDetails,
                ),
              ));
        },
        child: Container(
          width: SizeConfig.screenWidth,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              color: kPrimaryLightColor,
              borderRadius: BorderRadius.circular(20)),
          child: Text(
            "View/Update Patient's Exam Report",
            style: TextStyle(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
      );

  _buildPatientReportHistoryButton() => InkWell(
        onTap: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PatientReportHistoryScreen(mainCubit: widget.mainCubit),
              ));
        },
        child: Container(
          width: SizeConfig.screenWidth,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            "View Patient's Medical Report History",
            style: TextStyle(color: kPrimaryColor, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
      );
}
