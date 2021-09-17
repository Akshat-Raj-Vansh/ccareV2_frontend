//@dart=2.9
import 'package:ccarev2_frontend/main/domain/question.dart';
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';

class SelfAssessment extends StatefulWidget {
  final List<QuestionTree> questions;
  final MainCubit cubit;
  const SelfAssessment(this.questions, this.cubit);

  @override
  _SelfAssessmentState createState() => _SelfAssessmentState();
}

class _SelfAssessmentState extends State<SelfAssessment> {
  List<QuestionTree> display = [];
  List<String> answers = [];
  int length = 1;
  TextStyle styles = const TextStyle(color: Colors.white, fontSize: 18);
  EdgeInsets pad = const EdgeInsets.symmetric(vertical: 5, horizontal: 15);
  BoxDecoration decA = const BoxDecoration(
      color: Colors.green,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30)));

  BoxDecoration decC = const BoxDecoration(
      color: Colors.green,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30)));
  BoxDecoration decB = const BoxDecoration(
      color: Colors.lightBlue,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
          bottomLeft: Radius.circular(30)));

  @override
  void initState() {

    display.add(widget.questions.firstWhere((element) => element.parent=="root"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            shadowColor: Colors.white,
            title: const Text(
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
        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
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
                                            margin: const EdgeInsets.only(
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

                                if (display.last.node_type == "RESULT") {
                                  if (display.last.options[0] == "EMERGENCY") {
                                    widget.cubit.notify();
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      backgroundColor:
                                          Theme.of(context).accentColor,
                                      content: Text(
                                        "Emergency Notifications Sent",
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .copyWith(
                                                color: Colors.white,
                                                fontSize: 16),
                                      ),
                                    ));
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
                                  print(display.last.question);

                                  if (display.last.node_type ==
                                      NodeType.RESULT) {
                                    print("INSIDE");
                                    if (display.last.options[0] ==
                                        "EMERGENCY") {
                                      print("Inside");
                                      widget.cubit.notify();
                                    }
                                  }
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
