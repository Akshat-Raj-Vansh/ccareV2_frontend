//@dart=2.9
import 'package:ccarev2_frontend/main/domain/edetails.dart';
import 'package:ccarev2_frontend/pages/home/home_page_adapter.dart';
import 'package:ccarev2_frontend/pages/spoke_form/patient_exam_screen.dart';
import 'package:ccarev2_frontend/pages/spoke_form/patient_history_screen.dart';
import 'package:ccarev2_frontend/pages/spoke_form/patient_report_screen.dart';
import 'package:ccarev2_frontend/services/Notifications/notificationContoller.dart';
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/state_management/main/main_state.dart';
import 'package:ccarev2_frontend/state_management/user/user_cubit.dart';
import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:ccarev2_frontend/utils/constants.dart';
import 'package:ccarev2_frontend/utils/size_config.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreenSpoke extends StatefulWidget {
  final MainCubit mainCubit;
  final UserCubit userCubit;
  final IHomePageAdapter homePageAdapter;

  const HomeScreenSpoke(this.mainCubit, this.userCubit, this.homePageAdapter);

  @override
  _HomeScreenSpokeState createState() => _HomeScreenSpokeState();
}

class _HomeScreenSpokeState extends State<HomeScreenSpoke> {
  EDetails eDetails;
  static bool _emergency = false;
  static bool _patientAccepted = false;
  static bool _driverAccepted = false;
  dynamic currentState = null;
  bool loader = false;

  @override
  void initState() {
    super.initState();
    CubitProvider.of<MainCubit>(context).fetchEmergencyDetails();
    NotificationController.configure(
        widget.mainCubit, UserType.DOCTOR, context);
    NotificationController.fcmHandler();
  }

  // Future<loc.Location> _getLocation() async {
  //   lloc.LocationData _locationData = await lloc.Location().getLocation();
  //   print(_locationData.latitude.toString() +
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
        title: Text('CardioCare - Doctor'),
        backgroundColor: kPrimaryColor,
        actions: [
          // IconButton(
          //   onPressed: () async {
          //     // _showLoader();
          //     // loc.Location location = await _getLocation();
          //     // _hideLoader();
          //     // return widget.homePageAdapter
          //     //     .loadEmergencyScreen(context, UserType.doctor, location);
          //     _showMessage("View location of Patient and Ambulance?");
          //   },
          //   icon: Icon(Icons.map),
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
        },
        listener: (context, state) async {
          if (state is LoadingState) {
            print("Loading State Called");
            _showLoader();
          } else if (state is ErrorState) {
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
                        onPressed: () async {
                          widget.mainCubit
                              .acceptPatientBySpoke(state.patientID);
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
            CubitProvider.of<MainCubit>(context).fetchEmergencyDetails();
          } else if (state is AllPatientsState) {
            print("AllPatientsState State Called");
            _hideLoader();
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
                color: Colors.blue,
              ),
              child: Text('CardioCare - Hub'),
            ),
            ListTile(
              title: const Text('My Profile'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('My Patients'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Consultation'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Settings'),
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
                  style: TextStyle(fontSize: 24),
                ),
              ),
            if (_patientAccepted) _buildPatientDetails(),
            if (_patientAccepted) _buildPatientReportButton(),
            if (_patientAccepted) _buildPatientExamButton(),
            if (_patientAccepted) _buildPatientReportHistoryButton(),
            if (_driverAccepted) _buildDriverDetails(),
            if (!_emergency) _buildHeader(),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //   child: Text(
            //     "Patients",
            //     style: TextStyle(fontSize: 24),
            //   ),
            // ),
            // _buildMedications(),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //   child: Text(
            //     "Useful Resources",
            //     style: TextStyle(fontSize: 24),
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
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        subtitle: Text(
          "Medications and Ongoing treatment ->",
          style: TextStyle(color: Colors.white, fontSize: 12),
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
                  Text(eDetails.patientDetails.contactNumber),
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
  //                 leading: Text(res[index], style: TextStyle(fontSize: 16))),
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
  //               leading: Text(patients[index], style: TextStyle(fontSize: 16)),
  //               trailing:
  //                   Text(time_patients[index], style: TextStyle(fontSize: 16)),
  //             ),
  //           );
  //         }));
}
