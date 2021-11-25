//@dart=2.9
import 'package:ccarev2_frontend/components/default_button.dart';
import 'package:ccarev2_frontend/state_management/profile/profile_cubit.dart';
import 'package:ccarev2_frontend/state_management/profile/profile_state.dart';
import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:ccarev2_frontend/user/domain/doc_info.dart';
import 'package:ccarev2_frontend/user/domain/profile.dart';
import 'package:ccarev2_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:location/location.dart' as lloc;
import '../../../user/domain/location.dart' as loc;

class DoctorProfileScreen extends StatefulWidget {
  final ProfileCubit cubit;
  final UserType userType;
  const DoctorProfileScreen(this.cubit, this.userType);

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  final _formKeyDoctor = GlobalKey<FormState>();

  String _email;
  Info docInfo;
  @override
  void initState() {
    print("DOCTOR PROFILE");
    print("USERTYPE");
    print(widget.userType.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('CALLING GET DOC INFO');
    widget.cubit.getDocInfo();
    // return CubitConsumer<ProfileCubit, ProfileState>(
    //     cubit: cubit,
    //     builder: (_, state) {
    //       print("INSIDE BUILDER DOCTOR PROFILE");
    //       print("CALLING GET DOC INFO");
    //       print('STATE:');
    //       print(state.toString());
    //       cubit.getDocInfo();
    //       if (state is DocInfoState) {
    //         print("Doc Info State Called");
    //         docInfo = state.docInfo;
    //         _hideLoader();
    //         docInfo = state.docInfo;
    //         return _buildForm();
    //       }
    //       return Center(
    //         child: CircularProgressIndicator(
    //           backgroundColor: Colors.green,
    //         ),
    //       );
    //     },
    //     listener: (context, state) {
    //       if (state is DocInfoState) {
    //         print("Doc Info State Called");
    //         docInfo = state.docInfo;
    //         _hideLoader();
    //         docInfo = state.docInfo;
    //         return _buildForm();
    //       } else if (state is ErrorState) {
    //         print('Error State Called');
    //         _hideLoader();
    //         _showMessage(state.error);
    //       }
    //     });
    return _buildForm();
  }

  _buildForm() => Form(
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
                  Text('docInfo.name', style: TextStyle(fontSize: 16)),
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
                  Text('docInfo.hospital', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, top: 5),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Phone: '),
                  Text('docInfo.phone'),
                ],
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, top: 5),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Type: '),
                  Text('widget.userType.toString().split(\'.\')[1]'),
                ],
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, top: 5),
              child: TextButton(
                child:
                    Text('Pick your location', style: TextStyle(fontSize: 16)),
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
            // SizedBox(height: getProportionateScreenHeight(10)),
            // Container(
            //   padding: EdgeInsets.only(left: 15, right: 15, top: 5),
            //   color: Colors.white,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: <Widget>[
            //       Text('Doctor Type: '),
            //       Expanded(
            //         child: DropdownButtonHideUnderline(
            //           child: ButtonTheme(
            //             alignedDropdown: true,
            //             child: DropdownButton<DoctorType>(
            //               value: _doctorType,
            //               iconSize: 30,
            //               icon: (null),
            //               style: TextStyle(
            //                 color: Colors.black54,
            //                 fontSize: 16,
            //               ),
            //               hint: Text('Select Doctor Type'),
            //               onChanged: (DoctorType newValue) {
            //                 setState(() {
            //                   _doctorType = newValue;
            //                   print(_doctorType);
            //                 });
            //               },
            //               items: DoctorType.values.map((DoctorType value) {
            //                 return DropdownMenuItem<DoctorType>(
            //                   value: value,
            //                   child: Text(value.toString().split('.')[1]),
            //                 );
            //               }).toList(),
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            const Spacer(flex: 1),
            Center(
              child: DefaultButton(
                text: "Save",
                press: () async {
                  if (_formKeyDoctor.currentState.validate()) {
                    _formKeyDoctor.currentState.save();
                    lloc.LocationData locationData = await _getLocation();
                    var profile = DoctorProfile(
                      name: 'Dr. Akshat Raj Vansh',
                      hospitalName: 'MGMSC Rajajipuram Lucknow',
                      phoneNumber: '7355026029',
                      email: _email,
                      location: loc.Location(
                          latitude: locationData.latitude,
                          longitude: locationData.longitude),
                      type: widget.userType,
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

  Future<lloc.LocationData> _getLocation() async {
    lloc.LocationData _location = await lloc.Location().getLocation();
    print(_location.latitude.toString() + "," + _location.longitude.toString());
    return _location;
  }
}
