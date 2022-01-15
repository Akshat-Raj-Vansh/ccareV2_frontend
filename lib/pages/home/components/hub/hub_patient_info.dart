//@dart=2.9
import 'dart:developer';

import 'package:ccarev2_frontend/main/domain/edetails.dart';
import 'package:ccarev2_frontend/pages/chat/chatScreen.dart';
import 'package:ccarev2_frontend/pages/spoke_form/patient_exam_screen.dart';
import 'package:ccarev2_frontend/pages/spoke_form/patient_history_screen.dart';
import 'package:ccarev2_frontend/pages/spoke_form/patient_report_screen.dart';
import 'package:ccarev2_frontend/services/Notifications/notificationContoller.dart';
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/state_management/main/main_state.dart';
import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:ccarev2_frontend/user/domain/details.dart';
import 'package:ccarev2_frontend/utils/constants.dart';
import 'package:ccarev2_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_cubit/flutter_cubit.dart';

class HubPatientInfo extends StatefulWidget {
  final EDetails details;
  const HubPatientInfo({
    this.details,
  });

  @override
  _HubPatientInfoState createState() => _HubPatientInfoState();
}

class _HubPatientInfoState extends State<HubPatientInfo> {
  String token;

  @override
  void initState() {
    super.initState();

    CubitProvider.of<MainCubit>(context).fetchToken();
    NotificationController.configure(
        CubitProvider.of<MainCubit>(context), UserType.HUB, context);
    NotificationController.fcmHandler();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(widget.details.patientDetails.name),
          backgroundColor: kPrimaryColor,
          // actions: [
          //   IconButton(
          //     onPressed: () async {
          //       await showDialog(
          //             context: context,
          //             builder: (context) => AlertDialog(
          //               title: Text(
          //                 'Are you sure?',
          //                 style: TextStyle(
          //                   fontWeight: FontWeight.w600,
          //                   fontSize :16.sp,
          //                 ),
          //               ),
          //               content: Text(
          //                 'Do you want to logout?',
          //                 style: TextStyle(
          //                   fontWeight: FontWeight.w300,
          //                   fontSize :12.sp,
          //                 ),
          //               ),
          //               actions: [
          //                 TextButton(
          //                   onPressed: () => Navigator.of(context).pop(false),
          //                   child: Text(
          //                     'Cancel',
          //                   ),
          //                 ),
          //                 TextButton(
          //                   onPressed: () async {
          //                     widget.homePageAdapter
          //                         .onLogout(context, widget.userCubit);
          //                   },
          //                   child: Text(
          //                     'Yes',
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ) ??
          //           false;
          // },
          // icon: Icon(Icons.logout),
          // ),
          // ],
        ),
        body: CubitConsumer<MainCubit, MainState>(builder: (_, state) {
          if (state is TokenLoadedState) {
            log('LOG > doctor_hub.dart > 153 > state: ${state.toString()}');
            token = state.token;
            print("Inside TokensLoaded State");
            print(token);
          }

          return _buildPatientLoadedUI(context);
        }, listener: (context, state) async {
          // if (state is LoadingState) {
          //   print("Loading State Called");
          //   _showLoader();
          // } else
          log('LOG > doctor_hub.dart > 165 > state: ${state.toString()}');
          if (state is ErrorState) {
            print("Error State Called HUB PATIENT");
            // // _hideLoader();
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
                        fontSize :16.sp,
                      ),
                    ),
                    content: Text(
                      'Do you want to accept the patient?',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize :12.sp,
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
                          CubitProvider.of<MainCubit>(context)
                              .acceptPatientByHub(state.patientID);
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
          }
        }));
  }

  _buildChatButton() => InkWell(
        onTap: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (ctx) => CubitProvider<MainCubit>(
                      create: (_) => CubitProvider.of<MainCubit>(context),
                      child: ChatPage(
                          widget.details.doctorDetails.name,
                          widget.details.doctorDetails.id,
                          widget.details.patientDetails.id,
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
            widget.details.doctorDetails.name,
            style: TextStyle(color: Colors.white, fontSize :12.sp),
            textAlign: TextAlign.center,
          ),
        ),
      );

  _buildHeader() => Container(
      color: Colors.green[400],
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: ListTile(
        leading: Icon(CupertinoIcons.person, color: Colors.white),
        title: Text(
          "No Patients Accepted Yet!!",
          style: TextStyle(color: Colors.white, fontSize :16.sp),
        ),
        subtitle: Text(
          "Keep an eye out for the Patients",
          style: TextStyle(color: Colors.white, fontSize :8.sp),
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
            style: TextStyle(fontSize :14.sp),
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
              SizedBox(
                height: 1.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Contact Number: "),
                  Text(details.doctorDetails.contactNumber),
                ],
              ),
              SizedBox(
                height: 1.h,
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
            style: TextStyle(fontSize :14.sp),
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
              SizedBox(
                height: 1.h,
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
                builder: (_) => PatientReportScreen(
                  mainCubit: CubitProvider.of<MainCubit>(context),
                  user: UserType.DOCTOR,
                  patientDetails: widget.details.patientDetails,
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
            style: TextStyle(color: Colors.white, fontSize :12.sp),
            textAlign: TextAlign.center,
          ),
        ),
      );

  _buildPatientLoadedUI(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            "Patient Information",
            style: TextStyle(fontSize :18.sp),
          ),
        ),
        _buildPatientDetails(widget.details),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            "Spoke Doctor Information",
            style: TextStyle(fontSize :18.sp),
          ),
        ),

        _buildSpokeDetails(widget.details),
        //Needs to be conditional
        _buildPatientReportButton(),
        _buildPatientExamButton(),
        _buildChatButton(),
        _buildPatientReportHistoryButton(),
      ]);

  _buildPatientExamButton() => InkWell(
        onTap: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PatientExamScreen(
                  mainCubit: CubitProvider.of<MainCubit>(context),
                  patientDetails: widget.details.patientDetails,
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
            style: TextStyle(color: Colors.white, fontSize :12.sp),
            textAlign: TextAlign.center,
          ),
        ),
      );

  _buildPatientReportHistoryButton() => InkWell(
        onTap: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PatientReportHistoryScreen(
                    mainCubit: CubitProvider.of<MainCubit>(context)),
              ));
        },
        child: Container(
          width: SizeConfig.screenWidth,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            "View Patient's Medical Report History",
            style: TextStyle(color: kPrimaryColor, fontSize :12.sp),
            textAlign: TextAlign.center,
          ),
        ),
      );
}
