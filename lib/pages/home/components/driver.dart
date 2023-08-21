import 'dart:async';
import 'package:ccarev2_frontend/main/domain/edetails.dart';
import 'package:ccarev2_frontend/pages/home/home_page_adapter.dart';
import 'package:ccarev2_frontend/services/Notifications/notificationContoller.dart';
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/state_management/main/main_state.dart';
import 'package:ccarev2_frontend/state_management/user/user_cubit.dart';
import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:ccarev2_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as lloc;
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DriverHomeUI extends StatefulWidget {
  final IHomePageAdapter homePageAdapter;
  final UserCubit userCubit;
  const DriverHomeUI(this.homePageAdapter, this.userCubit);

  @override
  State<DriverHomeUI> createState() => _DriverHomeUIState();
}

class _DriverHomeUIState extends State<DriverHomeUI> {
  Completer<GoogleMapController> _controller = Completer();
  late LatLng _patientLocation;
  late LatLng _doctorLocation;
  late EDetails eDetails;
  EStatus patientStatus = EStatus.EMERGENCY;
  dynamic currentState = null;
  LatLng _userLocation = LatLng(40, 23);
  bool loader = false;
  static bool _doctorAccepted = false;
  static bool _patientAccepted = false;
  final Set<Marker> _markers = {};
  MapType _currentMapType = MapType.normal;
  var scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  @override
  void initState() {
    super.initState();
    NotificationController().configure(
        BlocProvider.of<MainCubit>(context), UserType.DRIVER, context);
    NotificationController().fcmHandler();
    BlocProvider.of<MainCubit>(context).fetchEmergencyDetails();
    _getLocation();
  }

  _makingPhoneCall() async {
    // String url = eDetails.patientDetails.contactNumber;
    String url = eDetails.patientDetails!.contactNumber;

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
    //print(_locationData.latitude.toString() +
    // "," +
    // _locationData.longitude.toString());

    _userLocation = LatLng(_locationData.latitude!, _locationData.longitude!);

    _addDriverMarker();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
        key: scaffoldKey,
        body: BlocConsumer<MainCubit, MainState>(builder: (_, state) {
          if (state is DetailsLoaded) {
            currentState = state;
            eDetails = state.eDetails;
            //print("Locations $eDetails");
            if (eDetails.patientDetails != null) {
              _patientAccepted = true;
              _patientLocation = LatLng(
                  eDetails.patientDetails!.location.latitude!,
                  eDetails.patientDetails!.location.longitude!);
              _addPatientMarker();
            }
            if (eDetails.doctorDetails != null) {
              _doctorAccepted = true;
              _doctorLocation = LatLng(
                  eDetails.doctorDetails!.location.latitude!,
                  eDetails.doctorDetails!.location.longitude!);
              _addDoctorMarker();
            }
          }

          if (state is NewErrorState) {
            currentState = NewErrorState;
          }
          if (currentState == null)
            return Center(child: CircularProgressIndicator());

          return _buildUI(context);
        }, listener: (context, state) async {
          if (state is LoadingState) {
            //print("Loading State Called Driver");
            //    _showLoader();
          } else if (state is AcceptState) {
            // _hideLoader();
            //print("Accept State Called");
            await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      'Are you sure!!',
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
                        onPressed: () {
                          // // _hideLoader();
                          // //print("inside");
                          BlocProvider.of<MainCubit>(
                                  scaffoldKey.currentContext!)
                              .acceptPatientByDriver(state.patientID);
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
            // //print("patient arrived state");
            // //print(state.location);
            _patientLocation =
                LatLng(state.location.latitude!, state.location.longitude!);
            //print(_patientLocation);
            _addPatientMarker();
            // // _hideLoader()zz;
            BlocProvider.of<MainCubit>(context).fetchEmergencyDetails();
          } else if (state is DetailsLoaded) {
            // _hideLoader();
          } else if (state is DoctorAccepted) {
            // _hideLoader();
            //print("doctor accepted state");
            _doctorLocation =
                LatLng(state.location.latitude!, state.location.longitude!);
            _addDoctorMarker();
            // // _hideLoader();
            _showMessage("Doctor Accepted");

            BlocProvider.of<MainCubit>(context).fetchEmergencyDetails();
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
      backgroundColor: Theme.of(context).colorScheme.secondary,
      content: Text(
        msg,
        style: Theme.of(context)
            .textTheme
            .bodySmall!
            .copyWith(color: Colors.white, fontSize: 12.sp),
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
                  widget.homePageAdapter.onLogout(context, widget.userCubit);
                },
                icon: Icon(
                  Icons.exit_to_app,
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
            style: TextStyle(fontSize: 14.sp),
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
                  SizedBox(width: 3.w),
                  Text(
                    eDetails.patientDetails!.name,
                    style: TextStyle(
                        fontSize: 14.sp,
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
                      onPressed: () => {}, //print("CANCEL"),
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
                        text: eDetails.patientDetails!.address,
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
                      BlocProvider.of<MainCubit>(context).statusUpdate("OTW",
                          patientID: eDetails.patientDetails!.id);

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
                  SizedBox(width: 3.w),
                  Text(
                    eDetails.patientDetails!.name,
                    style: TextStyle(
                        fontSize: 14.sp,
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
                      BlocProvider.of<MainCubit>(context).statusUpdate("ATH",
                          patientID: eDetails.patientDetails!.id);
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
