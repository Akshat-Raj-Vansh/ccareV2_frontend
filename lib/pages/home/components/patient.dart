import 'package:ccarev2_frontend/main/domain/question.dart';
import 'package:ccarev2_frontend/pages/emergency/emergency_screen.dart';
import 'package:ccarev2_frontend/pages/home/home_page_adapter.dart';
import 'package:ccarev2_frontend/services/Notifications/notificationContoller.dart';
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/state_management/main/main_state.dart';
import 'package:ccarev2_frontend/state_management/user/user_cubit.dart';
import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:ccarev2_frontend/pages/questionnare/questionnare_screen.dart';
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/state_management/main/main_state.dart';
import 'package:ccarev2_frontend/state_management/user/user_cubit.dart';
import 'package:ccarev2_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';

class PatientHomeUI extends StatefulWidget {
  final MainCubit mainCubit;
  final UserCubit userCubit;
  final IHomePageAdapter homePageAdapter;
  const PatientHomeUI(this.mainCubit, this.userCubit, this.homePageAdapter);

  @override
  State<PatientHomeUI> createState() => _PatientHomeUIState();
}

class _PatientHomeUIState extends State<PatientHomeUI> {
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
    void initState(){
    super.initState();
    NotificationController.configure(widget.mainCubit, UserType.patient,context);
    NotificationController.fcmHandler();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return CubitConsumer<MainCubit, MainState>(builder: (_, state) {
      return _buildUI(context);
    }, listener: (context, state) {
      if (state is LoadingState) {
        print("Loading State Called");
        _showLoader();
      } else if (state is EmergencyState) {
        print("Emergency State Called");
        _hideLoader();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmergencyScreen(),
          ),
        );
      } else if (state is QuestionnaireState) {
        print("Questionnaire State Called");
        _hideLoader();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SelfAssessment(state.questions),
          ),
        );
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

  _buildUI(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('CardioCare - Patient'),
          actions: [
            IconButton(
              onPressed: () => widget.mainCubit.getQuestions(),
              icon: Icon(Icons.help),
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
              _buildEmergencyButton(),
              const SizedBox(height: 10),
              _buildHeader(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  "Medicines",
                  style: TextStyle(fontSize: 24),
                ),
              ),
              _buildMedications(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  "UserFul Resources",
                  style: TextStyle(fontSize: 24),
                ),
              ),
              _buildResources(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  "Suggestions",
                  style: TextStyle(fontSize: 24),
                ),
              ),
              _buildSuggestions(context),
              //
            ]),
          ),
        ]),
      );

  _buildEmergencyButton() => InkWell(
        onTap: () async {
          await widget.mainCubit.notify();
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

  _buildHeader() => Container(
      color: Colors.green[400],
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: ListTile(
        leading: Icon(CupertinoIcons.person, color: Colors.white),
        title: Text(
          "You are healthy!!",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        subtitle: Text(
          "Medications and Ongoing treatment ->",
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ));

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
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16)))),
                ),
              );
            }),
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
          }));
}
