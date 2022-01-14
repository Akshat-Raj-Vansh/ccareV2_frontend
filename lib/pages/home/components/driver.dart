//@dart=2.9

import 'dart:async';
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
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as lloc;
import 'package:ccarev2_frontend/user/domain/location.dart' as loc;
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DriverHomeUI extends StatefulWidget {
  final IHomePageAdapter homePageAdapter;
  const DriverHomeUI(this.homePageAdapter);

  @override
  State<DriverHomeUI> createState() => _DriverHomeUIState();
}

class _DriverHomeUIState extends State<DriverHomeUI> {
  Completer<GoogleMapController> _controller = Completer();
  LatLng _patientLocation;
  LatLng _doctorLocation;
  EDetails eDetails;
  EStatus patientStatus = EStatus.EMERGENCY;
  dynamic currentState = null;
  LatLng _userLocation = LatLng(40, 23);
  bool loader = false;
  static bool _doctorAccepted = false;
  static bool _patientAccepted = false;
  final Set<Marker> _markers = {};
  MapType _currentMapType = MapType.normal;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    NotificationController.configure(
        CubitProvider.of<MainCubit>(context), UserType.DRIVER, context);
    NotificationController.fcmHandler();
    CubitProvider.of<MainCubit>(context).fetchEmergencyDetails();
    _getLocation();
  }

  _makingPhoneCall() async {
    // String url = eDetails.patientDetails.contactNumber;
    String url = eDetails.patientDetails.contactNumber;

    // if (await canLaunch("tel://$url")) {
    await launch("tel:$url");
    // } else {
    //   throw 'Could not launch $url';
    // }
  }

  _addPatientMarker() => _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_patientLocation.toString()),
        position: _patientLocation,
        infoWindow: InfoWindow(
          title: "Patient's Location",
          snippet: "Condition Critical",
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));

  _addDoctorMarker() => _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_doctorLocation.toString()),
        position: _doctorLocation,
        infoWindow: InfoWindow(
          title: "Doctor's Location",
          snippet: "Hospital Name",
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));

  _addDriverMarker() => _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_userLocation.toString()),
        position: _userLocation,
        infoWindow: InfoWindow(
          title: "Driver's Location",
          snippet: "Plate Number",
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));

  void _onCameraMove(CameraPosition position) {
    _userLocation = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _getLocation() async {
    lloc.LocationData _locationData = await lloc.Location().getLocation();
    print(_locationData.latitude.toString() +
        "," +
        _locationData.longitude.toString());

    _userLocation = LatLng(_locationData.latitude, _locationData.longitude);

    _addDriverMarker();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
        key: scaffoldKey,
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Danish Sheikh'),
              ),
              ListTile(
                title: const Text('Logout'),
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
                                widget.homePageAdapter.onLogout(context,
                                    CubitProvider.of<UserCubit>(context));
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
        body: CubitConsumer<MainCubit, MainState>(builder: (_, state) {
          if (state is DetailsLoaded) {
            currentState = state;
            eDetails = state.eDetails;
            print("Locations $eDetails");
            if (eDetails != null) {
              if (eDetails.patientDetails != null) {
                _patientAccepted = true;
                _patientLocation = LatLng(
                    eDetails.patientDetails.location.latitude,
                    eDetails.patientDetails.location.longitude);
                _addPatientMarker();
              }
              if (eDetails.doctorDetails != null) {
                _doctorAccepted = true;
                _doctorLocation = LatLng(
                    eDetails.doctorDetails.location.latitude,
                    eDetails.doctorDetails.location.longitude);
                _addDoctorMarker();
              }
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
            print("Loading State Called Driver");
            //    _showLoader();
          } else if (state is AcceptState) {
            // _hideLoader();
            print("Accept State Called");
            await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text(
                      'Are you sure!!',
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
                          // // _hideLoader();
                          // print("inside");
                          CubitProvider.of<MainCubit>(
                                  scaffoldKey.currentContext)
                              .acceptPatientByDriver(state.patientID);
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
            // print("patient arrived state");
            // print(state.location);
            _patientLocation =
                LatLng(state.location.latitude, state.location.longitude);
            print(_patientLocation);
            _addPatientMarker();
            // // _hideLoader();
            CubitProvider.of<MainCubit>(context).fetchEmergencyDetails();
          } else if (state is DetailsLoaded) {
            // _hideLoader();
          } else if (state is DoctorAccepted) {
            // _hideLoader();
            print("doctor accepted state");
            _doctorLocation =
                LatLng(state.location.latitude, state.location.longitude);
            _addDoctorMarker();
            // // _hideLoader();
            _showMessage("Doctor Accepted");

            CubitProvider.of<MainCubit>(context).fetchEmergencyDetails();
          }
        }));
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

  _buildUI(BuildContext context) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _userLocation,
            zoom: 9.0,
          ),
          mapType: _currentMapType,
          markers: _markers,
          onCameraMove: _onCameraMove,
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            child: IconButton(
                onPressed: () {
                  scaffoldKey.currentState.openDrawer();
                },
                icon: Icon(
                  Icons.menu,
                  size: 30,
                  color: Colors.black,
                )),
          ),
        ),
        if (_patientAccepted)
          Align(
              alignment: Alignment.bottomCenter,
              child: _buildBottomSheet(context))
      ],
    );
  }

  _buildBottomSheet(BuildContext context) => Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40))),
      width: double.infinity,
      height: patientStatus == EStatus.EMERGENCY ? 250 : 200,
      child: patientStatus == EStatus.EMERGENCY
          ? _buildPatientDetails()
          : _buildOTWDetails());

  _buildPatientDetails() => Column(children: [
        Container(
          width: SizeConfig.screenWidth,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Text(
            "Patients Information",
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 18),
          ),
        ),
        Container(
            decoration: BoxDecoration(
                color: Colors.blue[200],
                borderRadius: BorderRadius.circular(20)),
            width: SizeConfig.screenWidth,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage("/assets/images/dummy.jpeg"),
                  ),
                  SizedBox(width: 10),
                  Text(
                    eDetails.patientDetails.name,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                      onPressed: _makingPhoneCall,
                      icon: Icon(Icons.phone),
                      label: Text("CALL")),
                  TextButton.icon(
                      onPressed: () => print("CANCEL"),
                      icon: Icon(Icons.cancel),
                      label: Text("CANCEL"))
                ],
              ),
              RichText(
                text: TextSpan(
                  style: GoogleFonts.montserrat(color: Colors.blue),
                  children: [
                    WidgetSpan(
                        child: Icon(FontAwesomeIcons.mapMarker,
                            color: Colors.blue, size: 15)),
                    TextSpan(text: " Destination :"),
                    TextSpan(
                        text: eDetails.patientDetails.address,
                        style: TextStyle(color: Colors.blue))
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    onPressed: () async {
                      CubitProvider.of<MainCubit>(context).statusUpdate("OTW");

                      setState(() {
                        patientStatus = EStatus.OTW;
                      });
                    },
                    child: Text("PICK")),
              )
            ])),
      ]);
  _buildOTWDetails() => Column(children: [
        Container(
            width: SizeConfig.screenWidth,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage("/assets/images/dummy.jpeg"),
                  ),
                  SizedBox(width: 10),
                  Text(
                    eDetails.patientDetails.name,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  style: GoogleFonts.montserrat(color: Colors.blue),
                  children: [
                    WidgetSpan(
                        child: Icon(FontAwesomeIcons.mapMarker,
                            color: Colors.blue, size: 15)),
                    TextSpan(text: " Destination :"),
                    TextSpan(
                        text: eDetails.doctorDetails?.address,
                        style: TextStyle(color: Colors.blue))
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    onPressed: () async {
                      CubitProvider.of<MainCubit>(context).statusUpdate("ATH");
                      setState(() {
                        _patientAccepted = false;
                      });
                      //TODO:Backend #2 should make this ambulance availabe now
                    },
                    child: Text("DROP")),
              )
            ])),
      ]);
}
