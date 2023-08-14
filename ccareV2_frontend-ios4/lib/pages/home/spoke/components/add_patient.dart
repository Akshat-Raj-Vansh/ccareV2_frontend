import 'package:ccarev2_frontend/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../components/default_button.dart';
import '../../../../state_management/main/main_cubit.dart';
import '../../../../state_management/main/main_state.dart';
import '../../../../user/domain/profile.dart';
import '../../../../utils/size_config.dart';

class AddPatientScreen extends StatefulWidget {
  final MainCubit cubit;
  AddPatientScreen(this.cubit);

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final _formKeyPatient = GlobalKey<FormState>();
  late String name;
  late int age;
  Gender gender = Gender.MALE;
  late String phone;
  _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      content: Text(
        msg,
        style: Theme.of(context)
            .textTheme
            .bodySmall!
            .copyWith(color: Colors.white, fontSize: 12.sp),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          'Add Patient',
          style: TextStyle(fontSize: 16.sp, color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: BlocConsumer<MainCubit, MainState>(
        bloc: widget.cubit,
        builder: (_, state) {
          return _buildUI(context);
        },
        listener: (context, state) async {
          print("Add Patient State $state");
          if (state is PatientAdded) {
            _showMessage("Patient Added Successfully");
            Navigator.pop(context);
            widget.cubit.getAllPatients();
          }
        },
      ),
    );
  }

  _buildUI(BuildContext context) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKeyPatient,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 2.h),
              TextFormField(
                keyboardType: TextInputType.text,
                onSaved: (newValue) => name = newValue!,
                validator: (value) =>
                    value!.isEmpty ? "Name is required" : null,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  hintText: "Enter your Full Name",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
              SizedBox(height: 1.h),
              TextFormField(
                keyboardType: TextInputType.number,
                onSaved: (newValue) => age = int.parse(newValue!),
                validator: (value) => value!.isEmpty
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
                      onChanged: (newValue) {
                        setState(() {
                          gender = newValue!;
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
              SizedBox(height: 1.h),
              TextFormField(
                keyboardType: TextInputType.number,
                onSaved: (newValue) =>
                    {if (newValue!.length <= 10) phone = newValue},
                validator: (value) => value!.isEmpty
                    ? "Phone Number is required"
                    : (value.length != 10 ||
                            value.contains(RegExp(r'[A-Z][a-z]'))
                        ? "Enter a valid Phone Number"
                        : null),
                decoration: const InputDecoration(
                  labelText: "Phone Number ",
                  hintText: "Enter your Phone Number",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
              //SizedBox(height : 1.h),
              const Spacer(
                flex: 1,
              ),
              Center(
                child: DefaultButton(
                  text: "Save",
                  press: () {
                    if (_formKeyPatient.currentState!.validate()) {
                      _formKeyPatient.currentState!.save();
                      var profile = PatientProfile(
                          name: name,
                          gender: gender.toString().split(".")[1],
                          age: age);
                      //print(profile.toString());
                      widget.cubit.addPatient(profile, phone);
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
        ),
      );
}
