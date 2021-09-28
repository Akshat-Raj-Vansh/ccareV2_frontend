//@dart=2.9
import 'package:ccarev2_frontend/components/default_button.dart';
import 'package:ccarev2_frontend/main/domain/report.dart';
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/state_management/main/main_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import '../../utils/size_config.dart';

class PatientReportScreen extends StatefulWidget {
  final MainCubit mainCubit;

  const PatientReportScreen({Key key, this.mainCubit}) : super(key: key);
  @override
  _PatientReportScreenState createState() => _PatientReportScreenState();
}

class _PatientReportScreenState extends State<PatientReportScreen> {
  final _formKey = GlobalKey<FormState>();
  Report report;
  String ecgTime;
  ECGType ecg_type = ECGType.nill;
  String trop_i;
  String bp;
  CVS cvs = CVS.nill;
  Onset onset = Onset.nill;
  Severity severity = Severity.nill;
  PainLocation pain_location = PainLocation.nill;
  String duration;
  Radiation radiation = Radiation.nill;
  YN smoker = YN.nill;
  YN diabetic = YN.nill;
  YN hypertensive = YN.nill;
  YN dyslipidaemia = YN.nill;
  YN old_mi = YN.nill;
  YN chest_pain = YN.nill;
  YN sweating = YN.nill;
  YN nausea = YN.nill;
  YN shortness_of_breath = YN.nill;
  YN loss_of_conciousness = YN.nill;
  YN palpitations = YN.nill;
  YN concious = YN.nill;
  YN chest_crepts = YN.nill;
  int pulse_rate;

  @override
  void initState() {
    super.initState();
    // _fetchReport();
  }

  _fetchReport() async {
    print("Fetching patient report");
    await widget.mainCubit.fetchPatientReport();
  }

  _updateForm(Report report) {
    ecgTime = report.ecgTime;
    ecg_type = report.ecg_type;
    trop_i = report.trop_i;
    bp = report.bp;
    cvs = report.cvs;
    onset = report.onset;
    severity = report.severity;
    pain_location = report.pain_location;
    duration = report.duration;
    radiation = report.radiation;
    smoker = report.smoker;
    diabetic = report.diabetic;
    hypertensive = report.hypertensive;
    dyslipidaemia = report.dyslipidaemia;
    old_mi = report.old_mi;
    chest_pain = report.chest_pain;
    sweating = report.sweating;
    nausea = report.nausea;
    shortness_of_breath = report.shortness_of_breath;
    loss_of_conciousness = report.loss_of_conciousness;
    palpitations = report.palpitations;
    concious = report.concious;
    chest_crepts = report.chest_crepts;
    pulse_rate;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(resizeToAvoidBottomInset: false, body: buildbody());
  }

  buildbody() {
    return SizedBox(
      height: SizeConfig.screenHeight,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: Column(
          children: [
            SizedBox(height: SizeConfig.screenHeight * 0.04),
            _showLogo(context),
            _buildUI(context),
            _buildSaveButton(context),
            SizedBox(height: SizeConfig.screenHeight * 0.02),
          ],
        ),
      ),
    );
  }

  _buildUI(BuildContext context) => CubitConsumer<MainCubit, MainState>(
      cubit: widget.mainCubit,
      builder: (_, state) {
        if (state is PatientReportFetched) {
          print("Patient Report Fetched state Called");
          report = state.report;
          _updateForm(report);
          _hideLoader();
          _showMessage("Patient report fetched");
        }
        return _buildForm();
      },
      listener: (context, state) {
        if (state is LoadingState) {
          print("Loading State Called");
          _showLoader();
        } else if (state is PatientReportSaved) {
          print("Patient Report Saved state Called");
          _hideLoader();
          _showMessage(state.msg);
        } else if (state is ErrorState) {
          print('Error State Called 2');
          _hideLoader();
          _showMessage(state.error);
        }
      });

  _buildForm() => SizedBox(
        height: SizeConfig.screenHeight * 0.55,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: getProportionateScreenHeight(20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('ECG Time: '),
                    Container(
                      width: SizeConfig.screenWidth * 0.5,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        onSaved: (newValue) => report.ecgTime = newValue,
                        validator: (value) => value.isEmpty ? "nill" : null,
                        decoration: const InputDecoration(
                          hintText: "Enter ECG Time",
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
                    Text('ECG Type: '),
                    Container(
                      width: SizeConfig.screenWidth * 0.5,
                      child: DropdownButton<ECGType>(
                        value: ecg_type == null ? ECGType.nill : ecg_type,
                        isDense: true,
                        onChanged: (ECGType newValue) {
                          setState(() {
                            ecg_type = newValue;
                          });
                        },
                        items: ECGType.values.map((ECGType value) {
                          return DropdownMenuItem<ECGType>(
                            value: value,
                            child: Text(value.toString().split('.')[1]),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                // SizedBox(height: getProportionateScreenHeight(10)),
                // TextFormField(
                //   keyboardType: TextInputType.text,
                //   onSaved: (newValue) => trop_i = newValue.toUpperCase(),
                //   validator: (value) => value.isEmpty ? "nill" : null,
                //   decoration: const InputDecoration(
                //     labelText: "Trop I",
                //     hintText: "Enter Trop I",
                //     floatingLabelBehavior: FloatingLabelBehavior.always,
                //   ),
                // ),
                // SizedBox(height: getProportionateScreenHeight(10)),
                // TextFormField(
                //   keyboardType: TextInputType.text,
                //   onSaved: (newValue) => bp = newValue.toUpperCase(),
                //   validator: (value) => value.isEmpty ? "nill" : null,
                //   decoration: const InputDecoration(
                //     labelText: "BP",
                //     hintText: "Enter BP",
                //     floatingLabelBehavior: FloatingLabelBehavior.always,
                //   ),
                // ),
                // SizedBox(height: getProportionateScreenHeight(10)),
                // DropdownButton<CVS>(
                //   value: cvs,
                //   isDense: true,
                //   onChanged: (CVS newValue) {
                //     setState(() {
                //       cvs = newValue;
                //     });
                //   },
                //   items: CVS.values.map((CVS value) {
                //     return DropdownMenuItem<CVS>(
                //       value: value,
                //       child: Text(value.toString().split('.')[1]),
                //     );
                //   }).toList(),
                // ),
                // SizedBox(height: getProportionateScreenHeight(10)),
                // DropdownButton<Onset>(
                //   value: onset,
                //   isDense: true,
                //   onChanged: (Onset newValue) {
                //     setState(() {
                //       onset = newValue;
                //     });
                //   },
                //   items: Onset.values.map((Onset value) {
                //     return DropdownMenuItem<Onset>(
                //       value: value,
                //       child: Text(value.toString().split('.')[1]),
                //     );
                //   }).toList(),
                // ),
                // SizedBox(height: getProportionateScreenHeight(10)),
                // DropdownButton<Severity>(
                //   value: severity,
                //   isDense: true,
                //   onChanged: (Severity newValue) {
                //     setState(() {
                //       severity = newValue;
                //     });
                //   },
                //   items: Severity.values.map((Severity value) {
                //     return DropdownMenuItem<Severity>(
                //       value: value,
                //       child: Text(value.toString().split('.')[1]),
                //     );
                //   }).toList(),
                // ),
                // SizedBox(height: getProportionateScreenHeight(10)),
                // DropdownButton<PainLocation>(
                //   value: pain_location,
                //   isDense: true,
                //   onChanged: (PainLocation newValue) {
                //     setState(() {
                //       pain_location = newValue;
                //     });
                //   },
                //   items: PainLocation.values.map((PainLocation value) {
                //     return DropdownMenuItem<PainLocation>(
                //       value: value,
                //       child: Text(value.toString().split('.')[1]),
                //     );
                //   }).toList(),
                // ),
                // SizedBox(height: getProportionateScreenHeight(10)),
                // TextFormField(
                //   keyboardType: TextInputType.text,
                //   onSaved: (newValue) => duration = newValue.toUpperCase(),
                //   validator: (value) => value.isEmpty ? "nill" : null,
                //   decoration: const InputDecoration(
                //     labelText: "Duration",
                //     hintText: "Enter duration",
                //     floatingLabelBehavior: FloatingLabelBehavior.always,
                //   ),
                // ),
                // SizedBox(height: getProportionateScreenHeight(10)),
                // DropdownButton<Radiation>(
                //   value: radiation,
                //   isDense: true,
                //   onChanged: (Radiation newValue) {
                //     setState(() {
                //       radiation = newValue;
                //     });
                //   },
                //   items: Radiation.values.map((Radiation value) {
                //     return DropdownMenuItem<Radiation>(
                //       value: value,
                //       child: Text(value.toString().split('.')[1]),
                //     );
                //   }).toList(),
                // ),
                // SizedBox(height: getProportionateScreenHeight(10)),
                // DropdownButton<YN>(
                //   value: smoker,
                //   isDense: true,
                //   onChanged: (YN newValue) {
                //     setState(() {
                //       smoker = newValue;
                //     });
                //   },
                //   items: YN.values.map((YN value) {
                //     return DropdownMenuItem<YN>(
                //       value: value,
                //       child: Text(value.toString().split('.')[1]),
                //     );
                //   }).toList(),
                // ),
                // SizedBox(height: getProportionateScreenHeight(10)),
                // DropdownButton<YN>(
                //   value: diabetic,
                //   isDense: true,
                //   onChanged: (YN newValue) {
                //     setState(() {
                //       diabetic = newValue;
                //     });
                //   },
                //   items: YN.values.map((YN value) {
                //     return DropdownMenuItem<YN>(
                //       value: value,
                //       child: Text(value.toString().split('.')[1]),
                //     );
                //   }).toList(),
                // ),
                // SizedBox(height: getProportionateScreenHeight(10)),
                // DropdownButton<YN>(
                //   value: hypertensive,
                //   isDense: true,
                //   onChanged: (YN newValue) {
                //     setState(() {
                //       hypertensive = newValue;
                //     });
                //   },
                //   items: YN.values.map((YN value) {
                //     return DropdownMenuItem<YN>(
                //       value: value,
                //       child: Text(value.toString().split('.')[1]),
                //     );
                //   }).toList(),
                // ),
                // SizedBox(height: getProportionateScreenHeight(10)),
                // DropdownButton<YN>(
                //   value: dyslipidaemia,
                //   isDense: true,
                //   onChanged: (YN newValue) {
                //     setState(() {
                //       dyslipidaemia = newValue;
                //     });
                //   },
                //   items: YN.values.map((YN value) {
                //     return DropdownMenuItem<YN>(
                //       value: value,
                //       child: Text(value.toString().split('.')[1]),
                //     );
                //   }).toList(),
                // ),
                // SizedBox(height: getProportionateScreenHeight(10)),
                // DropdownButton<YN>(
                //   value: old_mi,
                //   isDense: true,
                //   onChanged: (YN newValue) {
                //     setState(() {
                //       old_mi = newValue;
                //     });
                //   },
                //   items: YN.values.map((YN value) {
                //     return DropdownMenuItem<YN>(
                //       value: value,
                //       child: Text(value.toString().split('.')[1]),
                //     );
                //   }).toList(),
                // ),
                // SizedBox(height: getProportionateScreenHeight(10)),
                // DropdownButton<YN>(
                //   value: chest_pain,
                //   isDense: true,
                //   onChanged: (YN newValue) {
                //     setState(() {
                //       chest_pain = newValue;
                //     });
                //   },
                //   items: YN.values.map((YN value) {
                //     return DropdownMenuItem<YN>(
                //       value: value,
                //       child: Text(value.toString().split('.')[1]),
                //     );
                //   }).toList(),
                // ),
                // SizedBox(height: getProportionateScreenHeight(10)),
                // DropdownButton<YN>(
                //   value: sweating,
                //   isDense: true,
                //   onChanged: (YN newValue) {
                //     setState(() {
                //       sweating = newValue;
                //     });
                //   },
                //   items: YN.values.map((YN value) {
                //     return DropdownMenuItem<YN>(
                //       value: value,
                //       child: Text(value.toString().split('.')[1]),
                //     );
                //   }).toList(),
                // ),
                // SizedBox(height: getProportionateScreenHeight(10)),
                // DropdownButton<YN>(
                //   value: nausea,
                //   isDense: true,
                //   onChanged: (YN newValue) {
                //     setState(() {
                //       nausea = newValue;
                //     });
                //   },
                //   items: YN.values.map((YN value) {
                //     return DropdownMenuItem<YN>(
                //       value: value,
                //       child: Text(value.toString().split('.')[1]),
                //     );
                //   }).toList(),
                // ),
                // SizedBox(height: getProportionateScreenHeight(10)),
                // DropdownButton<YN>(
                //   value: shortness_of_breath,
                //   isDense: true,
                //   onChanged: (YN newValue) {
                //     setState(() {
                //       shortness_of_breath = newValue;
                //     });
                //   },
                //   items: YN.values.map((YN value) {
                //     return DropdownMenuItem<YN>(
                //       value: value,
                //       child: Text(value.toString().split('.')[1]),
                //     );
                //   }).toList(),
                // ),
                // SizedBox(height: getProportionateScreenHeight(10)),
                // DropdownButton<YN>(
                //   value: loss_of_conciousness,
                //   isDense: true,
                //   onChanged: (YN newValue) {
                //     setState(() {
                //       loss_of_conciousness = newValue;
                //     });
                //   },
                //   items: YN.values.map((YN value) {
                //     return DropdownMenuItem<YN>(
                //       value: value,
                //       child: Text(value.toString().split('.')[1]),
                //     );
                //   }).toList(),
                // ),
                // SizedBox(height: getProportionateScreenHeight(10)),
                // DropdownButton<YN>(
                //   value: palpitations,
                //   isDense: true,
                //   onChanged: (YN newValue) {
                //     setState(() {
                //       palpitations = newValue;
                //     });
                //   },
                //   items: YN.values.map((YN value) {
                //     return DropdownMenuItem<YN>(
                //       value: value,
                //       child: Text(value.toString().split('.')[1]),
                //     );
                //   }).toList(),
                // ),
                // SizedBox(height: getProportionateScreenHeight(10)),
                // DropdownButton<YN>(
                //   value: concious,
                //   isDense: true,
                //   onChanged: (YN newValue) {
                //     setState(() {
                //       concious = newValue;
                //     });
                //   },
                //   items: YN.values.map((YN value) {
                //     return DropdownMenuItem<YN>(
                //       value: value,
                //       child: Text(value.toString().split('.')[1]),
                //     );
                //   }).toList(),
                // ),
                // SizedBox(height: getProportionateScreenHeight(10)),
                // DropdownButton<YN>(
                //   value: smoker,
                //   isDense: true,
                //   onChanged: (YN newValue) {
                //     setState(() {
                //       smoker = newValue;
                //     });
                //   },
                //   items: YN.values.map((YN value) {
                //     return DropdownMenuItem<YN>(
                //       value: value,
                //       child: Text(value.toString().split('.')[1]),
                //     );
                //   }).toList(),
                // ),
                // SizedBox(height: getProportionateScreenHeight(10)),
                // DropdownButton<YN>(
                //   value: chest_crepts,
                //   isDense: true,
                //   onChanged: (YN newValue) {
                //     setState(() {
                //       chest_crepts = newValue;
                //     });
                //   },
                //   items: YN.values.map((YN value) {
                //     return DropdownMenuItem<YN>(
                //       value: value,
                //       child: Text(value.toString().split('.')[1]),
                //     );
                //   }).toList(),
                // ),
                // const Spacer(flex: 1),
                //  const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      );

  _buildSaveButton(BuildContext context) => Center(
        child: DefaultButton(
          text: "Save",
          press: () async {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              // Report report = Report(
              //     ecgTime: ecgTime,
              //     ecg_type: ecg_type,
              //     trop_i: trop_i,
              //     bp: bp,
              //     cvs: cvs,
              //     onset: onset,
              //     severity: severity,
              //     pain_location: pain_location,
              //     duration: duration,
              //     radiation: radiation,
              //     smoker: smoker,
              //     diabetic: diabetic,
              //     hypertensive: hypertensive,
              //     dyslipidaemia: dyslipidaemia,
              //     old_mi: old_mi,
              //     chest_pain: chest_pain,
              //     sweating: sweating,
              //     nausea: nausea,
              //     shortness_of_breath: shortness_of_breath,
              //     loss_of_conciousness: loss_of_conciousness,
              //     palpitations: palpitations,
              //     concious: concious,
              //     chest_crepts: chest_crepts,
              //     pulse_rate: pulse_rate);
              widget.mainCubit.savePatientReport(report);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("All Fields are required"),
              ));
            }
          },
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
        style: Theme.of(context)
            .textTheme
            .caption
            .copyWith(color: Colors.white, fontSize: 16),
      ),
    ));
  }

  _showLogo(BuildContext context) => Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            const Image(
                image: AssetImage("assets/logo.png"),
                width: 192,
                height: 180,
                fit: BoxFit.fill),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                  text: "Patient",
                  style: Theme.of(context).textTheme.caption.copyWith(
                      color: Colors.lightGreen[500],
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: " Report",
                      style: TextStyle(color: Theme.of(context).accentColor),
                    )
                  ]),
            ),
            SizedBox(height: 30)
          ],
        ),
      );
}
