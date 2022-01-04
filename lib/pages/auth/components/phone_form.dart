import 'package:ccarev2_frontend/customBuilds/customtextformfield.dart';
import 'package:ccarev2_frontend/state_management/user/user_cubit.dart';
import 'package:ccarev2_frontend/utils/constants.dart';
import 'package:ccarev2_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class PhoneForm extends StatefulWidget {
  final UserCubit cubit;
  final Function verifyPhone;
  final Function backPressed;
  const PhoneForm(this.cubit, this.verifyPhone, this.backPressed);

  @override
  _PhoneFormState createState() => _PhoneFormState();
}

class _PhoneFormState extends State<PhoneForm> {
  final _formKey = GlobalKey<FormState>();
  String _phone = "";
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      color: Colors.white,
      width: double.infinity,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.02),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => widget.backPressed(context),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                    ),
                    const Text(
                      'Enter Mobile Number',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      '+91',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 18,
                      ),
                    ),
                    CustomTextFormField(
                        hint: "Mobile Number",
                        obscureText: false,
                        keyboardType: TextInputType.number,
                        color: kPrimaryColor,
                        width: MediaQuery.of(context).size.width * 0.70,
                        backgroundColor: Colors.white,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          _phone = value;
                        },
                        validator: (phone) => phone.isEmpty
                            ? "Please enter a Phone Number"
                            : phone.length != 10
                                ? "Please enter a valid Phone Number"
                                : null),
                  ],
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.06),
                RaisedButton(
                  onPressed: () async {
                    print('LOGIN BUTTON CLICKED');
                    if (_formKey.currentState!.validate()) {
                      widget.cubit.verifyPhone(_phone);
                    }
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.all(0),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    decoration: ShapeDecoration(
                      color: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
