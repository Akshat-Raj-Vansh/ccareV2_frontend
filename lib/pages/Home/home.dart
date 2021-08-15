//@dart=2.9
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter_cubit/flutter_cubit.dart';

import '../../components/default_button.dart';
import '../../pages/Suggestions/Exercise/exercise.dart';
import '../../pages/Suggestions/Food/food_suggestion.dart';
import '../../state_management/main_app/main_cubit.dart';
import '../../utils/size_config.dart';

class Home extends StatefulWidget {
  // final MainCubit mainCubit;
  // const Home(this.mainCubit);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<IconData> icons = [
    Icons.medication,
    Icons.food_bank,
    Icons.dangerous,
    Icons.fitness_center
  ];
  List<Widget> suggestion_pages = [
    ExercisePage(),
    Food(),
    Food(),
    ExercisePage()
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
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Stack(children: [
      SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _buildHeader(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "Medicines",
              style: TextStyle(fontSize: 24),
            ),
          ),
          _buildMedications(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "UserFul Resources",
              style: TextStyle(fontSize: 24),
            ),
          ),
          _buildResources(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "Suggestions",
              style: TextStyle(fontSize: 24),
            ),
          ),
          _buildSuggestions(context),
          //
        ]),
      ),
      _buildEmergencyButton(context),
    ]);
  }

  _buildHeader() => Container(
      color: Colors.green[400],
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: ListTile(
        leading: Icon(FontAwesomeIcons.personBooth, color: Colors.white),
        title: Text(
          "You are healthy!!",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        subtitle: Text(
          "Medications and Ongoing treatment ->",
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ));
  _buildEmergencyButton(BuildContext context) => Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 80,
        width: SizeConfig.screenWidth,
        padding: const EdgeInsets.all(5.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          RaisedButton.icon(
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onPressed: () {},
              icon: Icon(
                Icons.phone,
                color: Colors.white,
              ),
              label: Text(
                "Emergency",
                style: TextStyle(color: Colors.white, fontSize: 16),
              )),
          RaisedButton.icon(
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onPressed: () async {
                CubitProvider.of<MainCubit>(context).getQuestions();
                // await widget.mainCubit.getQuestions();
              },
              icon: Icon(
                FontAwesomeIcons.stethoscope,
                color: Colors.white,
              ),
              label: Text("Assess Again",
                  style: TextStyle(color: Colors.white, fontSize: 16)))
        ]),
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
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => suggestion_pages[index]));
                },
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
