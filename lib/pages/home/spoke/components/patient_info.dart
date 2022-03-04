//@dart=2.9
import 'dart:developer';

import 'package:ccarev2_frontend/pages/home/home_page_adapter.dart';
import 'package:ccarev2_frontend/pages/home/hub/components/hub_response.dart';
import 'package:ccarev2_frontend/pages/home/spoke/components/hub_list.dart';
import 'package:ccarev2_frontend/pages/questionnare/assessment_screen.dart';
import 'package:flutter/material.dart';

import 'package:ccarev2_frontend/main/domain/edetails.dart';
import 'package:ccarev2_frontend/pages/chat/chatScreen.dart';
import 'package:ccarev2_frontend/pages/spoke_form/patient_exam_screen.dart';
import 'package:ccarev2_frontend/pages/spoke_form/patient_history_screen.dart';
import 'package:ccarev2_frontend/pages/spoke_form/patient_report_screen.dart';
import 'package:ccarev2_frontend/services/Notifications/notificationContoller.dart';
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/state_management/main/main_state.dart';
import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:ccarev2_frontend/utils/constants.dart';
import 'package:ccarev2_frontend/utils/size_config.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PatientInfo extends StatefulWidget {
  final String patientID;
  final MainCubit mainCubit;

  final IHomePageAdapter homePageAdapter;

  const PatientInfo(
      {Key key, this.patientID, this.mainCubit, this.homePageAdapter})
      : super(key: key);

  @override
  _PatientInfoState createState() => _PatientInfoState();
}

class _PatientInfoState extends State<PatientInfo> {
  EDetails eDetails;
  bool _emergency = false;
  bool _patientAccepted = false;
  bool _driverAccepted = false;
  bool _hubAccepted = false;
  bool _ugt = false;
  String _currentStatus = "UNKNOWN";
  dynamic currentState = null;
  String token;
  bool loader = false;

  @override
  void initState() {
    super.initState();
    widget.mainCubit.patientInfoLoading();
    // widget.mainCubit.fetchEmergencyDetails(patientID: widget.patientID);
    NotificationController.configure(widget.mainCubit, UserType.SPOKE, context);
    NotificationController.fcmHandler();
    widget.mainCubit.fetchToken();
  }

  @override
  void dispose() {
    print("Disposing");
    eDetails = null;
    _emergency = false;
    _patientAccepted = false;
    _driverAccepted = false;
    _hubAccepted = false;
    _ugt = false;
    _currentStatus = "UNKNOWN";
    currentState = null;
    token = null;
    loader = false;
    super.dispose();
  }

  // Future<loc.Location> _getLocation() async {
  //   lloc.LocationData _locationData = await lloc.Location().getLocation();
  //   //print(_locationData.latitude.toString() +
  //       "," +
  //       _locationData.longitude.toString());
  //   loc.Location _location = loc.Location(
  //       latitude: _locationData.latitude, longitude: _locationData.longitude);
  //   return _location;
  // }

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
    if (loader) {
      Navigator.of(context, rootNavigator: true).pop();
      loader = false;
    }
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
        title: Text('CardioCare - SPOKE'),
        backgroundColor: kPrimaryColor,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop(false);
              // widget.homePageAdapter.loadHomeUI(context, UserType.SPOKE);
            },
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: CubitConsumer<MainCubit, MainState>(
        cubit: widget.mainCubit,
        builder: (_, state) {
          print("PatientInfo Builder state: $state");
          if (state is PatientInfoLoadingState) {
            // _showLoader();
            widget.mainCubit.fetchEmergencyDetails(patientID: widget.patientID);
          }
          if (state is TokenLoadedState) {
            token = state.token;
          }
          if (state is DetailsLoaded) {
            //       _hideLoader();
            currentState = DetailsLoaded;
            eDetails = state.eDetails;
            print(eDetails);
            if (eDetails.patientDetails != null) {
              _patientAccepted = true;
              _emergency = true;
              _currentStatus =
                  eDetails.patientDetails.status.toString().split('.')[1];
              if (eDetails.patientDetails.status == EStatus.UGT) {
                _ugt = true;
              }
            }
            if (eDetails.driverDetails != null) {
              _driverAccepted = true;
              _emergency = true;
            }
            if (eDetails.hubDetails != null) {
              _hubAccepted = true;
            }
          }

          if (state is NormalState) {
            //   // _hideLoader();
            currentState = NormalState;
          }
          if (currentState == null)
            return Center(child: CircularProgressIndicator());
          return _buildUI(context);
        },
        listener: (context, state) async {
          print("PatientInfo Listner state: $state");
          if (state is LoadingState) {
            //print("Loading State Called Patient Info");
            log('LOG > doctor_spoke.dart > 197 > state: ${state.toString()}');
            //  _showLoader();
          } else if (state is NormalState) {
            _hideLoader();
          } else if (state is ErrorState) {
            // _hideLoader();
            log('LOG > doctor_spoke.dart > 204 > state: ${state.toString()}');
          } else if (state is TokenLoadedState) {
            token = state.token;
          } else if (state is AssessmentLoaded) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return AssessmentScreen(state.assessments);
            }));
          } else if (state is StatusFetched) {
            setState(() {});
          }

          if (state is NewReportGenerated) {
            // _hideLoader();
            log('LOG > doctor_spoke.dart > 212 > state: ${state.toString()}');
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => PatientReportScreen(
            //         widget.mainCubit: widget.widget.mainCubit,
            //         user: UserType.DOCTOR,
            //         patientDetails: eDetails.patientDetails,
            //       ),
            //     ));theek hsintheek hsin
            _showMessage(state.msg);
          } else if (state is PatientAcceptedHub) {
            _hideLoader();
            widget.mainCubit.fetchEmergencyDetails(patientID: widget.patientID);
          } else if (state is AllHubDoctorsState) {
            _hideLoader();
            log('LOG > doctor_spoke.dart > 223 > state: ${state.toString()}',
                time: DateTime.now());
            showModalBottomSheet(
                context: context,
                builder: (_) {
                  return HubDoctorsList(
                      state.docs, widget.mainCubit, widget.patientID);
                });
          } else if (state is ConsultHub) {
            _hideLoader();
            log('LOG > doctor_spoke.dart > 231 > state: ${state.toString()}',
                time: DateTime.now());
          } else if (state is AcceptState) {
            // _hideLoader();
            log('LOG > doctor_spoke.dart > 237 > state: ${state.toString()}',
                time: DateTime.now());
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
                          widget.mainCubit
                              .acceptPatientBySpoke(state.patientID);
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
          } else if (state is PatientAccepted) {
            // _hideLoader();
            _emergency = true;
            log('LOG > doctor_spoke.dart > 280 > state: ${state.toString()}',
                time: DateTime.now());
            widget.mainCubit.fetchEmergencyDetails(patientID: widget.patientID);
          } else if (state is AllPatientsState) {
            log('LOG > doctor_spoke.dart > 284 > state: ${state.toString()}',
                time: DateTime.now());
            // _hideLoader();
          } else if (state is CaseClosedState) {
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
                      'Do you want to close the current treatment session?',
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
                          _showMessage(
                              'The Treatment for the Patient has been completed.');
                          setState(() {
                            _emergency = false;
                            _patientAccepted = false;
                            _driverAccepted = false;
                            _hubAccepted = false;
                            _ugt = false;
                            _currentStatus = "NORMAL";
                          });
                          Navigator.of(context).pop(false);
                          Navigator.of(context).pop(true);
                          widget.mainCubit.getAllPatients();
                        },
                        child: Text(
                          'Yes',
                        ),
                      ),
                    ],
                  ),
                ) ??
                false;
          }
        },
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: kPrimaryColor,
              ),
              child: Text('CardioCare - Spoke'),
            ),
            ListTile(
              title: Text('My Profile'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('My Patients'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Consultation'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  _buildUI(BuildContext buildContext) => Stack(children: [
        SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (_patientAccepted || _driverAccepted)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  "Emergency Information",
                  style: TextStyle(fontSize: 18.sp),
                ),
              ),
            if (_patientAccepted)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Status:",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    Text(
                      _currentStatus,
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            if (_patientAccepted && _currentStatus == "ATH")
              _buildStartTreatmentButton(),
            if (_patientAccepted) _buildPatientDetails(),
            if (_patientAccepted &&
                eDetails.patientDetails.action == "QUESTIONNAIRE")
              _buildPatientAssessmentButton(),
            if (_patientAccepted && _ugt) _buildPatientReportButton(),
            if (_patientAccepted && _ugt) _buildPatientExamButton(),
            if (_patientAccepted && _ugt && !_hubAccepted) _buildHubList(),
            if (_hubAccepted) _buildChatButton(),
            if (_hubAccepted) _buildResponseButton(),
            if (_patientAccepted && _ugt) _buildNewReportButton(),
            if (_patientAccepted && _ugt) _buildPatientReportHistoryButton(),
            if (_patientAccepted && _ugt) _buildEndTreatmentButton(),
            if (_driverAccepted) _buildDriverDetails(),
            if (!_emergency) _buildHeader(),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //   child: Text(
            //     "Patients",
            //     style: TextStyle(fontSize :18.sp),
            //   ),
            // ),
            // _buildMedications(),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //   child: Text(
            //     "Useful Resources",
            //     style: TextStyle(fontSize :18.sp),
            //   ),
            // ),
            // _buildResources(),
          ]),
        ),
      ]);

  _buildHeader() => Container(
      color: Colors.green[400],
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: ListTile(
        leading: Icon(CupertinoIcons.person, color: Colors.white),
        title: Text(
          "All Current Patients are recovering!!",
          style: TextStyle(color: Colors.white, fontSize: 16.sp),
        ),
        subtitle: Text(
          "Medications and Ongoing treatment ->",
          style: TextStyle(color: Colors.white, fontSize: 8.sp),
        ),
      ));

  _buildPatientDetails() => Column(children: [
        Container(
          width: SizeConfig.screenWidth,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Text(
            "Patient's Information",
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 14.sp),
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
                  Text(eDetails.patientDetails.name),
                ],
              ),
              SizedBox(
                height: 1.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Contact Number: "),
                  Text(eDetails.patientDetails.contactNumber),
                ],
              ),
            ],
          ),
        ),
      ]);

  _buildPatientAssessmentButton() => InkWell(
        onTap: () async {
          CubitProvider.of<MainCubit>(context).getAssessments(widget.patientID);
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

  _buildStartTreatmentButton() => InkWell(
        onTap: () async {
          widget.mainCubit.statusUpdate("UGT", patientID: widget.patientID);
          _currentStatus = "UGT";
          _ugt = true;
        },
        child: Container(
          width: SizeConfig.screenWidth,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: kPrimaryColor)),
          child: Text(
            "Start treatment of the Patient",
            style: TextStyle(color: kPrimaryColor, fontSize: 12.sp),
            textAlign: TextAlign.center,
          ),
        ),
      );
  _buildResponseButton() => InkWell(
        onTap: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (cTX) => ResponseScreen(
                  mainCubit: widget.mainCubit,
                  user: UserType.SPOKE,
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
            "HUB Consulatation Response",
            style: TextStyle(color: Colors.white, fontSize: 12.sp),
            textAlign: TextAlign.center,
          ),
        ),
      );

  _buildPatientReportButton() => InkWell(
        onTap: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (cTX) => PatientReportScreen(
                  mainCubit: widget.mainCubit,
                  user: UserType.SPOKE,
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
            style: TextStyle(color: Colors.white, fontSize: 12.sp),
            textAlign: TextAlign.center,
          ),
        ),
      );

  _buildPatientExamButton() => InkWell(
        onTap: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => PatientExamScreen(
                  mainCubit: widget.mainCubit,
                  patientDetails: eDetails.patientDetails,
                  user: UserType.SPOKE,
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
                builder: (ctx) => PatientReportHistoryScreen(
                  mainCubit: widget.mainCubit,
                  patientID: widget.patientID,
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

  _buildHubList() => InkWell(
        onTap: () async {
          widget.mainCubit.getAllHubDoctors();
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) =>
          //           PatientReportHistoryScreen(widget.mainCubit: widget.widget.mainCubit),
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
            "Consultations",
            style: TextStyle(color: Colors.white, fontSize: 12.sp),
            textAlign: TextAlign.center,
          ),
        ),
      );
  _buildChatButton() => InkWell(
        onTap: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (cTX) => ChatPage(
                      eDetails.hubDetails.name,
                      eDetails.hubDetails.id,
                      eDetails.patientDetails.id,
                      token,
                      widget.mainCubit)));
          // widget.widget.mainCubit.getAllHubDoctors();
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) =>
          //           PatientReportHistoryScreen(widget.mainCubit: widget.widget.mainCubit),
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
            eDetails.hubDetails.name,
            style: TextStyle(color: Colors.white, fontSize: 12.sp),
            textAlign: TextAlign.center,
          ),
        ),
      );

  _buildNewReportButton() => InkWell(
        onTap: () async {
          widget.mainCubit.generateNewReport(widget.patientID);
        },
        child: Container(
          width: SizeConfig.screenWidth,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kPrimaryColor)),
          child: Text(
            "Create New Report",
            style: TextStyle(color: kPrimaryColor, fontSize: 12.sp),
            textAlign: TextAlign.center,
          ),
        ),
      );
  _buildEndTreatmentButton() => InkWell(
        onTap: () async {
          widget.mainCubit.caseClose(widget.patientID);
        },
        child: Container(
          width: SizeConfig.screenWidth,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kPrimaryColor)),
          child: Text(
            "End Current Treatment",
            style: TextStyle(color: kPrimaryColor, fontSize: 12.sp),
            textAlign: TextAlign.center,
          ),
        ),
      );

  _buildDriverDetails() => Column(children: [
        Container(
          width: SizeConfig.screenWidth,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Text(
            "Ambulance's Information",
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 14.sp),
          ),
        ),
        Container(
            decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(20)),
            width: SizeConfig.screenWidth,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Name: "),
                  Text(eDetails.driverDetails.name),
                ],
              ),
              SizedBox(
                height: 1.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Plate Number: "),
                  Text(eDetails.driverDetails.plateNumber),
                ],
              ),
              SizedBox(
                height: 1.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Contact Number: "),
                  Text(eDetails.driverDetails.contactNumber),
                ],
              ),
              SizedBox(
                height: 1.h,
              ),
              RichText(
                text: TextSpan(
                  text: "Location : ",
                  style: GoogleFonts.montserrat(color: Colors.black),
                  children: [
                    TextSpan(
                        text: eDetails.driverDetails.address,
                        style: TextStyle(color: Colors.black))
                  ],
                ),
              ),
            ])),
      ]);

  // _buildResources() => Container(
  //     padding: EdgeInsets.symmetric(horizontal: 20),
  //     width: SizeConfig.screenWidth,
  //     height: 200,
  //     child: ListView.separated(
  //         physics: NeverScrollableScrollPhysics(),
  //         shrinkWrap: true,
  //         itemCount: res.length,
  //         separatorBuilder: (context, index) => SizedBox(height: 10),
  //         itemBuilder: (context, index) {
  //           return Container(
  //             decoration: BoxDecoration(
  //                 color: Colors.lightBlue[100],
  //                 borderRadius: BorderRadius.circular(20)),
  //             child: ListTile(
  //                 leading: Text(res[index], style: TextStyle(fontSize :12.sp))),
  //           );
  //         }));

  // _buildMedications() => Container(
  //     padding: EdgeInsets.symmetric(horizontal: 20),
  //     height: 350,
  //     width: SizeConfig.screenWidth,
  //     child: ListView.separated(
  //         physics: NeverScrollableScrollPhysics(),
  //         shrinkWrap: true,
  //         itemCount: patients.length,
  //         separatorBuilder: (context, index) => SizedBox(height: 10),
  //         itemBuilder: (context, index) {
  //           return Container(
  //             decoration: BoxDecoration(
  //                 color: Colors.lightBlue[100],
  //                 borderRadius: BorderRadius.circular(20)),
  //             child: ListTile(
  //               leading: Text(patients[index], style: TextStyle(fontSize :12.sp)),
  //               trailing:
  //                   Text(time_patients[index], style: TextStyle(fontSize :12.sp)),
  //             ),
  //           );
  //         }));
}
