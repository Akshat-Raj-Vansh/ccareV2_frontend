//@dart=2.9
import 'dart:developer';

import 'package:ccarev2_frontend/main/domain/edetails.dart';
import 'package:ccarev2_frontend/pages/chat/chatScreen.dart';
import 'package:ccarev2_frontend/pages/chat/components/chatModel.dart';
import 'package:ccarev2_frontend/pages/home/spoke/components/add_patient.dart';
import 'package:ccarev2_frontend/pages/home/spoke/components/hub_list.dart';
import 'package:sizer/sizer.dart';
import 'package:ccarev2_frontend/pages/home/spoke/components/patient_info.dart';
import 'package:ccarev2_frontend/pages/home/spoke/components/patient_list.dart';
import 'package:ccarev2_frontend/pages/home/home_page_adapter.dart';
import 'package:ccarev2_frontend/pages/spoke_form/patient_exam_screen.dart';
import 'package:ccarev2_frontend/pages/spoke_form/patient_history_screen.dart';
import 'package:ccarev2_frontend/pages/spoke_form/patient_report_screen.dart';
import 'package:ccarev2_frontend/services/Notifications/notificationContoller.dart';
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/state_management/main/main_state.dart';
import 'package:ccarev2_frontend/state_management/user/user_cubit.dart';
import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:ccarev2_frontend/user/domain/patient_list_info.dart';
import 'package:ccarev2_frontend/utils/constants.dart';
import 'package:ccarev2_frontend/utils/size_config.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../questionnare/assessment_screen.dart';

class HomeScreenSpoke extends StatefulWidget {
  final MainCubit mainCubit;
  final UserCubit userCubit;
  final IHomePageAdapter homePageAdapter;

  const HomeScreenSpoke(this.mainCubit, this.userCubit, this.homePageAdapter);

  @override
  _HomeScreenSpokeState createState() => _HomeScreenSpokeState();
}

class _HomeScreenSpokeState extends State<HomeScreenSpoke> {
  dynamic currentState;
  String token;
  List<PatientListInfo> _patients = [];
  List<PatientListInfo> _requests = [];
  bool loader = false;

  @override
  void initState() {
    super.initState();
    CubitProvider.of<MainCubit>(context).getAllPatients();
    CubitProvider.of<MainCubit>(context).getAllPatientRequests();
    NotificationController.configure(widget.mainCubit, UserType.SPOKE, context);
    NotificationController.fcmHandler();
    CubitProvider.of<MainCubit>(context).fetchToken();
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
    if (loader = true) {
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
      ),
      body: CubitConsumer<MainCubit, MainState>(
        builder: (_, state) {
          if (state is PatientsLoaded) {
            //  // _hideLoader();
            currentState = PatientsLoaded;
            _patients = state.patients;
            //print(_patients);
          }
          if (state is RequestsLoaded) {
            //  // _hideLoader();
            currentState = RequestsLoaded;
            _requests = state.req;
            //print(_requests);
          }
          // if (state is TokenLoadedState) {
          //   token = state.token;
          // }
          // if (state is DetailsLoaded) {
          //   currentState = DetailsLoaded;
          //   eDetails = state.eDetails;
          //   if (eDetails.patientDetails != null) {
          //     _patientAccepted = true;
          //     _emergency = true;
          //     _currentStatus =
          //         eDetails.patientDetails.status.toString().split('.')[1];
          //     if (eDetails.patientDetails.status == EStatus.UGT) {
          //       _ugt = true;
          //     }
          //   }
          //   if (eDetails.driverDetails != null) {
          //     _driverAccepted = true;
          //     _emergency = true;
          //   }
          //   if (eDetails.hubDetails != null) {
          //     _hubAccepted = true;
          //   }
          // }

          // if (state is NormalState) {
          //     // _hideLoader();
          //   currentState = NormalState;
          // }
          if (currentState == null)
            return Container(
                color: Colors.white,
                child: Center(child: CircularProgressIndicator()));
          return _buildUI(context);
        },
        listener: (context, state) async {
          print("Auth Page State $state");

          if (state is NormalState) {
            _hideLoader();
            // currentState = NormalState;
          }
          if (state is LoadingState) {
            //print("Loading State Called Doctor Spoke");
            log('LOG > doctor_spoke.dart > 197 > state: ${state.toString()}');
            _showLoader();
          } else if (state is ConsultHub) {
            _hideLoader();
          } else if (state is AllHubDoctorsState) {
            _hideLoader();
          } else if (state is TokenLoadedState) {
            token = state.token;
          } else if (state is AssessmentLoaded) {
            _hideLoader();
          } else if (state is AcceptState) {
            _hideLoader();
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
          } else if (state is ShowNotificationDialogState) {
            _hideLoader();
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
            _hideLoader();
            // _emergency = true;
            log('LOG > doctor_spoke.dart > 280 > state: ${state.toString()}',
                time: DateTime.now());
            CubitProvider.of<MainCubit>(context).getAllPatients();
            CubitProvider.of<MainCubit>(context).getAllPatientRequests();
            setState(() {});
            //   CubitProvider.of<MainCubit>(context).fetchEmergencyDetails();
          } else if (state is ErrorState) {
            // _hideLoader();
            // _emergency = true;
            //print(state.error);
          }
          // else if (state is AllPatientsState) {
          //   log('LOG > doctor_spoke.dart > 284 > state: ${state.toString()}',
          //       time: DateTime.now());
          //   // _hideLoader();
          // }
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
            DrawerHeader(
              decoration: BoxDecoration(
                color: kPrimaryColor,
              ),
              child: Text(
                'CardioCare  Spoke',
                style: TextStyle(color: Colors.white, fontSize: 32.sp),
              ),
            ),
            // ListTile(
            //   leading: Icon(Icons.person),
            //   title: Text(
            //     'My Profile',
            //     style: TextStyle(color: Colors.black54),
            //   ),
            //   onTap: () {
            //     Navigator.pop(context);
            //   },
            // ),
            ListTile(
              leading: Icon(Icons.group),
              title: Text(
                'My Patients',
                style: TextStyle(color: Colors.black54),
              ),
              onTap: () {
                //// _hideLoader();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => CubitProvider<MainCubit>(
                        create: (ctx) => CubitProvider.of<MainCubit>(context),
                        child: PatientList(widget.homePageAdapter),
                      ),
                    ));
              },
            ),
            ListTile(
              leading: Icon(Icons.group),
              title: Text(
                'Add Patients',
                style: TextStyle(color: Colors.black54),
              ),
              onTap: () {
                //// _hideLoader();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => AddPatientScreen(
                          CubitProvider.of<MainCubit>(context)),
                    ));
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.question_answer),
            //   title: Text(
            //     'Consultation',
            //     style: TextStyle(color: Colors.black54),
            //   ),
            //   onTap: () {
            //     Navigator.pop(context);
            //   },
            // ),
            // ListTile(
            //   leading: Icon(Icons.settings),
            //   title: Text(
            //     'Settings',
            //     style: TextStyle(color: Colors.black54),
            //   ),
            //   onTap: () {
            //     Navigator.pop(context);
            //   },
            // ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(
                'Log out',
                style: TextStyle(color: Colors.black54),
              ),
              onTap: () async {
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
                          ]),
                    ) ??
                    false;
              },
            ),
          ],
        ),
      ),
    );
  }

  _buildUI(BuildContext context) => Column(
        children: [
          _buildRequestsUI(),
          _buildPatientssUI(),
        ],
      );

  _buildPatientssUI() => Column(
        children: [
          Container(
            width: SizeConfig.screenWidth,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            child: Text(
              "Current Patients",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 14.sp, color: kPrimaryColor),
            ),
          ),
          _patients.length != 0
              ? Container(
                  width: SizeConfig.screenWidth,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) {
                      return Container(height: 10);
                    },
                    itemCount: _patients.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => PatientInfo(
                                  patientID: _patients[index].id,
                                  mainCubit:
                                      CubitProvider.of<MainCubit>(context),
                                  homePageAdapter: widget.homePageAdapter)),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(20)),
                          child: ListTile(
                              leading: Icon(Icons.person),
                              title: Text(
                                _patients[index].name,
                                style: TextStyle(
                                    color: Colors.green, fontSize: 12.sp),
                              ),
                              trailing: Text(
                                  _patients[index].gender.toString() +
                                      '   ' +
                                      _patients[index].age.toString())),
                        ),
                      );
                    },
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('Currently there are no patients'),
                )
        ],
      );

  _buildRequestsUI() => Column(
        children: [
          Container(
            width: SizeConfig.screenWidth,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            child: Text(
              "Current Requests",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 14.sp, color: kPrimaryColor),
            ),
          ),
          _requests.length != 0
              ? Container(
                  width: SizeConfig.screenWidth,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: _requests.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          CubitProvider.of<MainCubit>(context)
                              .acceptPatientBySpoke(_requests[index].id);
                          setState(() {
                            _requests.removeAt(index);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.red[100],
                              borderRadius: BorderRadius.circular(20)),
                          child: ListTile(
                              leading: Icon(Icons.person),
                              title: Text(
                                _requests[index].name,
                                style: TextStyle(
                                    color: Colors.green, fontSize: 12.sp),
                              ),
                              trailing: Text(_requests[index].age.toString())),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(height: 5);
                    },
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('Currently there are no requests'),
                )
        ],
      );
}
