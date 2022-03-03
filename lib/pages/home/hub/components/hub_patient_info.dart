//@dart=2.9
import 'dart:developer';

import 'package:ccarev2_frontend/main/domain/edetails.dart';
import 'package:ccarev2_frontend/pages/chat/chatScreen.dart';
import 'package:ccarev2_frontend/pages/questionnare/assessment_screen.dart';
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
  final MainCubit mainCubit;
  const HubPatientInfo({this.details, this.mainCubit});

  @override
  _HubPatientInfoState createState() => _HubPatientInfoState();
}

class _HubPatientInfoState extends State<HubPatientInfo> {
  static String token;

  @override
  void initState() {
    super.initState();

    widget.mainCubit.fetchToken();
    NotificationController.configure(widget.mainCubit, UserType.HUB, context);
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
        ),
        body: CubitConsumer<MainCubit, MainState>(
            cubit: widget.mainCubit,
            builder: (_, state) {
              print("state is $state");
              if (state is TokenLoadedState) {
                log('LOG > doctor_hub.dart > 153 > state: ${state.toString()}');
                token = state.token;
                //print("Inside TokensLoaded State");
                //print(token);
              }

              return _buildPatientLoadedUI(context);
            },
            listener: (context, state) async {
              log('LOG > doctor_hub.dart > 165 > state: ${state.toString()}');
              print(" Listener state is $state");
              if (state is ErrorState) {
                //print("Error State Called HUB PATIENT");
                // // _hideLoader();
              } else if (state is TokenLoadedState) {
                token = state.token;
                //print("Inside TokensLoaded State");
                //print(token);
              } else if (state is AssessmentLoaded) {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return AssessmentScreen(state.assessments);
                }));
              } else if (state is AcceptState) {
                // // _hideLoader();
                //print("Accept State Called");
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
                              widget.mainCubit
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
          print('Patient ID from Hub: ' + widget.details.patientDetails.id);
          print('Token from Hub: ' + token);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (ctx) => ChatPage(
                      widget.details.doctorDetails.name,
                      widget.details.doctorDetails.id,
                      widget.details.patientDetails.id,
                      token,
                      widget.mainCubit)));
          // widget.mainCubit.getAllHubDoctors();
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (ctx) => ChatPage(
          //         widget.details.doctorDetails.name,
          //         widget.details.doctorDetails.id,
          //         widget.details.patientDetails.id,
          //         token),
          //   ),
          // );
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
            style: TextStyle(color: Colors.white, fontSize: 12.sp),
            textAlign: TextAlign.center,
          ),
        ),
      );
  _buildPatientAssessmentButton() => InkWell(
        onTap: () async {
          CubitProvider.of<MainCubit>(context)
              .getAssessments(widget.details.patientDetails.id);
        },
        child: Container(
          width: SizeConfig.screenWidth,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              color: kPrimaryLightColor,
              borderRadius: BorderRadius.circular(5)),
          child: Text(
            "View Patient's Self-Assessment Report",
            style: TextStyle(color: Colors.white, fontSize: 12.sp),
            textAlign: TextAlign.center,
          ),
        ),
      );
  _buildSpokeDetails(EDetails details) => Column(children: [
        // Container(
        //   width: SizeConfig.screenWidth,
        //   margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        //   child: Text(
        //     "Spoke Doctor's Information",
        //     textAlign: TextAlign.left,
        //     style: TextStyle(fontSize: 14.sp),
        //   ),
        // ),
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
        // Container(
        //   width: SizeConfig.screenWidth,
        //   margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        //   child: Text(
        //     "Patient's Information",
        //     textAlign: TextAlign.left,
        //     style: TextStyle(fontSize: 14.sp),
        //   ),
        // ),
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
                  mainCubit: widget.mainCubit,
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
            style: TextStyle(color: Colors.white, fontSize: 12.sp),
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
            style: TextStyle(fontSize: 18.sp),
          ),
        ),
        _buildPatientDetails(widget.details),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            "Spoke Doctor Information",
            style: TextStyle(fontSize: 18.sp),
          ),
        ),

        _buildSpokeDetails(widget.details),
        //Needs to be conditional
        if (widget.details.patientDetails.action == "QUESTIONNAIRE")
          _buildPatientAssessmentButton(),
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
                  mainCubit: widget.mainCubit,
                  patientDetails: widget.details.patientDetails,
                  user: UserType.HUB,
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
            style: TextStyle(color: Colors.white, fontSize: 12.sp),
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
                  mainCubit: widget.mainCubit,
                  patientID: widget.details.patientDetails.id,
                ),
              ));
        },
        child: Container(
          width: SizeConfig.screenWidth,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            "View Patient's Medical Report History",
            style: TextStyle(color: kPrimaryColor, fontSize: 12.sp),
            textAlign: TextAlign.center,
          ),
        ),
      );
}
