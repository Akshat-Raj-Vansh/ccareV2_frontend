import 'dart:async';
import 'package:ccarev2_frontend/user/domain/location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EmergencyScreen extends StatefulWidget {
  final Location location;
  EmergencyScreen({Key? key, required this.location}) : super(key: key);

  @override
  _EmergencyScreenState createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  Completer<GoogleMapController> _controller = Completer();

  late LatLng _center;
  final Set<Marker> _markers = {};
  late LatLng _lastMapPosition;

  MapType _currentMapType = MapType.normal;

  @override
  void initState() {
    _center = LatLng(widget.location.latitude, widget.location.longitude);
    _lastMapPosition = _center;
    _markers.add(Marker(
      // This marker id can be anything that uniquely identifies each marker.
      markerId: MarkerId(_lastMapPosition.toString()),
      position: _lastMapPosition,
      infoWindow: InfoWindow(
        title: "Patient's Location",
        snippet: "Condition Critical",
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));
    super.initState();
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        shadowColor: Colors.red,
        title: const Text(
          "Emergency Screen",
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
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
              zoom: 11.0,
            ),
            mapType: _currentMapType,
            markers: _markers,
            onCameraMove: _onCameraMove,
          ),
        ],
      ),
    );
  }
}
