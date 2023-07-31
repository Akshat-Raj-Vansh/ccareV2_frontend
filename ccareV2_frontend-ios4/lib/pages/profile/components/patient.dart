//@dart=2.9
import 'package:ccarev2_frontend/state_management/profile/profile_cubit.dart';
import 'package:ccarev2_frontend/user/domain/profile.dart';
import 'package:ccarev2_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/constants.dart';

class PatientProfileScreen extends StatefulWidget {
  final ProfileCubit cubit;
  const PatientProfileScreen(this.cubit);

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  final _formKeyPatient = GlobalKey<FormState>();
  String name;
  int age;
  Gender gender = Gender.MALE;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKeyPatient,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 2.h),
          TextFormField(
            keyboardType: TextInputType.text,
            onSaved: (newValue) => name = newValue,
            validator: (value) => value.isEmpty ? "Name is required" : null,
            decoration: const InputDecoration(
              labelText: "Full Name",
              hintText: "Enter your Full Name",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          SizedBox(height: 1.h),
          TextFormField(
            keyboardType: TextInputType.number,
            onSaved: (newValue) => age = int.parse(newValue),
            validator: (value) => value.isEmpty
                ? "Age is required"
                : (int.parse(value) > 120 ? "Enter valid age" : null),
            decoration: const InputDecoration(
              labelText: "Age ",
              hintText: "Enter your Age",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Gender: '),
              Container(
                width: SizeConfig.screenWidth * 0.4,
                child: DropdownButton<Gender>(
                  isDense: false,
                  value: gender,
                  onChanged: (Gender newValue) {
                    setState(() {
                      gender = newValue;
                      //print(gender);
                    });
                  },
                  items: Gender.values.map((Gender value) {
                    return DropdownMenuItem<Gender>(
                      value: value,
                      child: Text(value.toString().split('.')[1]),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          //SizedBox(height : 1.h),
          const Spacer(
            flex: 1,
          ),
          Center(
            child: GestureDetector(
              child: Container(
                width: MediaQuery.of(context).size.width / 1.5,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                decoration: ShapeDecoration(
                  color: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                ),
              ),
              onTap: () {
                if (_formKeyPatient.currentState.validate()) {
                  _formKeyPatient.currentState.save();
                  var profile = PatientProfile(
                      name: name,
                      gender: gender.toString().split(".")[1],
                      age: age);
                  //print(profile.toString());
                  widget.cubit.addPatientProfile(profile);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("All Fields are required"),
                  ));
                }
              },
            ),
          ),
          SizedBox(height: 5.h),
        ],
      ),
    );
  }
}
