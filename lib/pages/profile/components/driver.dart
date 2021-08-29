//@dart=2.9
import 'package:ccarev2_frontend/components/default_button.dart';
import 'package:ccarev2_frontend/state_management/profile/profile_cubit.dart';
import 'package:ccarev2_frontend/user/domain/profile.dart';
import 'package:ccarev2_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:location/location.dart' as lloc;
import '../../../user/domain/location.dart' as loc;

class DriverProfileScreen extends StatefulWidget {
  const DriverProfileScreen();

  @override
  State<DriverProfileScreen> createState() => _DriverProfileScreenState();
}

class _DriverProfileScreenState extends State<DriverProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final _formKeyDriver = GlobalKey<FormState>();
    final cubit = CubitProvider.of<ProfileCubit>(context);
    String name;
    String uniqueCode;
    String plateNumber;
    return Form(
      key: _formKeyDriver,
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
            onSaved: (newValue) => plateNumber = newValue.toUpperCase(),
            validator: (value) =>
                value.isEmpty ? "Plate Number is required" : null,
            decoration: const InputDecoration(
              labelText: "Plate Number",
              hintText: "Enter your Plate Number",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          const Spacer(flex: 1),
          Center(
            child: DefaultButton(
              text: "Save",
              press: () async {
                if (_formKeyDriver.currentState.validate()) {
                  _formKeyDriver.currentState.save();
                  lloc.LocationData locationData = await _getLocation();
                  var profile = DriverProfile(
                      name: name,
                      uniqueCode: uniqueCode,
                      plateNumber: plateNumber,
                      location: loc.Location(
                          latitude: locationData.latitude,
                          longitude: locationData.longitude));
                  print(profile.toString());
                  cubit.addDriverProfile(profile);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("All Fields are required"),
                  ));
                }
              },
            ),
          ),
          const SizedBox(height: 30),
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
