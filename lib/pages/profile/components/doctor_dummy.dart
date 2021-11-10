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
  const DoctorProfileScreen(this.cubit);

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  final _formKeyDoctor = GlobalKey<FormState>();

  String _specialization;
  String _email;
  String _uniqueCode;

  String _myHospital;
  String _myName;
  DType _myType;
  List<String> hospitals = ['MGMSC Khaneri Rampur', 'NIT Hamirpur'];
  // List<List<String>> doctors = [
  //   ['Dr. XY MKR', 'Dr. MN MKR', 'Dr. WZ MKR'],
  //   ['Dr. XY PHC', 'Dr. MN PHC', 'Dr. WZ PHC'],
  //   ['Dr. XY NIT', 'Dr. MN NIT', 'Dr. WZ NIT']
  // ];
  List<String> doctors = ['Dr. XY MKR', 'Dr. MN MKR', 'Dr. WZ NIT'];
  @override
  Widget build(BuildContext context) {
    var cubit = CubitProvider.of<ProfileCubit>(context);
    return Form(
      key: _formKeyDoctor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 5),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<String>(
                        value: _myHospital,
                        iconSize: 30,
                        icon: (null),
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                        hint: Text('Select Hospital'),
                        onChanged: (String newValue) {
                          setState(() {
                            _myHospital = newValue;
                            print(_myHospital);
                          });
                        },
                        items: hospitals?.map((item) {
                              return new DropdownMenuItem(
                                child: new Text(item),
                                value: item.toString(),
                              );
                            })?.toList() ??
                            [],
                      ),
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
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<String>(
                        value: _myName,
                        iconSize: 30,
                        icon: (null),
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                        hint: Text('Select your Name'),
                        onChanged: (String newValue) {
                          setState(() {
                            _myName = newValue;
                            print(_myName);
                          });
                        },
                        items: doctors?.map((item) {
                              return new DropdownMenuItem(
                                child: new Text(item),
                                value: item.toString(),
                              );
                            })?.toList() ??
                            [],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
          TextFormField(
            keyboardType: TextInputType.text,
            onSaved: (newValue) => _specialization = newValue.toUpperCase(),
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
            onSaved: (newValue) => _uniqueCode = newValue.toUpperCase(),
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
            onSaved: (newValue) => _email = newValue.toLowerCase(),
            validator: (value) => value.isEmpty || !value.contains('@')
                ? "Email is required"
                : null,
            decoration: const InputDecoration(
              labelText: "Email",
              hintText: "Enter your Email",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 5),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<DType>(
                        value: _myType,
                        iconSize: 30,
                        icon: (null),
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                        hint: Text('Select Type'),
                        onChanged: (DType newValue) {
                          setState(() {
                            _myType = newValue;
                            print(_myType);
                          });
                        },
                        items: DType.values.map((DType value) {
                              return DropdownMenuItem<DType>(
                                value: value,
                                child: Text(value.toString().split('.')[1]),
                              );
                            })?.toList() ??
                            [],
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
                if (_formKeyDoctor.currentState.validate() &&
                    _myName != null &&
                    _myHospital != null &&
                    _myType != null) {
                  _formKeyDoctor.currentState.save();
                  lloc.LocationData locationData = await _getLocation();
                  var profile = DoctorProfile(
                    name: _myName,
                    specialization: _specialization,
                    hospitalName: _myHospital,
                    uniqueCode: _uniqueCode, // To add or to be removed
                    email: _email,
                    location: loc.Location(
                        latitude: locationData.latitude,
                        longitude: locationData.longitude),
                    type: _myType,
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
