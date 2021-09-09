
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
  EDetails details;
  LatLng _userLocation=LatLng(100, 100);
  final Set<Marker> _markers = {};
  MapType _currentMapType = MapType.normal;
var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    NotificationController.configure(
        CubitProvider.of<MainCubit>(context), UserType.driver, context);
    NotificationController.fcmHandler();
    CubitProvider.of<MainCubit>(context).fetchEmergencyDetails();
    _getLocation();
    
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
    _patientLocation = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

   _getLocation() async {
    lloc.LocationData _locationData = await lloc.Location().getLocation();
    print(_locationData.latitude.toString() +
        "," +
        _locationData.longitude.toString());
    _userLocation =  LatLng(_locationData.latitude, _locationData.longitude);
    _addDriverMarker();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
   
    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(child:ListView(
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
        onTap: () {
         widget.homePageAdapter.onLogout(context, CubitProvider.of<UserCubit>(context));
        },
      ),
     
    ],
  ),),
      body:CubitConsumer<MainCubit, MainState>(builder: (_, state) {
        if (state is DetailsLoaded) {
          details = state.eDetails;
          print("Locations $details");
          if (details != null) {
            if (details.patientDetails!= null) {
              _patientLocation = LatLng(details.patientDetails.location.latitude,
                  details.patientDetails.location.longitude);
              _addPatientMarker();
            }
            if (details.doctorDetails != null) {
              _doctorLocation = LatLng(details.doctorDetails.location.latitude,
                  details.doctorDetails.location.longitude);
              _addDoctorMarker();
            }
            
          }
        }
      return _buildUI(context);
    }, listener: (context, state) async {
if (state is LoadingState) {
        print("Loading State Called");
        _showLoader();
      } 
      if(state is AcceptState){
        Scaffold.of(context).showBottomSheet((context) => Container(
          height: 200,
          child: Column(
            children: [
              ElevatedButton(onPressed: (){
                 Navigator.of(context, rootNavigator: true).pop();

              }, child: Text("Back")),
              Center(child: Text("Patient Name : Danish Sheikh\nLocation:Near Helipad")),
            ],
          ),
        ));
      }
       if (state is PatientAccepted) {
         _hideLoader();
          print("patient arrived state");
          print(state.location);
          _patientLocation =
              LatLng(state.location.latitude, state.location.longitude);
          _addPatientMarker();
          // _hideLoader();
          _showMessage("Patient Accepted");
        }

     if (state is DoctorAccepted) {
       _hideLoader();
          print("doctor accepted state");
          _doctorLocation =
              LatLng(state.location.latitude, state.location.longitude);
          _addDoctorMarker();
          // _hideLoader();
          _showMessage("Doctor Accepted");
        }
    })
  
    );}

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

  _buildUI(BuildContext context) => 
         Stack(
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
                child: Padding(padding: EdgeInsets.symmetric(horizontal: 30,vertical:50 ),
                child: IconButton(
                  onPressed: (){
                      scaffoldKey.currentState.openDrawer();
                  },
                  icon:Icon(Icons.menu,size: 30,color: Colors.black,)
                ),),
              ),
            ],
          );

}
