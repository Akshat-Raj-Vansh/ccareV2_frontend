import 'dart:async';
import 'package:ccarev2_frontend/main/domain/edetails.dart';
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/state_management/main/main_state.dart';
import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:ccarev2_frontend/user/domain/location.dart' as loc;

class EmergencyScreen extends StatefulWidget {
  final UserType userType;
  final loc.Location location;
  final String patientID;
  EmergencyScreen({required this.userType, required this.location, required this.patientID});

  @override
  _EmergencyScreenState createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  Completer<GoogleMapController> _controller = Completer();

  late LatLng _center;
  final Set<Marker> _markers = {};
  late LatLng _patientLocation;
  late LatLng _doctorLocation;
  late LatLng _driverLocation;
  late EDetails details;
  MapType _currentMapType = MapType.normal;

  @override
  void initState() {
    super.initState();
    //print("Inside Emergenecy Screen initState");
    _getLocations();
    _patientLocation = LatLng(40, 23);
    _doctorLocation = LatLng(100, 100);
    _driverLocation = LatLng(100, 100);
    _getUserLocation();

    // NotificationController.configure(
    //     CubitProvider.of<MainCubit>(context), UserType.PATIENT, context);
    // NotificationController.fcmHandler();
  }

  _showLoader() {
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

  _getLocations() {
    BlocProvider.of<MainCubit>(context)
        .fetchEmergencyDetails(patientID: widget.patientID);
  }

  _getUserLocation() {
    if (widget.userType == UserType.PATIENT) {
      _patientLocation =
          LatLng(widget.location.latitude!, widget.location.longitude!);
      _center = _patientLocation;
      _addPatientMarker();
    } else if (widget.userType == UserType.PATIENT) {
      _doctorLocation =
          LatLng(widget.location.latitude!, widget.location.longitude!);
      _center = _doctorLocation;
      _addDoctorMarker();
    } else {
      _driverLocation =
          LatLng(widget.location.latitude!, widget.location.longitude!);
      _center = _driverLocation;
      _addDriverMarker();
    }
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
        markerId: MarkerId(_driverLocation.toString()),
        position: _driverLocation,
        infoWindow: InfoWindow(
          title: "Driver's Location",
          snippet: "Plate Number",
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));

  void _onCameraMove(CameraPosition position) {
    _patientLocation = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainState>(
      listener: (context, state) {
        if (state is PatientAccepted) {
          //print("patient arrived state");
          //print(state.location);
          _patientLocation =
              LatLng(state.location.latitude!, state.location.longitude!);
          _addPatientMarker();
          // _hideLoader();
          _showMessage("Patient Accepted");
        }
        if (state is DoctorAccepted) {
          //print("doctor accepted state");
          _doctorLocation =
              LatLng(state.location.latitude!, state.location.longitude!);
          _addDoctorMarker();
          // // _hideLoader();
          // _showMessage("Doctor Accepted");
        }
        if (state is DriverAccepted) {
          //print("driver accepted state");
          _driverLocation =
              LatLng(state.location.latitude!, state.location.longitude!);
          _addDriverMarker();
          // // _hideLoader();
          // _showMessage("Driver Accepted");
        }
      },
      builder: (context, state) {
        if (state is DetailsLoaded) {
          details = state.eDetails;
          //print("Details $details");
          if (details.patientDetails != null) {
            _patientLocation = LatLng(
                details.patientDetails!.location.latitude!,
                details.patientDetails!.location.longitude!);
            _addPatientMarker();
          }
          if (details.doctorDetails != null) {
            _doctorLocation = LatLng(details.doctorDetails!.location.latitude!,
                details.doctorDetails!.location.longitude!);
            _addDoctorMarker();
          }
          if (details.driverDetails != null) {
            _driverLocation = LatLng(details.driverDetails!.location.latitude!,
                details.driverDetails!.location.longitude!);
            _addDriverMarker();
          }
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            shadowColor: Colors.red,
            title: Text(
              "Emergency Screen",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          body: Stack(
            children: <Widget>[
              GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 9.0,
                ),
                mapType: _currentMapType,
                markers: _markers,
                onCameraMove: _onCameraMove,
              ),
            ],
          ),
        );
      },
    );
  }
}
