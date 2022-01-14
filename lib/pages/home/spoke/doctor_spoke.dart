//@dart=2.9
import 'dart:developer';

import 'package:ccarev2_frontend/main/domain/edetails.dart';
import 'package:ccarev2_frontend/pages/chat/chatScreen.dart';
import 'package:ccarev2_frontend/pages/chat/components/chatModel.dart';
import 'package:ccarev2_frontend/pages/home/spoke/components/hub_list.dart';
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

class HomeScreenSpoke extends StatefulWidget {
  final MainCubit mainCubit;
  final UserCubit userCubit;
  final IHomePageAdapter homePageAdapter;

  const HomeScreenSpoke(this.mainCubit, this.userCubit, this.homePageAdapter);

  @override
  _HomeScreenSpokeState createState() => _HomeScreenSpokeState();
}

class _HomeScreenSpokeState extends State<HomeScreenSpoke> {
  dynamic currentState = NormalState;
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
        title: Text('CardioCare - SPOKE'),
        backgroundColor: kPrimaryColor,
      ),
      body: CubitConsumer<MainCubit, MainState>(
        builder: (_, state) {
          if (state is PatientsLoaded) {
            //  // _hideLoader();
            currentState = PatientsLoaded;
            _patients = state.patients;
            print(_patients);
          }
          if (state is RequestsLoaded) {
            //  // _hideLoader();
            currentState = RequestsLoaded;
            _requests = state.req;
            print(_requests);
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

          if (state is NormalState) {
            //   // _hideLoader();
            currentState = NormalState;
          }
          if (currentState == null)
            return Center(child: CircularProgressIndicator());
          return _buildUI(context);
        },
        listener: (context, state) async {
          if (state is LoadingState) {
            print("Loading State Called Doctor Spoke");
            log('LOG > doctor_spoke.dart > 197 > state: ${state.toString()}');
            //      _showLoader();
          } else if (state is TokenLoadedState) {
            token = state.token;
          }
          // if (state is NewReportGenerated) {
          //   // _hideLoader();
          //   log('LOG > doctor_spoke.dart > 212 > state: ${state.toString()}');
          //   // Navigator.push(
          //   //     context,
          //   //     MaterialPageRoute(
          //   //       builder: (context) => PatientReportScreen(
          //   //         mainCubit: widget.mainCubit,
          //   //         user: UserType.DOCTOR,
          //   //         patientDetails: eDetails.patientDetails,
          //   //       ),
          //   //     ));
          //   _showMessage(state.msg);
          // } else if (state is AllHubDoctorsState) {
          //   // _hideLoader();
          //   log('LOG > doctor_spoke.dart > 223 > state: ${state.toString()}',
          //       time: DateTime.now());
          //   showModalBottomSheet(
          //       context: context,
          //       builder: (_) {
          //         return HubDoctorsList(state.docs, widget.mainCubit);
          //       });
          // } else if (state is ConsultHub) {
          //   // _hideLoader();
          //   log('LOG > doctor_spoke.dart > 231 > state: ${state.toString()}',
          //       time: DateTime.now());
          //}
          else if (state is AcceptState) {
            // _hideLoader();
            log('LOG > doctor_spoke.dart > 237 > state: ${state.toString()}',
                time: DateTime.now());
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
                          Navigator.of(context).pop(false);
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
            // _hideLoader();
            // _emergency = true;
            log('LOG > doctor_spoke.dart > 280 > state: ${state.toString()}',
                time: DateTime.now());
              setState(() {
                
              });
            //   CubitProvider.of<MainCubit>(context).fetchEmergencyDetails();
          } else if (state is ErrorState) {
            //   // _hideLoader();
            // _emergency = true;
            print(state.error);
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
            const DrawerHeader(
              decoration: BoxDecoration(
                color: kPrimaryColor,
              ),
              child: Text(
                'CardioCare  Spoke',
                style: TextStyle(color: Colors.white, fontSize: 43),
              ),
            ),
            // ListTile(
            //   leading: Icon(Icons.person),
            //   title: const Text(
            //     'My Profile',
            //     style: TextStyle(color: Colors.black54),
            //   ),
            //   onTap: () {
            //     Navigator.pop(context);
            //   },
            // ),
            ListTile(
              leading: Icon(Icons.group),
              title: const Text(
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
                        child: PatientList(),
                      ),
                    ));
              },
            ),
            ListTile(
              leading: Icon(Icons.question_answer),
              title: const Text(
                'Consultation',
                style: TextStyle(color: Colors.black54),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: const Text(
                'Settings',
                style: TextStyle(color: Colors.black54),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: const Text(
                'Log out',
                style: TextStyle(color: Colors.black54),
              ),
              onTap: () async {
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
            ),
          ],
        ),
      ),
    );
  }

  _buildUI(BuildContext context) => Column(
        children: [_buildRequestsUI(), _buildPatientssUI()],
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
              style: TextStyle(fontSize: 18, color: kPrimaryColor),
            ),
          ),
          _patients.length != 0
              ? Container(
                  decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(20)),
                  width: SizeConfig.screenWidth,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: ListView.builder(
                    itemCount: _patients.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => CubitProvider<MainCubit>(
                              create: (ctx) =>
                                  CubitProvider.of<MainCubit>(context),
                              child: PatientInfo(_patients[index].id),
                            ),
                          ),
                        ),
                        child: ListTile(
                            leading: Icon(Icons.person),
                            title: Text(
                              _patients[index].name,
                              style:
                                  TextStyle(color: Colors.green, fontSize: 15),
                            ),
                            trailing: Text(_patients[index].gender.toString() +
                                '   ' +
                                _patients[index].age.toString())),
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
              style: TextStyle(fontSize: 18, color: kPrimaryColor),
            ),
          ),
          _requests.length != 0
              ? Container(
                  decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(20)),
                  width: SizeConfig.screenWidth,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _requests.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () => CubitProvider.of<MainCubit>(context)
                            .acceptPatientBySpoke(_requests[index].id),
                        child: ListTile(
                            leading: Icon(Icons.person),
                            title: Text(
                              _requests[index].name,
                              style:
                                  TextStyle(color: Colors.green, fontSize: 15),
                            ),
                            trailing: Text(_requests[index].age.toString())),
                      );
                    },
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('Currently there are no requests'),
                )
        ],
      );

  // SingleChildScrollView(
  //   child:
  //       Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
  //     if (_patientAccepted || _driverAccepted)
  //       Padding(
  //         padding:
  //             const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //         child: Text(
  //           "Emergency Information",
  //           style: TextStyle(fontSize: 24),
  //         ),
  //       ),
  //     if (_patientAccepted)
  //       Container(
  //         padding:
  //             const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //         margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(
  //               "Status:",
  //               textAlign: TextAlign.left,
  //               style: TextStyle(fontSize: 18),
  //             ),
  //             Text(
  //               _currentStatus,
  //               style: TextStyle(color: Colors.red),
  //             ),
  //           ],
  //         ),
  //       ),
  // if (_patientAccepted && _currentStatus == "ATH")
  //   _buildStartTreatmentButton(),
  // if (_patientAccepted) _buildPatientDetails(),
  // if (_patientAccepted && _ugt) _buildPatientReportButton(),
  // if (_patientAccepted && _ugt) _buildPatientExamButton(),
  // if (_patientAccepted && _ugt && !_hubAccepted) _buildHubList(),
  // if (_hubAccepted) _buildChatButton(),
  // if (_patientAccepted && _ugt) _buildNewReportButton(),
  // if (_patientAccepted && _ugt) _buildPatientReportHistoryButton(),
  // if (_driverAccepted) _buildDriverDetails(),
  // if (!_emergency) _buildHeader(),
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
  //     ]),
  //   ),
  // ]);

  // _buildHeader() => Container(
  //     color: Colors.green[400],
  //     padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
  //     child: ListTile(
  //       leading: Icon(CupertinoIcons.person, color: Colors.white),
  //       title: Text(
  //         "All Current Patients are recovering!!",
  //         style: TextStyle(color: Colors.white, fontSize: 20),
  //       ),
  //       subtitle: Text(
  //         "Medications and Ongoing treatment ->",
  //         style: TextStyle(color: Colors.white, fontSize: 12),
  //       ),
  //     ));

  // _buildPatientDetails() => Column(children: [
  //       Container(
  //         width: SizeConfig.screenWidth,
  //         margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
  //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
  //         child: Text(
  //           "Patient's Information",
  //           textAlign: TextAlign.left,
  //           style: TextStyle(fontSize: 18),
  //         ),
  //       ),
  //       Container(
  //         decoration: BoxDecoration(
  //             color: Colors.red[100], borderRadius: BorderRadius.circular(20)),
  //         width: SizeConfig.screenWidth,
  //         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //         margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //         child: Column(
  //           children: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text("Name: "),
  //                 Text(eDetails.patientDetails.name),
  //               ],
  //             ),
  //             const SizedBox(
  //               height: 5,
  //             ),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text("Contact Number: "),
  //                 Text(eDetails.patientDetails.contactNumber),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ]);

  // _buildStartTreatmentButton() => InkWell(
  //       onTap: () async {
  //         widget.mainCubit.statusUpdate("UGT");
  //         _currentStatus = "UGT";
  //         _ugt = true;
  //       },
  //       child: Container(
  //         width: SizeConfig.screenWidth,
  //         margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
  //         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //         decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(5),
  //             border: Border.all(color: kPrimaryColor)),
  //         child: Text(
  //           "Start treatment of the Patient",
  //           style: TextStyle(color: kPrimaryColor, fontSize: 14),
  //           textAlign: TextAlign.center,
  //         ),
  //       ),
  //     );

  // _buildPatientReportButton() => InkWell(
  //       onTap: () async {
  //         Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => PatientReportScreen(
  //                 mainCubit: widget.mainCubit,
  //                 user: UserType.DOCTOR,
  //                 patientDetails: eDetails.patientDetails,
  //               ),
  //             ));
  //       },
  //       child: Container(
  //         width: SizeConfig.screenWidth,
  //         margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
  //         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //         decoration: BoxDecoration(
  //             color: kPrimaryLightColor,
  //             borderRadius: BorderRadius.circular(20)),
  //         child: Text(
  //           "View/Update Patient's Medical Report",
  //           style: TextStyle(color: Colors.white, fontSize: 14),
  //           textAlign: TextAlign.center,
  //         ),
  //       ),
  //     );

  // _buildPatientExamButton() => InkWell(
  //       onTap: () async {
  //         Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => PatientExamScreen(
  //                 mainCubit: widget.mainCubit,
  //                 patientDetails: eDetails.patientDetails,
  //               ),
  //             ));
  //       },
  //       child: Container(
  //         width: SizeConfig.screenWidth,
  //         margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
  //         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //         decoration: BoxDecoration(
  //             color: kPrimaryLightColor,
  //             borderRadius: BorderRadius.circular(20)),
  //         child: Text(
  //           "View/Update Patient's Exam Report",
  //           style: TextStyle(color: Colors.white, fontSize: 14),
  //           textAlign: TextAlign.center,
  //         ),
  //       ),
  //     );

  // _buildPatientReportHistoryButton() => InkWell(
  //       onTap: () async {
  //         Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) =>
  //                   PatientReportHistoryScreen(mainCubit: widget.mainCubit),
  //             ));
  //       },
  //       child: Container(
  //         width: SizeConfig.screenWidth,
  //         margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
  //         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //         child: Text(
  //           "View Patient's Medical Report History",
  //           style: TextStyle(color: kPrimaryColor, fontSize: 14),
  //           textAlign: TextAlign.center,
  //         ),
  //       ),
  //     );

  // _buildHubList() => InkWell(
  //       onTap: () async {
  //         widget.mainCubit.getAllHubDoctors();
  //         // Navigator.push(
  //         //     context,
  //         //     MaterialPageRoute(
  //         //       builder: (context) =>
  //         //           PatientReportHistoryScreen(mainCubit: widget.mainCubit),
  //         //     ));
  //       },
  //       child: Container(
  //         width: SizeConfig.screenWidth,
  //         margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
  //         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //         decoration: BoxDecoration(
  //             color: kPrimaryLightColor,
  //             borderRadius: BorderRadius.circular(20)),
  //         child: Text(
  //           "Consultations",
  //           style: TextStyle(color: Colors.white, fontSize: 14),
  //           textAlign: TextAlign.center,
  //         ),
  //       ),
  //     );
  // _buildChatButton() => InkWell(
  //       onTap: () async {
  //         Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (context) => CubitProvider<MainCubit>(
  //                     create: (_) => widget.mainCubit,
  //                     child: ChatPage(
  //                         eDetails.hubDetails.name,
  //                         eDetails.hubDetails.id,
  //                         eDetails.patientDetails.id,
  //                         token))));
  //         // widget.mainCubit.getAllHubDoctors();
  //         // Navigator.push(
  //         //     context,
  //         //     MaterialPageRoute(
  //         //       builder: (context) =>
  //         //           PatientReportHistoryScreen(mainCubit: widget.mainCubit),
  //         //     ));
  //       },
  //       child: Container(
  //         width: SizeConfig.screenWidth,
  //         margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
  //         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //         decoration: BoxDecoration(
  //             color: kPrimaryLightColor,
  //             borderRadius: BorderRadius.circular(20)),
  //         child: Text(
  //           eDetails.hubDetails.name,
  //           style: TextStyle(color: Colors.white, fontSize: 14),
  //           textAlign: TextAlign.center,
  //         ),
  //       ),
  //     );

  // _buildNewReportButton() => InkWell(
  //       onTap: () async {
  //         widget.mainCubit.generateNewReport();
  //       },
  //       child: Container(
  //         width: SizeConfig.screenWidth,
  //         margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //         decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(20),
  //             border: Border.all(color: kPrimaryColor)),
  //         child: Text(
  //           "Create New Report",
  //           style: TextStyle(color: kPrimaryColor, fontSize: 14),
  //           textAlign: TextAlign.center,
  //         ),
  //       ),
  //     );

  // _buildDriverDetails() => Column(children: [
  //       Container(
  //         width: SizeConfig.screenWidth,
  //         margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
  //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
  //         child: Text(
  //           "Ambulance's Information",
  //           textAlign: TextAlign.left,
  //           style: TextStyle(fontSize: 18),
  //         ),
  //       ),
  //       Container(
  //           decoration: BoxDecoration(
  //               color: Colors.red[100],
  //               borderRadius: BorderRadius.circular(20)),
  //           width: SizeConfig.screenWidth,
  //           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //           margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //           child: Column(children: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text("Name: "),
  //                 Text(eDetails.driverDetails.name),
  //               ],
  //             ),
  //             const SizedBox(
  //               height: 5,
  //             ),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text("Plate Number: "),
  //                 Text(eDetails.driverDetails.plateNumber),
  //               ],
  //             ),
  //             const SizedBox(
  //               height: 5,
  //             ),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text("Contact Number: "),
  //                 Text(eDetails.driverDetails.contactNumber),
  //               ],
  //             ),
  //             const SizedBox(
  //               height: 5,
  //             ),
  //             RichText(
  //               text: TextSpan(
  //                 text: "Location : ",
  //                 style: GoogleFonts.montserrat(color: Colors.black),
  //                 children: [
  //                   TextSpan(
  //                       text: eDetails.driverDetails.address,
  //                       style: TextStyle(color: Colors.black))
  //                 ],
  //               ),
  //             ),
  //           ])),
  //     ]);

  // // _buildResources() => Container(
  // //     padding: EdgeInsets.symmetric(horizontal: 20),
  // //     width: SizeConfig.screenWidth,
  // //     height: 200,
  // //     child: ListView.separated(
  // //         physics: NeverScrollableScrollPhysics(),
  // //         shrinkWrap: true,
  // //         itemCount: res.length,
  // //         separatorBuilder: (context, index) => SizedBox(height: 10),
  // //         itemBuilder: (context, index) {
  // //           return Container(
  // //             decoration: BoxDecoration(
  // //                 color: Colors.lightBlue[100],
  // //                 borderRadius: BorderRadius.circular(20)),
  // //             child: ListTile(
  // //                 leading: Text(res[index], style: TextStyle(fontSize: 16))),
  // //           );
  // //         }));

  // // _buildMedications() => Container(
  // //     padding: EdgeInsets.symmetric(horizontal: 20),
  // //     height: 350,
  // //     width: SizeConfig.screenWidth,
  // //     child: ListView.separated(
  // //         physics: NeverScrollableScrollPhysics(),
  // //         shrinkWrap: true,
  // //         itemCount: patients.length,
  // //         separatorBuilder: (context, index) => SizedBox(height: 10),
  // //         itemBuilder: (context, index) {
  // //           return Container(
  // //             decoration: BoxDecoration(
  // //                 color: Colors.lightBlue[100],
  // //                 borderRadius: BorderRadius.circular(20)),
  // //             child: ListTile(
  // //               leading: Text(patients[index], style: TextStyle(fontSize: 16)),
  // //               trailing:
  // //                   Text(time_patients[index], style: TextStyle(fontSize: 16)),
  // //             ),
  // //           );
  // //         }));
}
