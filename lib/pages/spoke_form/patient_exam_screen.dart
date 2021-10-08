//@dart=2.9
import 'package:ccarev2_frontend/components/default_button.dart';
import 'package:ccarev2_frontend/main/domain/examination.dart';
import 'package:ccarev2_frontend/main/domain/report.dart';
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/state_management/main/main_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import '../../utils/size_config.dart';

class PatientExamScreen extends StatefulWidget {
  final MainCubit mainCubit;

  const PatientExamScreen({Key key, this.mainCubit}) : super(key: key);
  @override
  _PatientExamScreenState createState() => _PatientExamScreenState();
}

class _PatientExamScreenState extends State<PatientExamScreen> {
  final _formKey = GlobalKey<FormState>();
  Examination report;
  bool editReport = false;
  YN aspirin_loading;
  YN c_p_t_loading;
  String lmwh;
  String statins;
  String beta_blockers;
  String nitrates;
  String diuretics;
  String acei_arb;
  YN tnk_alu_stk_successfull;
  YN death;
  YN referral;
  String reason_for_referral;

  @override
  void initState() {
    super.initState();
    _fetchReport();
  }

  _fetchReport() async {
    print("Fetching patient report");
    await widget.mainCubit.fetchPatientReport();
  }

  _updateForm(Examination report) {
    aspirin_loading = report.aspirin_loading;
    c_p_t_loading = report.c_p_t_loading;
    lmwh = report.lmwh;
    statins = report.statins;
    beta_blockers = report.beta_blockers;
    nitrates = report.nitrates;
    diuretics = report.diuretics;
    acei_arb = report.acei_arb;
    tnk_alu_stk_successfull = report.tnk_alu_stk_successfull;
    death = report.death;
    referral = report.referral;
    reason_for_referral = report.reason_for_referral;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return CubitConsumer<MainCubit, MainState>(
      cubit: widget.mainCubit,
      builder: (_, state) {
        return buildBody();
      },
      listener: (context, state) {
        if (state is PatientExamReportFetched) {
          print("Patient Report Fetched state Called");
          report = state.ereport;
          _updateForm(report);
          _hideLoader();
          // _showMessage("Patient report fetched");
        }
        if (state is EditPatientExamReport) {
          _hideLoader();
          editReport = true;
          // _showMessage("Edit Patient Report");
        }
        if (state is ViewPatientExamReport) {
          _hideLoader();
          editReport = false;
          widget.mainCubit.fetchPatientReport();
          // _showMessage("View Patient Report");
        }
        if (state is PatientExamReportSaved) {
          print("Patient Report Saved state Called");
          _hideLoader();
          // _showMessage(state.msg);
          print(state.msg);
        } else if (state is ErrorState) {
          print('Error State Called 2');
          _hideLoader();
          // _showMessage(state.error);
          print(state.error);
        }
      },
    );
  }

  buildBody() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Medical Form'),
        actions: [
          IconButton(
            onPressed: () async {
              // _showMessage("Refresh Button Pressed");
              print('Refresh button pressed');
              _fetchReport();
            },
            icon: Icon(Icons.refresh),
          ),
          editReport
              ? TextButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      Examination report = Examination(
                          aspirin_loading: aspirin_loading,
                          c_p_t_loading: c_p_t_loading,
                          lmwh: lmwh,
                          statins: statins,
                          beta_blockers: beta_blockers,
                          nitrates: nitrates,
                          diuretics: diuretics,
                          acei_arb: acei_arb,
                          tnk_alu_stk_successfull: tnk_alu_stk_successfull,
                          death: death,
                          referral: referral,
                          reason_for_referral: reason_for_referral);
                      print(report.toJson());
                      widget.mainCubit.savePatientExamReport(report);
                      widget.mainCubit.viewPatientExamReport();
                    }
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : TextButton(
                  onPressed: () async {
                    widget.mainCubit.editPatientReport();
                  },
                  child: Text(
                    "Edit",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        height: SizeConfig.screenHeight,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.02),
              _buildReportDetails(),
              editReport ? _buildForm() : _buildReport(),
              SizedBox(height: SizeConfig.screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  _buildReport() => SizedBox(
        height: SizeConfig.screenHeight * 0.70,
        width: SizeConfig.screenWidth * 0.85,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: getProportionateScreenHeight(20)),
              // ECG Type
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Aspirin Loading: '),
                  Text(aspirin_loading == null
                      ? YN.nill
                      : aspirin_loading.toString().split('.')[1]),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              // ECG Type
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('CPT Loading: '),
                  Text(aspirin_loading == null
                      ? YN.nill
                      : aspirin_loading.toString().split('.')[1]),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              // ECG Time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('LMWH: '),
                  Text(lmwh == null ? "nill" : lmwh),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              // ECG Time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Statins: '),
                  Text(statins == null ? "nill" : statins),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              // ECG Time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Beta-Blockers: '),
                  Text(beta_blockers == null ? "nill" : beta_blockers),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              // ECG Time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Nitrates: '),
                  Text(nitrates == null ? "nill" : nitrates),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              // ECG Time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Diuretics: '),
                  Text(diuretics == null ? "nill" : diuretics),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              // ECG Time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('ACEI ARB: '),
                  Text(acei_arb == null ? "nill" : acei_arb),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              // ECG Type
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('TNK ALU STK Successfull: '),
                  Text(tnk_alu_stk_successfull == null
                      ? YN.nill
                      : tnk_alu_stk_successfull.toString().split('.')[1]),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              // ECG Type
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Death: '),
                  Text(
                      death == null ? YN.nill : death.toString().split('.')[1]),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              // ECG Type
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Referral: '),
                  Text(referral == null
                      ? YN.nill
                      : referral.toString().split('.')[1]),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              // ECG Time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Reason for referral: '),
                  Text(reason_for_referral == null
                      ? "nill"
                      : reason_for_referral),
                ],
              ),

              const SizedBox(height: 30),
              SizedBox(height: SizeConfig.bottomInsets),
            ],
          ),
        ),
      );

  _buildForm() => SizedBox(
        height: SizeConfig.screenHeight * 0.70,
        width: SizeConfig.screenWidth * 0.85,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: getProportionateScreenHeight(20)),
                // ECG Time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Aspirin Loading: '),
                    Container(
                      width: SizeConfig.screenWidth * 0.4,
                      child: DropdownButton<YN>(
                        value: aspirin_loading,
                        isDense: false,
                        onChanged: (YN newValue) {
                          setState(() {
                            aspirin_loading = newValue;
                          });
                        },
                        items: YN.values.map((YN value) {
                          return DropdownMenuItem<YN>(
                            value: value,
                            child: Text(value.toString().split('.')[1]),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                // ECG Time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('CPT Loading: '),
                    Container(
                      width: SizeConfig.screenWidth * 0.4,
                      child: DropdownButton<YN>(
                        value: c_p_t_loading,
                        isDense: false,
                        onChanged: (YN newValue) {
                          setState(() {
                            c_p_t_loading = newValue;
                          });
                        },
                        items: YN.values.map((YN value) {
                          return DropdownMenuItem<YN>(
                            value: value,
                            child: Text(value.toString().split('.')[1]),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('LMWH: '),
                    Container(
                      width: SizeConfig.screenWidth * 0.4,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        focusNode: null,
                        initialValue: lmwh != null ? lmwh : null,
                        onSaved: (newValue) => lmwh = newValue,
                        // validator: (value) => value.isEmpty ? "nill" : null,
                        decoration: const InputDecoration(
                          hintText: "Enter LMWH",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Statins: '),
                    Container(
                      width: SizeConfig.screenWidth * 0.4,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        focusNode: null,
                        initialValue: statins != null ? statins : null,
                        onSaved: (newValue) => statins = newValue,
                        // validator: (value) => value.isEmpty ? "nill" : null,
                        decoration: const InputDecoration(
                          hintText: "Enter Statins",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Beta Blockers: '),
                    Container(
                      width: SizeConfig.screenWidth * 0.4,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        focusNode: null,
                        initialValue:
                            beta_blockers != null ? beta_blockers : null,
                        onSaved: (newValue) => beta_blockers = newValue,
                        // validator: (value) => value.isEmpty ? "nill" : null,
                        decoration: const InputDecoration(
                          hintText: "Enter Beta-Blockers",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Nitrates: '),
                    Container(
                      width: SizeConfig.screenWidth * 0.4,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        focusNode: null,
                        initialValue: nitrates != null ? nitrates : null,
                        onSaved: (newValue) => nitrates = newValue,
                        // validator: (value) => value.isEmpty ? "nill" : null,
                        decoration: const InputDecoration(
                          hintText: "Enter Nitrates",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Diuretics: '),
                    Container(
                      width: SizeConfig.screenWidth * 0.4,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        focusNode: null,
                        initialValue: diuretics != null ? diuretics : null,
                        onSaved: (newValue) => lmwh = newValue,
                        // validator: (value) => value.isEmpty ? "nill" : null,
                        decoration: const InputDecoration(
                          hintText: "Enter Diuretics",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('ACEI ARB: '),
                    Container(
                      width: SizeConfig.screenWidth * 0.4,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        focusNode: null,
                        initialValue: acei_arb != null ? acei_arb : null,
                        onSaved: (newValue) => acei_arb = newValue,
                        // validator: (value) => value.isEmpty ? "nill" : null,
                        decoration: const InputDecoration(
                          hintText: "Enter ACEI ARB",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                // TNK
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('TNK ALU STK Successfull: '),
                    Container(
                      width: SizeConfig.screenWidth * 0.4,
                      child: DropdownButton<YN>(
                        value: tnk_alu_stk_successfull,
                        isDense: false,
                        onChanged: (YN newValue) {
                          setState(() {
                            tnk_alu_stk_successfull = newValue;
                          });
                        },
                        items: YN.values.map((YN value) {
                          return DropdownMenuItem<YN>(
                            value: value,
                            child: Text(value.toString().split('.')[1]),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                // Death
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Death: '),
                    Container(
                      width: SizeConfig.screenWidth * 0.4,
                      child: DropdownButton<YN>(
                        value: death,
                        isDense: false,
                        onChanged: (YN newValue) {
                          setState(() {
                            death = newValue;
                          });
                        },
                        items: YN.values.map((YN value) {
                          return DropdownMenuItem<YN>(
                            value: value,
                            child: Text(value.toString().split('.')[1]),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                // Reason for referral
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Referral: '),
                    Container(
                      width: SizeConfig.screenWidth * 0.4,
                      child: DropdownButton<YN>(
                        value: referral,
                        isDense: false,
                        onChanged: (YN newValue) {
                          setState(() {
                            referral = newValue;
                          });
                        },
                        items: YN.values.map((YN value) {
                          return DropdownMenuItem<YN>(
                            value: value,
                            child: Text(value.toString().split('.')[1]),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                SizedBox(height: SizeConfig.bottomInsets),
              ],
            ),
          ),
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

  // _showMessage(String msg) {
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //     backgroundColor: Theme.of(context).accentColor,
  //     content: Text(
  //       msg,
  //       style: Theme.of(context)
  //           .textTheme
  //           .caption
  //           .copyWith(color: Colors.white, fontSize: 16),
  //     ),
  //   ));
  // }

  _buildReportDetails() => Column(children: [
        Container(
          width: SizeConfig.screenWidth,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Text(
            "Exam Report's Details",
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 18),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.red[100],
            borderRadius: BorderRadius.circular(20),
          ),
          width: SizeConfig.screenWidth,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Last Edited: "),
                  Text("10th Sept, 2021"),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Edited By: "),
                  Text("Dr. Doom\nApollo Medical Hospital",
                      textAlign: TextAlign.right),
                ],
              ),
            ],
          ),
        ),
      ]);
}
