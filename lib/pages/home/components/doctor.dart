//@dart=2.9
import 'package:ccarev2_frontend/main/domain/edetails.dart';
import 'package:ccarev2_frontend/pages/home/home_page_adapter.dart';
import 'package:ccarev2_frontend/services/Notifications/notificationContoller.dart';
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/state_management/main/main_state.dart';
import 'package:ccarev2_frontend/state_management/user/user_cubit.dart';
import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:ccarev2_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:location/location.dart' as lloc;
import 'package:ccarev2_frontend/user/domain/location.dart' as loc;

class DoctorHomeUI extends StatefulWidget {
  final MainCubit mainCubit;
  final UserCubit userCubit;
  final IHomePageAdapter homePageAdapter;
  const DoctorHomeUI(this.mainCubit, this.userCubit, this.homePageAdapter);

  @override
  State<DoctorHomeUI> createState() => _DoctorHomeUIState();
}

class _DoctorHomeUIState extends State<DoctorHomeUI> {
  EDetails eDetails;
  static bool _emergency = false;
  static bool _patientAccepted = false;
  static bool _driverAccepted = false;
  dynamic currentState = null;
  bool loader = false;
  List<String> res = [
    "Find Test centers",
    "Find Hospitals",
    "Find healthcare centres"
  ];
  List<String> patients = [
    "Alpha",
    "Beta",
    "Gamma",
    "Omega",
    "Theta",
  ];
  List<String> time_patients = [
    "6th Sept,2021",
    "4th Sept,2021",
    "3th Sept,2021",
    "3th Sept,2021",
    "1th Sept,2021"
  ];
  @override
  void initState() {
    super.initState();
    NotificationController.configure(
        widget.mainCubit, UserType.doctor, context);
    NotificationController.fcmHandler();
    CubitProvider.of<MainCubit>(context).fetchEmergencyDetails();
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

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return CubitConsumer<MainCubit, MainState>(builder: (_, state) {
      if (state is DetailsLoaded) {
        currentState = DetailsLoaded;
        eDetails = state.eDetails;
        if (eDetails.patientDetails != null) {
          _patientAccepted = true;
          _emergency = true;
        }
        if (eDetails.driverDetails != null) {
          _driverAccepted = true;
          _emergency = true;
        }
      }
      if (state is NormalState) {
        currentState = NormalState;
      }
      if (currentState == null)
        return Center(child: CircularProgressIndicator());
      return _buildUI(context);
    }, listener: (context, state) async {
      if (state is LoadingState) {
        print("Loading State Called");
        _showLoader();
      } else if (state is DetailsLoaded) {
        _hideLoader();
      } else if (state is AcceptState) {
        _hideLoader();
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
                    onPressed: () {
                      _hideLoader();
                      widget.mainCubit.acceptPatientByDoctor(state.patientID);
                    },
                    child: const Text(
                      'Yes',
                    ),
                  ),
                ],
              ),
            ) ??
            false;
      } else if (state is PatientAccepted) {
        _hideLoader();
        _emergency = true;
        print("Inside patient accepted by Doctor state");
        // loc.Location location = await _getLocation();
        // widget.homePageAdapter
        //     .loadEmergencyScreen(context, UserType.doctor, location);
      } else if (state is AllPatientsState) {
        print("AllPatientsState State Called");
        _hideLoader();
      }
    });
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

  _buildUI(BuildContext buildContext) => Scaffold(
        appBar: AppBar(
          title: Text('CardioCare - Doctor'),
          actions: [
            // if (_isEmergency)
            IconButton(
              onPressed: () async {
                _showLoader();
                loc.Location location = await _getLocation();
                _hideLoader();
                return widget.homePageAdapter
                    .loadEmergencyScreen(context, UserType.doctor, location);
              },
              icon: Icon(Icons.map),
            ),
            IconButton(
              onPressed: () =>
                  widget.homePageAdapter.onLogout(context, widget.userCubit),
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        body: Stack(children: [
          SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (_patientAccepted || _driverAccepted)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    "Emergency Information",
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              if (_patientAccepted) _buildPatientDetails(),
              if (_driverAccepted) _buildDriverDetails(),
              if (!_emergency) _buildHeader(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  "Patients",
                  style: TextStyle(fontSize: 24),
                ),
              ),
              _buildMedications(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  "Useful Resources",
                  style: TextStyle(fontSize: 24),
                ),
              ),
              _buildResources(),
            ]),
          ),
        ]),
      );
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
                  // Text("Akshat Raj Vansh"),
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
                  // Text("MH-177035"),
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
                  // Text("+91 7355026029"),
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
  _buildPatientDetails() => Column(children: [
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
                  // Text("Akshat Raj Vansh"),
                  Text(eDetails.patientDetails.name),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Contact Number: "),
                  // Text("Apollo Medical Hospital"),
                  Text(eDetails.patientDetails.contactNumber),
                ],
              ),
            ],
          ),
        ),
      ]);
  _buildEmergencyButton() => InkWell(
        onTap: () async {
          _showLoader();
          loc.Location location = await _getLocation();
          _hideLoader();
          return widget.homePageAdapter
              .loadEmergencyScreen(context, UserType.patient, location);
        },
        child: Container(
            color: Colors.red[400],
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: ListTile(
              leading: Icon(CupertinoIcons.exclamationmark_bubble,
                  color: Colors.white),
              title: Text(
                "Press here for Patient's and Driver's Location!",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              subtitle: Text(
                "Emergency Situation ->",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            )),
      );

  _buildHeader() => Container(
      color: Colors.green[400],
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: ListTile(
        leading: Icon(CupertinoIcons.person, color: Colors.white),
        title: Text(
          "All Current Patients are recovering!!",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        subtitle: Text(
          "Medications and Ongoing treatment ->",
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ));

  _buildResources() => Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: SizeConfig.screenWidth,
      height: 200,
      child: ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: res.length,
          separatorBuilder: (context, index) => SizedBox(height: 10),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                  color: Colors.lightBlue[100],
                  borderRadius: BorderRadius.circular(20)),
              child: ListTile(
                  leading: Text(res[index], style: TextStyle(fontSize: 16))),
            );
          }));

  _buildMedications() => Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: 350,
      width: SizeConfig.screenWidth,
      child: ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: patients.length,
          separatorBuilder: (context, index) => SizedBox(height: 10),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                  color: Colors.lightBlue[100],
                  borderRadius: BorderRadius.circular(20)),
              child: ListTile(
                leading: Text(patients[index], style: TextStyle(fontSize: 16)),
                trailing:
                    Text(time_patients[index], style: TextStyle(fontSize: 16)),
              ),
            );
          }));
}
