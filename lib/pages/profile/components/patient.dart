//@dart=2.9
import 'package:ccarev2_frontend/components/default_button.dart';
import 'package:ccarev2_frontend/state_management/profile/profile_cubit.dart';
import 'package:ccarev2_frontend/user/domain/profile.dart';
import 'package:ccarev2_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen();

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final _formKeyPatient = GlobalKey<FormState>();

    final cubit = CubitProvider.of<ProfileCubit>(context);
    String name;
    int age;
    String gender;
    return Form(
      key: _formKeyPatient,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: getProportionateScreenHeight(20)),
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
          SizedBox(height: getProportionateScreenHeight(10)),
          TextFormField(
            keyboardType: TextInputType.number,
            onSaved: (newValue) => age = int.parse(newValue),
            validator: (value) => value.isEmpty ? "Age is required" : null,
            decoration: const InputDecoration(
              labelText: "Age ",
              hintText: "Enter your Age",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          TextFormField(
            keyboardType: TextInputType.text,
            onSaved: (newValue) => gender = newValue.toUpperCase(),
            validator: (value) => value.isEmpty ? "Gender is required" : null,
            decoration: const InputDecoration(
              labelText: "Gender",
              hintText: "Enter your Gender",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          Center(
            child: DefaultButton(
              text: "Save",
              press: () {
                if (_formKeyPatient.currentState.validate()) {
                  _formKeyPatient.currentState.save();
                  var profile =
                      PatientProfile(name: name, gender: gender, age: age);
                  print(profile.toString());
                  cubit.addPatientProfile(profile);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("All Fields are required"),
                  ));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
