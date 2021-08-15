//@dart=2.9
import 'package:flutter/material.dart';
import 'package:extras/extras.dart';
import 'package:flutter_cubit/flutter_cubit.dart';

import '../../state_management/main_app/main_state.dart';
import '../../state_management/main_app/main_cubit.dart';

class Self_Assessment extends StatefulWidget {
  final List<QuestionTree> questions;

  const Self_Assessment(this.questions);

  @override
  _Self_AssessmentState createState() => _Self_AssessmentState();
}

class _Self_AssessmentState extends State<Self_Assessment> {
  List<QuestionTree> display = [];
  List<String> answers = [];
  int length = 1;
  TextStyle styles = TextStyle(color: Colors.white, fontSize: 18);
  EdgeInsets pad = EdgeInsets.symmetric(vertical: 5, horizontal: 15);
  BoxDecoration decA = BoxDecoration(
      color: Colors.green,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30)));

  BoxDecoration decC = BoxDecoration(
      color: Colors.green,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30)));
  BoxDecoration decB = BoxDecoration(
      color: Colors.lightBlue,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
          bottomLeft: Radius.circular(30)));

  @override
  void initState() {
    display.add(widget.questions[0]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            shadowColor: Colors.white,
            title: Text(
              "CardioCare",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back, color: Colors.blue))),
        body: buildbody(context));
  }

  buildbody(BuildContext context) {
    return Container(
        height: double.infinity,
        color: Colors.white,
        margin: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: pad,
              decoration: decA,
              child: Text(
                "Please enter correct inputs to ensure proper results",
                style: styles,
              ),
            ),
            Expanded(
              child: ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    if (display[index].status) {
                      print("cmp");
                      return Column(children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                              decoration: decA,
                              padding: pad,
                              child: Text(
                                display[index].question,
                                style: styles,
                              )),
                        ),
                        Align(
                            alignment: Alignment.bottomRight,
                            child: display[index].answers.length == 1
                                ? Container(
                                    padding: pad,
                                    decoration: decB,
                                    margin: EdgeInsets.only(right: 10, top: 10),
                                    child: Text(display[index].answers[0],
                                        style: styles))
                                : Wrap(
                                    children: List<Widget>.generate(
                                        answers.length,
                                        (i) => Container(
                                            padding: pad,
                                            margin: EdgeInsets.only(
                                                right: 10, top: 10),
                                            decoration: decB,
                                            child: Text(
                                                display[index].answers[i],
                                                style: styles)))))
                      ]);
                    }
                    print("here");
                    var check = List<bool>.generate(
                        display[index].options.length, (index) => false);
                    var options =
                        List.generate(display[index].options.length * 2, (i) {
                      if (i % 2 == 0) {
                        return GestureDetector(
                          onTap: () {
                            if (display[index].question_type ==
                                QuestionType.SELECTION) {
                              setState(() {
                                if (display[index].options[i ~/ 2] == "next" &&
                                    answers.isNotEmpty) {
                                  display[index].answer(answers);
                                  var indexes = answers
                                      .map((e) =>
                                          display[index].options.indexOf(e))
                                      .toList();
                                  indexes.sort();
                                  answers = indexes
                                      .map((e) => display[index].options[e])
                                      .toList();
                                  print(answers.join(','));
                                  try {
                                    display.add(widget.questions.firstWhere(
                                        (element) =>
                                            element.parent ==
                                                display[index].question &&
                                            element.when == answers.join(',')));
                                  } catch (e) {
                                    print(e);
                                  } //think about the when logic incase
                                } else if (display[index].options[i ~/ 2] !=
                                    "next") {
                                  if (!answers.contains(
                                      display[index].options[i ~/ 2])) {
                                    answers.add(display[index].options[i ~/ 2]);
                                  } else {
                                    answers.removeWhere((element) =>
                                        element ==
                                        display[index].options[i ~/ 2]);
                                  }
                                }
                              });
                            } else {
                              setState(() {
                                display[index]
                                    .answer([display[index].options[i ~/ 2]]);
                                try {
                                  display.add(widget.questions.firstWhere(
                                      (element) =>
                                          element.parent ==
                                              display[index].question &&
                                          element.when ==
                                              display[index].options[i ~/ 2]));
                                } catch (e) {
                                  print(e);
                                }
                                print(display.length);
                              });
                            }
                          },
                          child: Container(
                              margin: EdgeInsets.only(right: 10, top: 10),
                              padding: pad,
                              decoration: decC,
                              child: display[index].question_type ==
                                      QuestionType.SELECTION
                                  ? Wrap(children: [
                                      Text(display[index].options[(i ~/ 2)],
                                          style: styles),
                                      display[index].options[i ~/ 2] != "next"
                                          ? Icon(Icons.check,
                                              color: answers.contains(
                                                      display[index]
                                                          .options[i ~/ 2])
                                                  ? Colors.white
                                                  : Colors.grey)
                                          : SizedBox(
                                              width: 1,
                                            )
                                    ])
                                  : Text(display[index].options[(i ~/ 2)],
                                      style: styles)),
                        );
                      } else
                        return SizedBox(height: 10);
                    });
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              padding: pad,
                              decoration: decA,
                              child:
                                  Text(display[index].question, style: styles)),
                          SizedBox(height: 10),
                          Wrap(
                              direction: display[index].question_type ==
                                      QuestionType.SELECTION
                                  ? Axis.horizontal
                                  : Axis.vertical,
                              children: [...options])
                        ]);
                  },
                  itemCount: display.length),
            ),
          ],
        ));
  }
}
