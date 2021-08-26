//@dart=2.9
import 'package:ccarev2_frontend/state_management/profile/profile_cubit.dart';
import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:ccarev2_frontend/user/domain/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:location/location.dart';
import '../../user/domain/details.dart';
import '../../components/default_button.dart';
import '../auth/auth_page_adapter.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart';

class ProfileUpdateScreen extends StatefulWidget {
  final ProfileCubit cubit;
  final Details details;
  const ProfileUpdateScreen(this.cubit, this.details);

  @override
  _ProfileUpdateScreenState createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final _formKeyDoctor = GlobalKey<FormState>();
  final _formKeyPatient = GlobalKey<FormState>();

  EdgeInsets pad = const EdgeInsets.symmetric(vertical: 5, horizontal: 15);
  BoxDecoration decC = const BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30)));

  String name;
  int age;
  String gender;
  String uniqueCode;
  String specialization;
  String email;
  Map<String, LocationData> location;
  TextStyle styles = const TextStyle(color: Colors.white, fontSize: 18);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   title: Text(
        //     "CardioCare",
        //     style: headingStyle,
        //   ),
        //   centerTitle: true,
        // ),
        body: buildbody());
  }

  buildbody() {
    return SizedBox(
      height: SizeConfig.screenHeight,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: Column(
          children: [
            SizedBox(height: SizeConfig.screenHeight * 0.04),
            _showLogo(context),
            _buildUI(context),
            SizedBox(height: SizeConfig.screenHeight * 0.02),
          ],
        ),
      ),
    );
  }

  _buildUI(BuildContext context) => Expanded(
        child: widget.details.user_type == 'DOCTOR'
            ? _buildDoctorProfile(context)
            : widget.details.user_type == 'PATIENT'
                ? _buildPatientProfile(context)
                : _buildPatientProfile(context),
      );

  _showLogo(BuildContext context) => Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            const Image(
                image: AssetImage("assets/logo.png"),
                width: 192,
                height: 180,
                fit: BoxFit.fill),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                  text: "Personal",
                  style: Theme.of(context).textTheme.caption.copyWith(
                      color: Colors.lightGreen[500],
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: " Details",
                      style: TextStyle(color: Theme.of(context).accentColor),
                    )
                  ]),
            ),
            SizedBox(height: 30)
          ],
        ),
      );
  _buildDoctorProfile(BuildContext context) => Form(
        key: _formKeyDoctor,
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
            TextFormField(
              keyboardType: TextInputType.text,
              onSaved: (newValue) => specialization = newValue.toUpperCase(),
              validator: (value) =>
                  value.isEmpty ? "Specialization is required" : null,
              decoration: const InputDecoration(
                labelText: "Specialization",
                hintText: "Enter your Specialization",
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            TextFormField(
              keyboardType: TextInputType.text,
              onSaved: (newValue) => uniqueCode = newValue.toUpperCase(),
              validator: (value) =>
                  value.isEmpty ? "Unique Code is required" : null,
              decoration: const InputDecoration(
                labelText: "Unique Code",
                hintText: "Enter your Unique Code",
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            TextFormField(
              keyboardType: TextInputType.text,
              onSaved: (newValue) => email = newValue.toLowerCase(),
              validator: (value) => value.isEmpty || !value.contains('@')
                  ? "Email is required"
                  : null,
              decoration: const InputDecoration(
                labelText: "Email",
                hintText: "Enter your Email",
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            TextFormField(
              keyboardType: TextInputType.text,
              onSaved: (newValue) => email = newValue,
              validator: (value) =>
                  value.isEmpty ? "Location is required" : null,
              decoration: const InputDecoration(
                labelText: "Location",
                hintText: "Enter your Location",
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
            Spacer(
              flex: 1,
            ),
            Center(
              child: DefaultButton(
                text: "Save",
                press: () {
                  if (_formKeyDoctor.currentState.validate()) {
                    _formKeyDoctor.currentState.save();
                    var profile = DoctorProfile(
                        name: name,
                        specialization: specialization,
                        uniqueCode: uniqueCode,
                        email: email,
                        location: location);
                    print(profile.toString());
                    widget.cubit.addDoctorProfile(profile);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("All Fields are required"),
                    ));
                  }
                },
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      );

  _buildPatientProfile(BuildContext context) => Form(
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
                    widget.cubit.addPatientProfile(profile);
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
