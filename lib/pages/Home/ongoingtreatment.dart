import 'package:flutter/material.dart';
class OngoingTreatment extends StatefulWidget {
  const OngoingTreatment({ Key? key }) : super(key: key);

  @override
  _OngoingTreatmentState createState() => _OngoingTreatmentState();
}

class _OngoingTreatmentState extends State<OngoingTreatment> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(child: Text("Ongoing Treatment"),),
    );
  }
}