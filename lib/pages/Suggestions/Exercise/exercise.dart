import 'package:flutter/material.dart';
import '../../../utils/size_config.dart';

class ExercisePage extends StatefulWidget {
  const ExercisePage({Key? key}) : super(key: key);

  @override
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  List<String> breakfast = [
    "Halwa",
    "Puri",
    "Things you'll like",
    "Whatever you wanna eat"
  ];
  List<int> breakfast_cals = [154, 857, 75, 57];
  List<Color> color = [Colors.amber, Colors.blue, Colors.green, Colors.red];
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
        child: Scaffold(
            body: Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.arrow_back,
            color: Colors.grey,
            size: 30,
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text("Workouts",
              style: TextStyle(fontSize: 24, color: Colors.grey)),
        ),
        SizedBox(height: 20),
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          color: Colors.pink[100],
          child: Container(
            width: SizeConfig.screenWidth,
            height: getProportionateScreenHeight(220),
            padding: EdgeInsets.only(left: 30, bottom: 20, top: 20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: "Athena\n",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 32,
                          fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                            text: "Core, Lower",
                            style: TextStyle(fontSize: 24, color: Colors.grey))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        "Duration",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: RichText(
                            text: TextSpan(
                                text: "1",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                                children: [
                              TextSpan(
                                  text: " 2 3",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16))
                            ])),
                      ),
                      SizedBox(width: 30),
                      Text(
                        "Difficulty",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: RichText(
                            text: TextSpan(
                                text: "1",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                                children: [
                              TextSpan(
                                  text: " 2 3",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16))
                            ])),
                      )
                    ],
                  )
                ]),
          ),
        ),
        SizedBox(height: 50),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text("Categories",
              style: TextStyle(fontSize: 24, color: Colors.grey)),
        ),
        SizedBox(height: 40),
        Container(
          height: getProportionateScreenHeight(300),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: breakfast.length,
            itemBuilder: (context, index) => Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: getProportionateScreenHeight(250),
                  width: getProportionateScreenWidth(150),
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                      color: color[index],
                      borderRadius: BorderRadius.circular(30)),
                  child: Text(breakfast[index] + "\n${breakfast_cals[index]}",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Image(
                    image: AssetImage('assets/logo.png'),
                    width: 150,
                    height: 150,
                  ),
                ),
              ],
            ),
            separatorBuilder: (BuildContext context, int index) =>
                SizedBox(width: 10),
          ),
        )
      ]),
    )));
  }
}
