//@dart=2.9
import 'package:ccarev2_frontend/components/default_button.dart';
import 'package:ccarev2_frontend/state_management/profile/profile_cubit.dart';
import 'package:ccarev2_frontend/user/domain/profile.dart';
import 'package:ccarev2_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:location/location.dart' as lloc;
import '../../../user/domain/location.dart' as loc;

class DoctorProfileScreen extends StatefulWidget {
  final ProfileCubit cubit;
  final String phone;
  const DoctorProfileScreen(this.cubit, this.phone);

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  final _formKeyDoctor = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var cubit = CubitProvider.of<ProfileCubit>(context);
    String name;
    String hospitalName;
    String email;
    String type;
    return Form(
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
            keyboardType: TextInputType.text,
            onSaved: (newValue) => hospitalName = newValue.toUpperCase(),
            validator: (value) => value.isEmpty ? "Hospital is required" : null,
            decoration: const InputDecoration(
              labelText: "Hospital Name",
              hintText: "Enter your Hospital Name",
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
          const Spacer(flex: 1),
          Center(
            child: DefaultButton(
              text: "Save",
              press: () async {
                if (_formKeyDoctor.currentState.validate()) {
                  _formKeyDoctor.currentState.save();
                  lloc.LocationData locationData = await _getLocation();
                  var profile = DoctorProfile(
                    name: name,
                    hospitalName: hospitalName,
                    phoneNumber: widget.phone,
                    email: email,
                    location: loc.Location(
                        latitude: locationData.latitude,
                        longitude: locationData.longitude),
                    type: "SPOKE",
                  );
                  print(profile.toString());
                  cubit.addDoctorProfile(profile);
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
  }

  Future<lloc.LocationData> _getLocation() async {
    lloc.LocationData _location = await lloc.Location().getLocation();
    print(_location.latitude.toString() + "," + _location.longitude.toString());
    return _location;
  }
}
