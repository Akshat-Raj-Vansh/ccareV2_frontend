//@dart=2.9
import 'dart:async';
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/state_management/main/main_state.dart';
import 'package:ccarev2_frontend/state_management/user/user_cubit.dart';
import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:location/location.dart' as lloc;
import 'package:ccarev2_frontend/user/domain/location.dart' as loc;
import 'package:ccarev2_frontend/services/Notifications/notificationContoller.dart';

class EmergencyScreen extends StatefulWidget {
  final UserCubit userCubit;
  final MainCubit mainCubit;
  final UserType userType;
  final loc.Location location;
  EmergencyScreen(
      {this.userCubit, this.mainCubit, this.userType, this.location});

  @override
  _EmergencyScreenState createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  Completer<GoogleMapController> _controller = Completer();

  LatLng _center;
  final Set<Marker> _markers = {};
  LatLng _patientLocation;
  LatLng _doctorLocation;
  LatLng _driverLocation;

  MapType _currentMapType = MapType.normal;

  @override
  void initState() {
    NotificationController.configure(
        widget.mainCubit, widget.userType, context);
    NotificationController.fcmHandler();
    _patientLocation = LatLng(40, 23);
    _doctorLocation = LatLng(100, 100);
    _driverLocation = LatLng(100, 100);
    _getUserLocation();
    super.initState();
  }

  _getUserLocation() {
    if (widget.userType == UserType.patient) {
      _patientLocation =
          LatLng(widget.location.latitude, widget.location.longitude);
      _center = _patientLocation;
      _addPatientMarker();
    } else if (widget.userType == UserType.patient) {
      _doctorLocation =
          LatLng(widget.location.latitude, widget.location.longitude);
      _center = _doctorLocation;
      _addDoctorMarker();
    } else {
      _driverLocation =
          LatLng(widget.location.latitude, widget.location.longitude);
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

  @override
  Widget build(BuildContext context) {
    return CubitConsumer<MainCubit, MainState>(
      cubit:widget.mainCubit,
      listener: (context, state) {
        if (state is LoadingState) {
          print("Loading State Called in Emergency State");
          _showLoader();
        }
        if (state is PatientAccepted) {
          print("patient arrived state");
          setState(() {
            _patientLocation =
                LatLng(state.location.latitude, state.location.longitude);
            _addPatientMarker();
            _hideLoader();
          });
        }
        if (state is DoctorAccepted) {
          print("doctor accepted state");
          setState(() {
            _doctorLocation =
                LatLng(state.location.latitude, state.location.longitude);
            _addDoctorMarker();
            _hideLoader();
          });
        }
        if (state is DriverAccepted) {
          print("driver accepted state");
          setState(() {
            _driverLocation =
                LatLng(state.location.latitude, state.location.longitude);
            _addDriverMarker();
            _hideLoader();
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            shadowColor: Colors.red,
            title: const Text(
              "Emergency Screen",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
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
