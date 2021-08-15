import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:auth/auth.dart';
import 'package:extras/extras.dart';
import '../../pages/Home/home.dart';
import '../../pages/Home/medicalReports.dart';
import '../../pages/Home/ongoingtreatment.dart';
import '../../pages/Home/tapPageAdapter.dart';
import '../../pages/questionnare/questionnare.dart';
import '../../state_management/auth/auth_cubit.dart';
import '../../state_management/auth/auth_state.dart' as authState;
import '../../state_management/main_app/main_cubit.dart';
import '../../state_management/main_app/main_state.dart' as mainState;
import '../../state_management/profile/profile_State.dart' as profileState;

class TabPage extends StatefulWidget {
  final IAuthService authService;
  final ITabPageAdatper adapter;
  const TabPage(this.authService, this.adapter);
  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> with SingleTickerProviderStateMixin {
  @override
  initState() {
    super.initState();
    CubitProvider.of<MainCubit>(context).getCurrentPatients();
    CubitProvider.of<MainCubit>(context).getWaitingList();
  }

  List<MedicalProfile> currentPatientList = [];
  List<MedicalProfile> waitingList = [];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                  child: Column(children: [
                Container(
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  height: 120,
                  width: 120,
                  child: Image(
                      fit: BoxFit.cover, image: AssetImage('assets/logo.png')),
                ),
                Text("CardioCare")
              ])),
              ListTile(
                title: Text('Profile'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                title: Text('View History'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                title: Text('View Reports'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                title: Text('Helpline Numbers'),
                onTap: () {
                  // Update the state of the app.
                  // ...,
                },
              ),
              ListTile(
                title: Text('First Aid'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                title: Text('Log Out'),
                onTap: () async {
                  await CubitProvider.of<AuthCubit>(context)
                      .signout(widget.authService);
                  // ...
                },
              )
            ],
          ),
        ),
        appBar: AppBar(
          title: Text('Patients'),
          //   bottom: TabBar(
          //     tabs: [
          //       Tab(
          //           icon: Icon(
          //         Icons.home,
          //       )),
          //       Tab(icon: Icon(Icons.timelapse)),
          //       Tab(icon: Icon(Icons.verified_user_rounded)),
          //     ],
          //   ),
          //   title: Text("CardioCare"),
          //   centerTitle: true,
          // ),
        ),
        body: Stack(children: [
          CubitConsumer<MainCubit, mainState.MainState>(
            builder: (BuildContext context, state) {
              // return TabBarView(
              //   children: [
              //     Home(),
              //     OngoingTreatment(),
              //     MedicalReports(),
              //   ],
              // );
              if (state is mainState.PatientLoadedState) {
                currentPatientList = state.profile;
                print('currentPatients: ' + currentPatientList.toString());
              }
              if (state is mainState.PatientWaitingState) {
                waitingList = state.profile;
                print('waitingList: ' + waitingList.toString());
              }
              return _bodyPatient(context);
            },
            listener: (BuildContext context, Object state) {
              if (state is mainState.LoadingState) {
                print("LoadingStateCalled");
                _showLoader();
              }

              if (state is mainState.ErrorState)
                _showError(context, state.error);

              if (state is mainState.QuestionnaireState) {
                _hideLoader();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Self_Assessment(state.questions)));
              }
            },
          ),
          Align(
            child: CubitListener<AuthCubit, authState.AuthState>(
                child: Container(),
                listener: (context, state) {
                  if (state is authState.LoadingState) {
                    _showLoader();
                  }
                  if (state is authState.SignOutSuccesState) {
                    widget.adapter.logout(context);
                  }
                  if (state is authState.ErrorState) {
                    _showError(context, state.error);
                    _hideLoader();
                  }
                }),
            alignment: Alignment.center,
          ),
        ]),
      ),
    );
    //   return Scaffold(

    //       bottomNavigationBar: BottomNavigationBar(
    //         unselectedItemColor: Colors.grey[500],
    //           currentIndex: selectedIndex,
    //           onTap: (val) {
    //             setState(() {
    //               selectedIndex = val;
    //             });
    //           },
    //           mouseCursor: MouseCursor.uncontrolled,
    //           items: [
    //             BottomNavigationBarItem(icon: Icon(Icons.home,), label: "Home"),
    //             BottomNavigationBarItem(
    //                 icon: Icon(Icons.timelapse), label: "Daily"),
    //             BottomNavigationBarItem(icon: Icon(Icons.verified_user_rounded), label: "Vaccinations")
    //           ]),
    //       body: _pageChanger(selectedIndex));
    // }
  }

  _showError(BuildContext context, String error) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).accentColor,
        content: Text(
          error,
          style: Theme.of(context)
              .textTheme
              .caption!
              .copyWith(color: Colors.white, fontSize: 16),
        ),
      ));
  _showLoader() {
    print("Loader Called");
    var alert = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Center(
          child: CircularProgressIndicator(backgroundColor: Colors.green)),
    );

    showDialog(
        context: context, barrierDismissible: true, builder: (_) => alert);
  }

  _hideLoader() {
    Navigator.of(context, rootNavigator: true).pop();
  }

  _bodyPatient(BuildContext context) => Container(
        height: 400,
        width: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            waitingList.length == 0
                ? SizedBox(height: 10)
                : Text(
                    "Patients Waiting List",
                    style: TextStyle(fontSize: 24),
                  ),
            ListView.separated(
                separatorBuilder: (context, _) => SizedBox(
                      height: 10,
                    ),
                shrinkWrap: true,
                itemCount: waitingList.length,
                itemBuilder: (context, index) => Card(
                      child: ListTile(
                        title: Text(waitingList[index].firstName +
                            " " +
                            waitingList[index].lastName),
                        subtitle: Text('Height:' +
                            waitingList[index].height.toString() +
                            ' Weight: ' +
                            waitingList[index].weight.toString()),
                        trailing: TextButton(
                          onPressed: () {
                            CubitProvider.of<MainCubit>(context).acceptPatient(
                                waitingList[index].userId.toString());
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Adding patient!')));
                          },
                          child: Text("Accept"),
                        ),
                      ),
                    )),
            SizedBox(height: 20),
            currentPatientList.length == 0
                ? SizedBox(height: 10)
                : Text(
                    "Current Patients",
                    style: TextStyle(fontSize: 24),
                  ),
            currentPatientList.length == 0
                ? SizedBox(height: 10)
                : ListView.separated(
                    separatorBuilder: (context, _) => SizedBox(
                          height: 10,
                        ),
                    shrinkWrap: true,
                    itemCount: currentPatientList.length,
                    itemBuilder: (context, index) => Card(
                          child: ListTile(
                            title: Text(currentPatientList[index].firstName +
                                " " +
                                currentPatientList[index].lastName),
                            subtitle: Text(
                              'Height:' +
                                  waitingList[index].height.toString() +
                                  ' Weight: ' +
                                  waitingList[index].weight.toString(),
                            ),
                            //  trailing: Text("Pending"),
                          ),
                        ))
          ],
        ),
        // Text('TO SHOW LIST'),
      );
}
