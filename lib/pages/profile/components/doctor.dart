//@dart=2.9
import 'package:ccarev2_frontend/components/default_button.dart';
import 'package:ccarev2_frontend/state_management/profile/profile_cubit.dart';
import 'package:ccarev2_frontend/state_management/profile/profile_state.dart';
import 'package:ccarev2_frontend/user/domain/credential.dart';
import 'package:ccarev2_frontend/user/domain/doc_info.dart';
import 'package:ccarev2_frontend/user/domain/profile.dart';
import 'package:ccarev2_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
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
  String name;
  String hospital;
  Info docInfo;
  @override
  void initState() {
    widget.cubit.getDocInfo();
    super.initState();
    widget.cubit.getDocInfo();
  }

  @override
  Widget build(BuildContext ctx) {
    // ProfileCubit cubit = CubitProvider.of<ProfileCubit>(ctx);

    return CubitConsumer<ProfileCubit, ProfileState>(
        cubit: widget.cubit,
        builder: (ctx, state) {
          if (state is DocInfoState) {
            docInfo = state.docInfo;
            return _buildOldForm();
          }

          // if(state is DocNotFoundState)
          // {
          return _buildNewForm();
          // }
          // return Center(
          //   child: CircularProgressIndicator(
          //     backgroundColor: Colors.green,
          //   ),
          // );
        },
        listener: (ctx, state) {
          if (state is LoadingDocInfo) {
          } else if (state is ErrorState) {
            _showMessage(state.error);
          }
        });
  }

  _buildNewForm() => Form(
        key: _formKeyDoctor,
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
              keyboardType: TextInputType.text,
              onSaved: (newValue) => hospital = newValue,
              validator: (value) =>
                  value.isEmpty ? "Hospital is required" : null,
              decoration: const InputDecoration(
                labelText: "Hospital",
                hintText: "Enter your Hospital",
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              onSaved: (newValue) => _email = newValue,
              validator: (value) => value.isEmpty ? "Email is required" : null,
              decoration: const InputDecoration(
                labelText: "Email",
                hintText: "Enter your Email",
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
            SizedBox(height: 1.h),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, top: 5),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Type: '),
                  Text(widget.userType.toString().split('.')[1]),
                ],
              ),
            ),
            SizedBox(height: 1.h),
            SizedBox(height: 1.h),
            Center(
              child: DefaultButton(
                text: "Save",
                press: () async {
                  if (_formKeyDoctor.currentState.validate()) {
                    _formKeyDoctor.currentState.save();
                    lloc.LocationData locationData = await _getLocation();
                    var profile = DoctorProfile(
                      name: name,
                      hospitalName: hospital,
                      phoneNumber: "8580405100",
                      email: _email,
                      location: loc.Location(
                          latitude: locationData.latitude,
                          longitude: locationData.longitude),
                      type: widget.userType,
                    );
                    widget.cubit.addDoctorProfile(profile);
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

  _buildOldForm() => Form(
        key: _formKeyDoctor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 1.h),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Name: ', style: TextStyle(fontSize: 12.sp)),
                  Text(docInfo.name, style: TextStyle(fontSize: 12.sp)),
                ],
              ),
            ),
            SizedBox(height: 1.h),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Hospital: ', style: TextStyle(fontSize: 12.sp)),
                  Text(docInfo.hospital, style: TextStyle(fontSize: 12.sp)),
                ],
              ),
            ),
            SizedBox(height: 1.h),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Phone: '),
                  Text(docInfo.phone),
                ],
              ),
            ),
            SizedBox(height: 1.h),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Type: '),
                  Text(widget.userType.toString().split('.')[1]),
                ],
              ),
            ),
            SizedBox(height: 1.h),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, top: 5),
              child: TextButton(
                child: Text('Pick your location',
                    style: TextStyle(fontSize: 12.sp)),
                onPressed: () {},
              ),
            ),
            SizedBox(height: 1.h),
            //Email
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Email ID: ', style: TextStyle(fontSize: 12.sp)),
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
            // SizedBox(height : 1.h),
            // Container(
            //   padding: EdgeInsets.only(left: 15, right: 15, top: 5),
            //
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
            //                 fontSize :12.sp,
            //               ),
            //               hint: Text('Select Doctor Type'),
            //               onChanged: (DoctorType newValue) {
            //                 setState(() {
            //                   _doctorType = newValue;
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
                      name: docInfo.name,
                      hospitalName: docInfo.hospital,
                      phoneNumber: docInfo.phone,
                      email: _email,
                      location: loc.Location(
                          latitude: locationData.latitude,
                          longitude: locationData.longitude),
                      type: widget.userType,
                    );
                    widget.cubit.addDoctorProfile(profile);
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

  _showLoader() {
    var alert = const AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Center(
          child: CircularProgressIndicator(
        backgroundColor: Colors.green,
      )),
    );

    showDialog(
        context: context, barrierDismissible: true, builder: (_) => alert);
  }

  _hideLoader() {
    Navigator.of(context, rootNavigator: true).pop();
  }

  _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).accentColor,
      content: Text(
        msg,
        style: Theme.of(context).textTheme.caption.copyWith(fontSize: 12.sp),
      ),
    ));
  }

  Future<lloc.LocationData> _getLocation() async {
    lloc.LocationData _location = await lloc.Location().getLocation();
    return _location;
  }
}
