//@dart=2.9
import 'package:ccarev2_frontend/main/domain/edetails.dart';
import 'package:ccarev2_frontend/pages/home/home_page_adapter.dart';
import 'package:ccarev2_frontend/pages/spoke_form/patient_history_screen.dart';
import 'package:ccarev2_frontend/pages/spoke_form/patient_report_screen.dart';
import 'package:ccarev2_frontend/services/Notifications/notificationContoller.dart';
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/state_management/main/main_state.dart';
import 'package:ccarev2_frontend/state_management/user/user_cubit.dart';
import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:ccarev2_frontend/pages/questionnare/questionnare_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:location/location.dart' as lloc;
import 'package:ccarev2_frontend/user/domain/location.dart' as loc;
import 'package:ccarev2_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import '../../../pages/home/home_page_adapter.dart';
import '../../../pages/questionnare/questionnare_screen.dart';
import '../../../state_management/main/main_cubit.dart';
import '../../../state_management/main/main_state.dart';
import '../../../state_management/user/user_cubit.dart';
import '../../../utils/size_config.dart';
import '../../../utils/constants.dart';

class PatientHomeUI extends StatefulWidget {
  final MainCubit mainCubit;
  final UserCubit userCubit;
  final IHomePageAdapter homePageAdapter;
  const PatientHomeUI(this.mainCubit, this.userCubit, this.homePageAdapter);

  @override
  State<PatientHomeUI> createState() => _PatientHomeUIState();
}

class _PatientHomeUIState extends State<PatientHomeUI> {
  bool loader = false;
  EDetails eDetails;
  static bool _emergency = false;
  static bool _doctorAccepted = false;
  static bool _driverAccepted = false;
  static bool _notificationSent = false;
  static String _currentStatus = "UNKNOWN";
  dynamic currentState = null;
  @override
  void initState() {
    super.initState();
    CubitProvider.of<MainCubit>(context).fetchEmergencyDetails();
    NotificationController.configure(
        widget.mainCubit, UserType.PATIENT, context);
    NotificationController.fcmHandler();
  }

  Future<loc.Location> _getLocation() async {
    lloc.LocationData _locationData = await lloc.Location().getLocation();
    print(_locationData.latitude.toString() +
        "," +
        _locationData.longitude.toString());
    loc.Location _location = loc.Location(
        latitude: _locationData.latitude, longitude: _locationData.longitude);
    return _location;
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
      loader = false;
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('CardioCare - Patient'),
        backgroundColor: kPrimaryColor,
        actions: [
          // IconButton(
          //   onPressed: () async {
          //     _showLoader();
          //     loc.Location location = await _getLocation();
          //     _hideLoader();
          //     return widget.homePageAdapter
          //         .loadEmergencyScreen(context, UserType.PATIENT, location);
          //   },
          //   icon: Icon(FontAwesomeIcons.mapMarkedAlt),
          // ),
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
      body: CubitConsumer<MainCubit, MainState>(
        builder: (_, state) {
          if (state is DetailsLoaded) {
            currentState = DetailsLoaded;
            // _hideLoader();
            _notificationSent = true;
            eDetails = state.eDetails;
            _currentStatus = "EMERGENCY";
            _emergency = true;
            if (eDetails.doctorDetails != null) {
              _doctorAccepted = true;
              //    _emergency = true;
            }
            if (eDetails.driverDetails != null) {
              _driverAccepted = true;
              //   _emergency = true;
            }
          }
          //TODO: #1 create a new state if no emerency requests have been made
          if (state is NormalState) {
            currentState = NormalState;
            if (state.msg == "NOT ASSIGNED") _notificationSent = true;
          }
          if (currentState == null)
            return Center(child: CircularProgressIndicator());

          return _buildUI(context);
        },
        listener: (context, state) async {
          if (state is LoadingState) {
            print("Loading State Called");
            _showLoader();
          } else if (state is EmergencyState) {
            _hideLoader();
            _notificationSent = true;
            _emergency = true;
            _currentStatus = "EMERGENCY";
            print("Emergency State Called");
            _showMessage("Notifications sent to the Doctor and the Ambulance.");
          } else if (state is DetailsLoaded) {
            _hideLoader();
            //  _currentStatus = EDetails.patientDetails.status;
          } else if (state is NormalState) {
            _hideLoader();
            _showMessage(state.msg);
          } else if (state is ErrorState) {
            _hideLoader();
          } else if (state is QuestionnaireState) {
            print("Questionnaire State Called");
            _hideLoader();
            var cubit = CubitProvider.of<MainCubit>(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    SelfAssessment(state.questions, cubit, "homescreen"),
              ),
            );
          }
        },
      ),
    );
  }

  _buildUI(BuildContext context) => Stack(children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_notificationSent) _buildHeader(),
              if (_notificationSent && (!_doctorAccepted && !_driverAccepted))
                _buildNotificationSend(),
              if (_doctorAccepted || _driverAccepted)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    "Emergency Information",
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              if (_doctorAccepted || _driverAccepted)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Status:",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        _currentStatus,
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              if (_doctorAccepted) _buildDoctorDetails(),
              if (_driverAccepted) _buildDriverDetails(),
              _buildPatientReportButton(),
              _buildPatientReportHistoryButton(),
            ],
          ),
        ),
        _buildBottomUI(context)
      ]);

  _buildNotificationSend() => Container(
      color: kPrimaryLightColor,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ListTile(
        leading: Icon(CupertinoIcons.exclamationmark_shield,
            color: Colors.white, size: 40),
        title: Text(
          "Emergency Notification Sent!!",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        subtitle: Text(
          "Waiting for the confimation from Doctor's and Ambulance's side ->",
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ));

  _buildPatientReportButton() => InkWell(
        onTap: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PatientReportScreen(
                    mainCubit: widget.mainCubit, user: UserType.PATIENT),
              ));
        },
        child: Container(
          width: SizeConfig.screenWidth,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              color: kPrimaryLightColor,
              borderRadius: BorderRadius.circular(5)),
          child: Text(
            "View Patient's Medical Report",
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
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: kPrimaryColor)),
          child: Text(
            "View your Medical Report History",
            style: TextStyle(color: kPrimaryColor, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
      );

  _buildDoctorDetails() => Column(children: [
        Container(
          width: SizeConfig.screenWidth,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Text(
            "Doctor's Information",
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
                  Text(eDetails.doctorDetails.name),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Hospital: "),
                  Text(eDetails.doctorDetails.hospital),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Location: "),
                  Text(eDetails.doctorDetails.address == null ||
                          eDetails.doctorDetails.address == ""
                      ? "India"
                      : eDetails.doctorDetails.address),
                ],
              ),
            ],
          ),
        ),
      ]);

  _buildBottomUI(BuildContext context) => Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 80,
        width: SizeConfig.screenWidth,
        padding: const EdgeInsets.all(5.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          if (_currentStatus != "ATH")
            RaisedButton.icon(
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: () async {
                  print(_emergency);
                  if (!_emergency) {
                    _showAmbRequired();
                  } else {
                    // _showLoader();
                    // loc.Location location = await _getLocation();
                    // _hideLoader();
                    // return widget.homePageAdapter
                    //     .loadEmergencyScreen(context, UserType.PATIENT, location);
                    _updateStatus();
                  }
                },
                icon: Icon(
                  !_emergency ? Icons.phone : Icons.access_time,
                  color: Colors.white,
                ),
                label: Text(
                  !_emergency ? "Emergency" : "Change Status",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                )),
          RaisedButton.icon(
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onPressed: () async {
                CubitProvider.of<MainCubit>(context).getQuestions();
              },
              icon: Icon(
                FontAwesomeIcons.stethoscope,
                color: Colors.white,
              ),
              label: Text("Assess Again",
                  style: TextStyle(color: Colors.white, fontSize: 16)))
        ]),
      ));

  _updateStatus() {
    if (_currentStatus == "EMERGENCY") {
      _currentStatus = "OTW";
      return widget.mainCubit.statusUpdate("OTW");
    }
    _currentStatus = "ATH";
    return widget.mainCubit.statusUpdate("ATH");
  }

  _getNextStatus() {
    if (_currentStatus == "EMERGENCY")
      return "OTW";
    else
      "ATH";
  }

  _showAmbRequired() async {
    var alert = AlertDialog(
      title: Center(
        child: const Text(
          'Emergency',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      content: const Text(
        'Do you need an ambulance?',
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
            Navigator.of(context).pop(false);
            await widget.mainCubit.notify("EBUTTON", true);
            // await widget.mainCubit.fetchEmergencyDetails();
          },
          child: const Text(
            'Yes',
          ),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop(false);
            await widget.mainCubit.notify("QUESTIONNAIRE", false);
            // await widget.mainCubit.fetchEmergencyDetails();
          },
          child: const Text(
            'No',
          ),
        ),
      ],
    );
    showDialog(context: context, builder: (context) => alert);
  }

  _buildDriverDetails() => Column(children: [
        Container(
          width: SizeConfig.screenWidth,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Text(
            "Ambulance's Information",
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 18),
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
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Plate Number: "),
                  Text(eDetails.driverDetails.plateNumber),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Contact Number: "),
                  Text(eDetails.driverDetails.contactNumber),
                ],
              ),
              const SizedBox(
                height: 5,
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

  _buildEmergencyButton() => InkWell(
        onTap: () async {
          if (!_emergency)
            await widget.mainCubit.notify("EBUTTON", true);
          else {
            _showLoader();
            loc.Location location = await _getLocation();
            _hideLoader();
            return widget.homePageAdapter
                .loadEmergencyScreen(context, UserType.PATIENT, location);
          }
        },
        child: Container(
            color: Colors.red[400],
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: ListTile(
              leading: Icon(CupertinoIcons.exclamationmark_bubble,
                  color: Colors.white),
              title: Text(
                "Press here for Emergency Service!",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              subtitle: Text(
                "Emergency Situation ->",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            )),
      );

  _buildHeader() => Container(
      color: kPrimaryLightColor,
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: ListTile(
        leading: Icon(CupertinoIcons.person, color: Colors.white),
        title: Text(
          "You are healthy!!",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        subtitle: Text(
          "Medications and Ongoing treatment ->",
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ));
}
