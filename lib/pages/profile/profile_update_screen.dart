//@dart=2.9
import 'package:flutter/material.dart';
import 'package:auth/auth.dart';
import 'package:profile/profile.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import '../../components/default_button.dart';
import '../auth/auth_page_adapter.dart';
import '../../state_management/profile/profile_Cubit.dart';
import '../../state_management/profile/profile_State.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart';

class ProfileUpdateScreen extends StatefulWidget {
  final ProfileCubit cubit;
  const ProfileUpdateScreen(this.cubit);

  @override
  _ProfileUpdateScreenState createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  EdgeInsets pad = EdgeInsets.symmetric(vertical: 5, horizontal: 15);
  BoxDecoration decC = BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30)));

  PageController _controller = PageController();
  String firstName;
  String lastName;
  String hospitalAddress;
  String city;
  String district;
  String dob;
  String state = "Himachal Pradesh";
  int pincode;
  String specialisation;
  String uniqueCode;
  int emergencyContact;
  bool remember = false;
  List<String> districts = [
    "Bilaspur",
    "Chamba",
    "Hamirpur",
    "Kangra",
    "Kullu",
    "Kinnaur",
    "Lahul Spiti",
    "Shimla",
    "Mandi",
    "Sirmaur",
    "Solan"
  ];
  List<String> diseases = [
    "Cardiologist",
    "Audiologist",
    "Dentist",
    "ENT specialist",
    "Gynaecologist",
    "Orthopaedic surgeon",
    "Paediatrician",
    "Psychiatrists"
  ];
  List<String> selected = [];
  DateTime currentDate = DateTime.now();

  TextStyle styles = TextStyle(color: Colors.white, fontSize: 18);

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(1900),
        lastDate: currentDate);
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
        dob = pickedDate.year.toString() +
            "-" +
            pickedDate.month.toString() +
            "-" +
            pickedDate.day.toString();
      });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: !remember
              ? null
              : IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      remember = false;
                    });
                    _controller.previousPage(
                        duration: Duration(microseconds: 1000),
                        curve: Curves.elasticIn);
                  },
                ),
          title: Text(
            "CardioCare",
            style: headingStyle,
          ),
          centerTitle: true,
        ),
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
            !remember
                ? SizedBox(height: SizeConfig.screenHeight * 0.04)
                : SizedBox(height: SizeConfig.screenHeight * 0.02),
            Text(
              !remember ? "Personal Details" : "Medical Details",
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold),
            ),
            _buildUI(context),
            SizedBox(height: SizeConfig.screenHeight * 0.02),
          ],
        ),
      ),
    );
  }

  _buildUI(BuildContext context) => Expanded(
        child: PageView(
          controller: _controller,
          physics: NeverScrollableScrollPhysics(),
          children: [
            buildPersonalDetails(context),
            buildMedicalDetails(context)
          ],
        ),
      );

  Form buildPersonalDetails(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: getProportionateScreenHeight(20)),
          TextFormField(
            keyboardType: TextInputType.text,
            onSaved: (newValue) => firstName = newValue,
            validator: (value) =>
                value.isEmpty ? "First Name is required" : null,
            decoration: InputDecoration(
              labelText: "First Name",
              hintText: "Enter your First Name",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              // floatingLabelBehavior: FloatingLabelBehavior.always,
              // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          TextFormField(
            keyboardType: TextInputType.text,
            onSaved: (newValue) => lastName = newValue,
            validator: (value) =>
                value.isEmpty ? "Last Name is required" : null,
            decoration: InputDecoration(
              labelText: "Last Name",
              hintText: "Enter your Last Name",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
            ),
          ),

          SizedBox(height: getProportionateScreenHeight(10)),
          TextFormField(
            keyboardType: TextInputType.text,
            onSaved: (newValue) => hospitalAddress = newValue,
            validator: (value) => value.isEmpty ? "Address is required" : null,
            decoration: InputDecoration(
              labelText: "Hospital Address",
              hintText: "Enter your Hospital's Address",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
            ),
          ),

          // FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(10)),
          Row(children: [
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.text,
                onSaved: (newValue) => city = newValue,
                validator: (value) => value.isEmpty ? "City is required" : null,
                decoration: InputDecoration(
                  labelText: "City",
                  hintText: "Enter your City",
                  // If  you are using latest version of flutter then lable text and hint text shown like this
                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
                ),
              ),
            ),
            SizedBox(width: 5),
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.number,
                onSaved: (newValue) => pincode = int.parse(newValue),
                onChanged: (value) => pincode = int.parse(value),
                validator: (value) =>
                    value.length != 6 ? "Enter a correct PinCode" : null,
                decoration: InputDecoration(
                  labelText: "Pincode",
                  hintText: "Enter your Pincode",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  // If  you are using latest version of flutter then lable text and hint text shown like this
                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                  // floatingLabelBehavior: FloatingLabelBehavior.always,
                  // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
                ),
              ),
            ),

            // FormError(errors: errors),]
          ]),
          // FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(30)),
          GestureDetector(
              onTap: () => _districtSelection(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("District", style: TextStyle(fontSize: 16)),
                      Icon(Icons.arrow_downward)
                    ],
                  ),
                  SizedBox(height: getProportionateScreenHeight(10)),
                  Text(
                    district == null ? "Select your District" : district,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              )),

          Divider(
            thickness: 1,
            color: Colors.grey,
          ),

          SizedBox(height: getProportionateScreenHeight(20)),
          Text("State", style: TextStyle(color: Colors.black, fontSize: 16)),

          SizedBox(height: getProportionateScreenHeight(10)),
          Text(state, style: TextStyle(color: Colors.black, fontSize: 16)),
          // Row(children: [
          //   Expanded(
          //    child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children:[TextButton.icon(
          //         onPressed: ()=>_districtSelection(),
          //         style: TextButton.styleFrom(
          //           primary:Colors.white
          //         ),
          //         icon:Icon(Icons.arrow_downward, color: Colors.black,),
          //         label:Text("District",style: TextStyle(
          //           color: Colors.black,
          //           fontSize:16
          //         ),)
          //       ),
          //       Center(child: Text(district==null?"Select District":district))]
          //     ),

          //     // child: TextFormField(
          //     //   keyboardType: TextInputType.text,
          //     //   onSaved: (newValue) => district = newValue,

          //     //   validator: (value) =>value.isEmpty?"District is required":null,
          //     //   decoration: InputDecoration(
          //     //     labelText: "District",
          //     //     hintText: "Enter your District",
          //     //     // If  you are using latest version of flutter then lable text and hint text shown like this
          //     //     // if you r using flutter less then 1.20.* then maybe this is not working properly
          //     //     floatingLabelBehavior: FloatingLabelBehavior.always,
          //     //     // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
          //     //   ),
          //     // ),
          //   ),
          //   Expanded(
          //     child: ListTile(
          //      title:Text("State",style: TextStyle(
          //           color: Colors.black,
          //           fontSize:16
          //         )),
          //     subtitle: Text(state),
          //     ),
          //     // child: TextFormField(
          //     //   keyboardType: TextInputType.text,
          //     //   onSaved: (newValue) => state = newValue,

          //     //   validator: (value) =>value.isEmpty?"State is required":null,
          //     //   decoration: InputDecoration(
          //     //     labelText: "State",
          //     //     hintText: "Enter your State",
          //     //     // If  you are using latest version of flutter then lable text and hint text shown like this
          //     //     // if you r using flutter less then 1.20.* then maybe this is not working properly
          //     //     floatingLabelBehavior: FloatingLabelBehavior.always,
          //     //     // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
          //     //   ),
          //     // ),
          //   ),
          //   // FormError(errors: errors),

          //   // FormError(errors: errors),]
          // ]),

          SizedBox(height: getProportionateScreenHeight(40)),
          Center(
            child: DefaultButton(
              text: "Next",
              press: () {
                if (_formKey.currentState.validate()) {
                  if (district != null) {
                    setState(() {
                      remember = true;
                    });
                    _formKey.currentState.save();
                    _controller.nextPage(
                        duration: Duration(microseconds: 1000),
                        curve: Curves.elasticIn);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("All Fields are required"),
                    ));
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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

  _districtSelection() {
    var alert = AlertDialog(
      title: Center(
          child: Text("Districts",
              style: TextStyle(fontSize: 24, color: Colors.blue))),
      scrollable: true,
      backgroundColor: Colors.white,
      elevation: 0,
      content: Center(
          child: Container(
        width: SizeConfig.screenWidth / 2,
        height: 500,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: districts.length,
            itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      district = districts[index];
                    });
                    _hideAlert();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [BoxShadow(color: Colors.black)]),
                    alignment: Alignment.center,
                    child: Text(districts[index],
                        style: TextStyle(fontSize: 24, color: Colors.blue)),
                  ),
                )),
      )),
    );

    showDialog(
        context: context, barrierDismissible: true, builder: (_) => alert);
  }

  _hideAlert() {
    Navigator.of(context, rootNavigator: true).pop();
  }

  Form buildMedicalDetails(BuildContext context) {
    return Form(
      key: _formKey2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            keyboardType: TextInputType.text,
            onSaved: (newValue) => specialisation = newValue,
            validator: (value) =>
                value.isEmpty ? "Specialisation is required" : null,
            decoration: InputDecoration(
              labelText: "Specialisation",
              hintText: "Enter your Specialisation",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          TextFormField(
            keyboardType: TextInputType.text,
            onSaved: (newValue) => uniqueCode = newValue,
            validator: (value) =>
                value.isEmpty ? "Unique Code is required" : null,
            decoration: InputDecoration(
              labelText: "Unique Code",
              hintText: "Enter your Unique Code",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          TextFormField(
            keyboardType: TextInputType.number,
            onSaved: (newValue) => emergencyContact = int.parse(newValue),
            onChanged: (value) => emergencyContact = int.parse(value),
            validator: (value) => emergencyContact == null ||
                    emergencyContact.toString().length != 10
                ? "Emergency Contact is required"
                : null,
            decoration: InputDecoration(
              labelText: "Emergency Contact",
              hintText: "Enter your Emergency Contact",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
          GestureDetector(
              onTap: () => _selectDate(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Date of Birth", style: TextStyle(fontSize: 16)),
                      Icon(Icons.arrow_downward)
                    ],
                  ),
                  SizedBox(height: getProportionateScreenHeight(10)),
                  Text(
                    dob == null ? "Please enter your DOB" : dob,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              )),
          Divider(thickness: 1, color: Colors.grey),
          SizedBox(height: 20),
          Text("Medical Specialisation", style: TextStyle(fontSize: 16)),
          SizedBox(height: 20),
          Wrap(
              children: List<Widget>.generate(
                  diseases.length,
                  (index) => GestureDetector(
                      onTap: () {
                        setState(() {
                          if (selected.contains(diseases[index])) {
                            selected.remove(diseases[index]);
                          } else {
                            selected.add(diseases[index]);
                          }
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 10, top: 10),
                        padding: pad,
                        decoration: decC,
                        child: Wrap(children: [
                          Text(diseases[index], style: styles),
                          Icon(Icons.check,
                              color: selected.contains(diseases[index])
                                  ? Colors.white
                                  : Colors.grey)
                        ]),
                      )))),
          SizedBox(height: getProportionateScreenHeight(40)),
          Center(
            child: DefaultButton(
              text: "Continue",
              press: () {
                if (_formKey2.currentState.validate()) {
                  if (dob != null) {
                    _formKey2.currentState.save();
                    var address = new Address(
                        city: city,
                        district: district,
                        hospitalAddress: hospitalAddress,
                        state: state,
                        pincode: pincode);
                    var profile = new Profile(
                        firstName,
                        lastName,
                        address,
                        currentDate,
                        specialisation,
                        uniqueCode,
                        emergencyContact);
                    print(profile.toString());
                    this.widget.cubit.updateProfile(profile);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("All Fields are required"),
                    ));
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
