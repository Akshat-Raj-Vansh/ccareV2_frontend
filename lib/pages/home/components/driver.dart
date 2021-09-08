//@dart=2.9
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
import 'package:location/location.dart' as lloc;
import 'package:ccarev2_frontend/user/domain/location.dart' as loc;

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
  List<String> res = [
    "Find Test centers",
    "Find Hospitals",
    "Find healthcare centres"
  ];
  List<String> patients = [
    "Alpha",
    "Beta",
    "Gamma",
    "Omega",
    "Theta",
  ];
  List<String> time_patients = [
    "6th Sept,2021",
    "4th Sept,2021",
    "3th Sept,2021",
    "3th Sept,2021",
    "1th Sept,2021"
  ];
  @override
  void initState() {
    super.initState();
    NotificationController.configure(
        widget.mainCubit, UserType.driver, context);
    NotificationController.fcmHandler();
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
    SizeConfig().init(context);
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
        body: Stack(children: [
          SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _buildEmergencyButton(context),
              const SizedBox(height: 10),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  "Patients",
                  style: TextStyle(fontSize: 24),
                ),
              ),
              _buildMedications(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  "UseFul Resources",
                  style: TextStyle(fontSize: 24),
                ),
              ),
              _buildResources(),
            ]),
          ),
        ]),
      );

  _buildEmergencyButton(BuildContext context) => InkWell(
        onTap: () async {
          _showLoader();
          loc.Location location = await _getLocation();
          _hideLoader();
          return widget.homePageAdapter
              .loadEmergencyScreen(context, UserType.patient, location);
        },
        child: Container(
            color: Colors.red[400],
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: ListTile(
              leading: Icon(CupertinoIcons.exclamationmark_bubble,
                  color: Colors.white),
              title: Text(
                "Press here for Emergency Service!",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              subtitle: Text(
                "Emergency Situation ->",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            )),
      );

  _buildResources() => Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: SizeConfig.screenWidth,
      height: 200,
      child: ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: res.length,
          separatorBuilder: (context, index) => SizedBox(height: 10),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                  color: Colors.lightBlue[100],
                  borderRadius: BorderRadius.circular(20)),
              child: ListTile(
                  leading: Text(res[index], style: TextStyle(fontSize: 16))),
            );
          }));

  _buildMedications() => Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: 350,
      width: SizeConfig.screenWidth,
      child: ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: patients.length,
          separatorBuilder: (context, index) => SizedBox(height: 10),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                  color: Colors.lightBlue[100],
                  borderRadius: BorderRadius.circular(20)),
              child: ListTile(
                leading: Text(patients[index], style: TextStyle(fontSize: 16)),
                trailing:
                    Text(time_patients[index], style: TextStyle(fontSize: 16)),
              ),
            );
          }));
}
