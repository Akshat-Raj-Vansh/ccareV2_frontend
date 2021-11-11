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

  String _email;
  DoctorType _doctorType;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // TODO: Search doctor profile using Phone Number
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
          // LMWH
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 5),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Email ID: '),
                Container(
                  width: SizeConfig.screenWidth * 0.4,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    focusNode: null,
                    initialValue: "",
                    onSaved: (newValue) => _email = newValue,
                    decoration: const InputDecoration(
                      hintText: "Enter LMWH",
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
                        value: DoctorType.NA,
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
                // if (_formKeyDoctor.currentState.validate() &&
                //     _myName != null &&
                //     _myHospital != null &&
                //     _myType != null) {
                //   _formKeyDoctor.currentState.save();
                //   lloc.LocationData locationData = await _getLocation();
                //   var profile = DoctorProfile(
                //     name: name,
                //     hospitalName: hospitalName,
                //     phoneNumber: widget.phone,
                //     email: email,
                //     location: loc.Location(
                //         latitude: locationData.latitude,
                //         longitude: locationData.longitude),
                //     type: "SPOKE",
                //   );
                //   print(profile.toString());
                //   widget.cubit.addDoctorProfile(profile);
                // } else {
                //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                //     content: Text("All Fields are required"),
                //   ));
                //  }
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
