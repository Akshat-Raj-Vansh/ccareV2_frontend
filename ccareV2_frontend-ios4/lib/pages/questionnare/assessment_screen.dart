import 'package:ccarev2_frontend/main/domain/assessment.dart';
import 'package:ccarev2_frontend/utils/constants.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';

class AssessmentScreen extends StatefulWidget {
  final List<PatientAssessment> assessment;
  const AssessmentScreen(this.assessment);

  @override
  _AssessmentScreenState createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  TextStyle styles = TextStyle(color: Colors.white, fontSize: 14.sp);
  EdgeInsets pad = const EdgeInsets.symmetric(vertical: 5, horizontal: 15);
  BoxDecoration decA = const BoxDecoration(
      color: kPrimaryColor,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30)));
  BoxDecoration decC = const BoxDecoration(
      color: kPrimaryColor,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30)));
  BoxDecoration decB = const BoxDecoration(
      color: kPrimaryColor,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
          bottomLeft: Radius.circular(30)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            "CardioCare - Patient Assessment",
            style: TextStyle(fontSize: 16.sp, color: Colors.white),
          ),
          // leading: IconButton(
          //   onPressed: () {
          //     Navigator.of(context).pop(true);
          //   },
          //   icon: Icon(Icons.arrow_back, color: kPrimaryColor),
          // ),
        ),
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
                "Following are the self-analysis result of the patient.",
                style: styles,
              ),
            ),
            SingleChildScrollView(
              child: ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => SizedBox(height: 20),
                  itemCount: widget.assessment.length,
                  itemBuilder: (context, index) {
                    return Column(children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                            decoration: decA,
                            padding: pad,
                            child: Text(
                              widget.assessment[index].question,
                              style: styles,
                            )),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                            padding: pad,
                            decoration: decB,
                            margin: EdgeInsets.only(right: 10, top: 10),
                            child: Wrap(
                              children: List<Widget>.generate(
                                widget.assessment[index].answer.length,
                                (ind) => Text(
                                    widget.assessment[index].answer[ind],
                                    style: styles),
                              ),
                            )),
                      ),
                    ]);
                  }),
            ),
          ],
        ));
  }
}
