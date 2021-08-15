//@dart=2.9
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../utils/size_config.dart';

class Food extends StatefulWidget {
  const Food({Key key}) : super(key: key);

  @override
  _FoodState createState() => _FoodState();
}

class _FoodState extends State<Food> {
  List<String> breakfast = [
    "Halwa",
    "Puri",
    "Things you'll like",
    "Whatever you wanna eat"
  ];
  List<int> breakfast_cals = [154, 857, 75, 57];
  List<Color> color = [Colors.amber, Colors.blue, Colors.green, Colors.red];
  List<String> data;
  List<int> data_cal;
  List<String> lunch = [
    "MaaRajma",
    "Puri Halwa",
    "Things you'll like and you love greatly",
    "Whatever you wanna eat and which will make you happy"
  ];
  List<int> lunch_cals = [155, 8457, 745, 547];
  @override
  void initState() {
    super.initState();
    data = breakfast;
    data_cal = breakfast_cals;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: Stack(
            children: [
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.arrow_back,
                    size: getProportionateScreenHeight(32),
                  )),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding:
                      EdgeInsets.only(top: getProportionateScreenWidth(20)),
                  alignment: Alignment.topCenter,
                  width: getProportionateScreenWidth(100),
                  height: SizeConfig.screenHeight,
                  color: Colors.blue[50],
                  child: Image(image: AssetImage('assets/logo.png')),
                ),
              ),
              _buildbody(context),
            ],
          ),
        ),
      ),
    );
  }

  _buildbody(BuildContext context) => Container(
        padding: EdgeInsets.only(
            top: getProportionateScreenHeight(35),
            left: getProportionateScreenWidth(30)),
        height: SizeConfig.screenHeight,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            margin: EdgeInsets.only(left: getProportionateScreenWidth(10)),
            child: RichText(
                text: TextSpan(
                    text: "Hello, Patient\n",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: getProportionateScreenHeight(24),
                        fontWeight: FontWeight.bold),
                    children: [
                  TextSpan(
                      text: "Here the recipe for today!",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: getProportionateScreenHeight(16)))
                ])),
          ),
          SizedBox(
            height: getProportionateScreenHeight(24),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            RotatedBox(
              quarterTurns: 3,
              child: Container(
                width: getProportionateScreenHeight(400),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  textDirection: TextDirection.rtl,
                  children: [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            data = breakfast;
                            data_cal = breakfast_cals;
                          });

                          print("BreakFast");
                        },
                        child: Text("Breakfast",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: getProportionateScreenHeight(16)))),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            data = lunch;
                            data_cal = lunch_cals;
                          });
                        },
                        child: Text("Lunch",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: getProportionateScreenHeight(16)))),
                    TextButton(
                      onPressed: () {},
                      child: Text("Dinner",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: getProportionateScreenHeight(16))),
                    ),
                    TextButton(
                        onPressed: () {},
                        child: Text("Extra",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: getProportionateScreenHeight(16))))
                  ],
                ),
              ),
            ),
            SizedBox(width: getProportionateScreenWidth(40)),
            SizedBox(
              height: 400,
              width: SizeConfig.screenWidth - getProportionateScreenWidth(120),
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: data.length,
                itemBuilder: (context, index) => Container(
                  height: 400,
                  width: getProportionateScreenWidth(180),
                  child: Card(
                    color: color[index],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Stack(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30.0),
                        child: Image(
                          image: AssetImage("assets/logo.png"),
                          width: 200,
                          height: 200,
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 30, horizontal: 30),
                          alignment: Alignment.bottomLeft,
                          child: Text(data[index] + "\n${data_cal[index]}")),
                    ]),
                  ),
                ),
                separatorBuilder: (BuildContext context, int index) =>
                    SizedBox(width: 20),
              ),
            )
          ]),
          SizedBox(height: getProportionateScreenHeight(24)),
          Text(
            "Fruits",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Container(
            height: getProportionateScreenHeight(200),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: data.length,
              itemBuilder: (context, index) => Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    height: getProportionateScreenHeight(150),
                    width: getProportionateScreenWidth(150),
                    margin: EdgeInsets.only(top: 75),
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: color[index],
                        borderRadius: BorderRadius.circular(30)),
                    child: Text(data[index] + "\n${data_cal[index]}"),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Image(
                      image: AssetImage('assets/logo.png'),
                      width: 150,
                      height: 150,
                    ),
                  ),
                ],
              ),
              separatorBuilder: (BuildContext context, int index) =>
                  SizedBox(width: 20),
            ),
          )
        ]),
      );
}
