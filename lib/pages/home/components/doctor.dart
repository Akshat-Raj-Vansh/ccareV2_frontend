//@dart=2.9
import 'package:ccarev2_frontend/pages/home/home_page_adapter.dart';
import 'package:ccarev2_frontend/services/Notifications/notificationContoller.dart';
import 'package:ccarev2_frontend/state_management/emergency/emergency_cubit.dart';
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

class DoctorHomeUI extends StatefulWidget {
  final MainCubit mainCubit;
  final UserCubit userCubit;
  final EmergencyCubit emergencyCubit;
  final IHomePageAdapter homePageAdapter;
  const DoctorHomeUI(this.mainCubit, this.userCubit, this.emergencyCubit,
      this.homePageAdapter);

  @override
  State<DoctorHomeUI> createState() => _DoctorHomeUIState();
}

class _DoctorHomeUIState extends State<DoctorHomeUI> {
  List<IconData> icons = [
    Icons.medication,
    Icons.food_bank,
    Icons.dangerous,
    Icons.fitness_center
  ];
  List<Color> colors = [Colors.green, Colors.amber, Colors.red, Colors.purple];
  List<String> footers = ["Medication", "Food", "First Aid", "Exercises"];
  List<String> res = [
    "Find Test centers",
    "Find Hospitals",
    "Find healthcare centres"
  ];
  List<String> meds = [
    "Roseday-40",
    "Eririp",
    "Vitamin-D",
    "Calcium",
    "Befta-400"
  ];
  List<String> time_meds = [
    "1 (Night)",
    "2 (Morning & Night)",
    "1 (weekly",
    "2 (Morning & Night)",
    "3"
  ];
  @override
  void initState() {
    super.initState();
    NotificationController.configure(
        widget.mainCubit, widget.emergencyCubit, UserType.doctor, context);
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
    return CubitConsumer<MainCubit, MainState>(
        cubit: widget.mainCubit,
        builder: (_, state) {
          return _buildUI(context);
        },
        listener: (context, state) async {
          if (state is LoadingState) {
            print("Loading State Called");
            _showLoader();
          } else if (state is HelpState) {
            print("Help State Called");
            loc.Location location = await _getLocation();
            _hideLoader();
            widget.homePageAdapter
                .loadEmergencyScreen(context, UserType.doctor, location);
          } else if (state is AllPatientsState) {
            print("AllPatientsState State Called");
            _hideLoader();
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

  _buildUI(BuildContext buildContext) => Scaffold(
        appBar: AppBar(
          title: Text('CardioCare - Doctor'),
          actions: [
            IconButton(
              onPressed: () async {
                _showLoader();
                loc.Location location = await _getLocation();
                _hideLoader();
                return widget.homePageAdapter
                    .loadEmergencyScreen(context, UserType.doctor, location);
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
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildEmergencyButton(),
                    const SizedBox(height: 10),
                    _buildHeader(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Text(
                        "Medicines",
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    _buildMedications(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Text(
                        "UserFul Resources",
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    _buildResources(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Text(
                        "Suggestions",
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    _buildSuggestions(context),
                    //
                  ]),
            ),
          ],
        ),
      );

  _buildEmergencyButton() => InkWell(
        onTap: () async {
          loc.Location location = await _getLocation();
          widget.homePageAdapter
              .loadEmergencyScreen(context, UserType.doctor, location);
        },
        child: Container(
          color: Colors.red[400],
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: ListTile(
            leading: Icon(CupertinoIcons.exclamationmark_bubble,
                color: Colors.white),
            title: Text(
              "Press here for updates!",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            subtitle: Text(
              "Emergency Situation ->",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      );

  _buildHeader() => Container(
        color: Colors.green[400],
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: ListTile(
          leading: Icon(CupertinoIcons.person, color: Colors.white),
          title: Text(
            "No Appointments Scheduled!!",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          subtitle: Text(
            "Loren Ipsum loren ipsum ->",
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      );

  _buildSuggestions(BuildContext context) => Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 50),
        child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: footers.length,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 1.5),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {},
              child: Card(
                color: colors[index],
                child: GridTile(
                    child: Icon(icons[index], size: 60, color: Colors.white),
                    footer: Center(
                        child: Text(footers[index],
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)))),
              ),
            );
          },
        ),
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
          },
        ),
      );

  _buildMedications() => Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: 350,
        width: SizeConfig.screenWidth,
        child: ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: meds.length,
          separatorBuilder: (context, index) => SizedBox(height: 10),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                  color: Colors.lightBlue[100],
                  borderRadius: BorderRadius.circular(20)),
              child: ListTile(
                leading: Text(meds[index], style: TextStyle(fontSize: 16)),
                trailing:
                    Text(time_meds[index], style: TextStyle(fontSize: 16)),
              ),
            );
          },
        ),
      );
}
