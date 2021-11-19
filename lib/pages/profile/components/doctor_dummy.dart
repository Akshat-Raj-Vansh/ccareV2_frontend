//@dart=2.9
import 'package:ccarev2_frontend/components/default_button.dart';
import 'package:ccarev2_frontend/state_management/profile/profile_cubit.dart';
import 'package:ccarev2_frontend/user/domain/details.dart';
import 'package:ccarev2_frontend/user/domain/profile.dart';
import 'package:ccarev2_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:location/location.dart' as lloc;
import '../../../user/domain/location.dart' as loc;

class DoctorProfileScreen extends StatefulWidget {
  final ProfileCubit cubit;
  final Details details;
  const DoctorProfileScreen(this.cubit, this.details);

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  final _formKeyDoctor = GlobalKey<FormState>();

//  _docID: string,
//   name: string,
//   hospitalName:string,
//   email: string,
//   phoneNumber:string,
//   type:string,
//   location: { coordinates: Location };

  String _email;
  DoctorType _doctorType;

  @override
  void initState() {
    print("DOCTOR PROFILE");
    print("DETAILS");
    print(widget.details.toJson());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = CubitProvider.of<ProfileCubit>(context);
    return Form(
      key: _formKeyDoctor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: getProportionateScreenHeight(10)),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Name: ', style: TextStyle(fontSize: 16)),
                Text(widget.details.name, style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Hospital: ', style: TextStyle(fontSize: 16)),
                Text(widget.details.hospital, style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
          // SizedBox(height: getProportionateScreenHeight(10)),
          // Container(
          //   padding: EdgeInsets.only(left: 15, right: 15, top: 5),
          //   color: Colors.white,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text('Phone: '),
          //       Text(widget.details.phone_number),
          //     ],
          //   ),
          // ),
          SizedBox(height: getProportionateScreenHeight(10)),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 5),
            child: TextButton(
              child: Text('Pick your location', style: TextStyle(fontSize: 16)),
              onPressed: () {},
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          //Email
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 5),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Email ID: ', style: TextStyle(fontSize: 16)),
                Container(
                  width: SizeConfig.screenWidth * 0.4,
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    focusNode: null,
                    initialValue: "",
                    onSaved: (newValue) => _email = newValue,
                    decoration: const InputDecoration(
                      hintText: "Enter Email ID",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 5),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Doctor Type: '),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<DoctorType>(
                        value: _doctorType,
                        iconSize: 30,
                        icon: (null),
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                        hint: Text('Select Doctor Type'),
                        onChanged: (DoctorType newValue) {
                          setState(() {
                            _doctorType = newValue;
                            print(_doctorType);
                          });
                        },
                        items: DoctorType.values.map((DoctorType value) {
                          return DropdownMenuItem<DoctorType>(
                            value: value,
                            child: Text(value.toString().split('.')[1]),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
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
                    name: widget.details.name,
                    hospitalName: widget.details.hospital,
                    phoneNumber: widget.details.phone_number,
                    email: _email,
                    location: loc.Location(
                        latitude: locationData.latitude,
                        longitude: locationData.longitude),
                    type: _doctorType,
                  );
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
  }

  Future<lloc.LocationData> _getLocation() async {
    lloc.LocationData _location = await lloc.Location().getLocation();
    print(_location.latitude.toString() + "," + _location.longitude.toString());
    return _location;
  }
}
