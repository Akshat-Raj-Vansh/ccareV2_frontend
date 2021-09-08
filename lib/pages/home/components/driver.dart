//@dart=2.9
import 'dart:async';

import 'package:ccarev2_frontend/pages/home/home_page_adapter.dart';
import 'package:ccarev2_frontend/services/Notifications/notificationContoller.dart';
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/state_management/main/main_state.dart';
import 'package:ccarev2_frontend/state_management/user/user_cubit.dart';
import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:location/location.dart' as lloc;
import 'package:ccarev2_frontend/user/domain/location.dart' as loc;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverHomeUI extends StatefulWidget {
  final MainCubit mainCubit;
  final UserCubit userCubit;
  final IHomePageAdapter homePageAdapter;
  const DriverHomeUI(this.mainCubit, this.userCubit, this.homePageAdapter);

  @override
  State<DriverHomeUI> createState() => _DriverHomeUIState();
}

class _DriverHomeUIState extends State<DriverHomeUI> {
  static bool _isEmergency = false;
  final Set<Marker> _markers = {};
  MapType _currentMapType = MapType.normal;
  Completer<GoogleMapController> _controller = Completer();
  LatLng _driverLocation = LatLng(50, 50);
  @override
  void initState() {
    super.initState();
    _setLocation();
    NotificationController.configure(
        widget.mainCubit, UserType.driver, context);
    NotificationController.fcmHandler();
  }

  _setLocation() async {
    lloc.LocationData _locationData = await lloc.Location().getLocation();
    print(_locationData.latitude.toString() +
        "," +
        _locationData.longitude.toString());
    _driverLocation = LatLng(_locationData.latitude, _locationData.longitude);
    _markers.add(Marker(
      // This marker id can be anything that uniquely identifies each marker.
      markerId: MarkerId(_driverLocation.toString()),
      position: _driverLocation,
      infoWindow: InfoWindow(
        title: "Driver's Location",
        snippet: "Plate Number",
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));
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
    return CubitConsumer<MainCubit, MainState>(builder: (_, state) {
      return _buildUI(context, widget.mainCubit);
    }, listener: (context, state) async {
      if (state is LoadingState) {
        print("Loading State Called");
        _showLoader();
      } else {
        if (state is AcceptState) {
          _hideLoader();
          _isEmergency = true;
          print("Accept State Called");
          loc.Location location = await _getLocation();
          widget.homePageAdapter
              .loadEmergencyScreen(context, UserType.driver, location);
        }
      }
    });
  }

  void _onCameraMove(CameraPosition position) {
    _driverLocation = position.target;
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

  _buildUI(BuildContext context, MainCubit mainCubit) => Scaffold(
        appBar: AppBar(
          title: Text('CardioCare - Driver'),
          actions: [
            if (_isEmergency)
              IconButton(
                onPressed: () async {
                  _showLoader();
                  loc.Location location = await _getLocation();
                  _hideLoader();
                  return widget.homePageAdapter
                      .loadEmergencyScreen(context, UserType.driver, location);
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _driverLocation,
                zoom: 9.0,
              ),
              mapType: _currentMapType,
              markers: _markers,
              onCameraMove: _onCameraMove,
            ),
            Center(
              child: RaisedButton(
                onPressed: () async {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Theme.of(context).accentColor,
                    content: Text(
                      'This button is used for accepting patients',
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .copyWith(color: Colors.white, fontSize: 16),
                    ),
                  ));
                },
                child: const Text('Alert Button'),
              ),
            ),
          ],
        ),
      );
}
