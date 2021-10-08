//@dart=2.9
import 'package:ccarev2_frontend/components/default_button.dart';
import 'package:ccarev2_frontend/main/domain/report.dart';
import 'package:ccarev2_frontend/pages/spoke_form/components/report_details.dart';
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
  bool editReport = false;
  bool noReport = true;
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
  YN loss_of_consciousness = YN.nill;
  YN palpitations = YN.nill;
  YN conscious = YN.nill;
  YN chest_crepts = YN.nill;
  int pulse_rate;

  @override
  void initState() {
    super.initState();
    _fetchReport();
  }

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
    loss_of_consciousness = report.loss_of_consciousness;
    palpitations = report.palpitations;
    conscious = report.conscious;
    chest_crepts = report.chest_crepts;
    pulse_rate = report.pulse_rate;
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
        if (state is PatientReportFetched) {
          print("Patient Report Fetched state Called");
          report = state.report;
          noReport = false;
          _updateForm(report);
          _hideLoader();
        }
        if (state is EditPatientReport) {
          _hideLoader();
          editReport = true;
        }
        if (state is ViewPatientReport) {
          _hideLoader();
          editReport = false;
          widget.mainCubit.fetchPatientReport();
        }
        if (state is PatientReportSaved) {
          print("Patient Report Saved state Called");
          print(state.msg);
        }
        if (state is NoReportState) {
          print('No Report State Called');
          _hideLoader();
          noReport = true;
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
              print('Refresh button pressed');
              _fetchReport();
            },
            icon: Icon(Icons.refresh),
          ),
          editReport || noReport
              ? TextButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      Report report = Report(
                          ecgTime: ecgTime,
                          ecg_type: ecg_type,
                          trop_i: trop_i,
                          bp: bp,
                          cvs: cvs,
                          onset: onset,
                          severity: severity,
                          pain_location: pain_location,
                          duration: duration,
                          radiation: radiation,
                          smoker: smoker,
                          diabetic: diabetic,
                          hypertensive: hypertensive,
                          dyslipidaemia: dyslipidaemia,
                          old_mi: old_mi,
                          chest_pain: chest_pain,
                          sweating: sweating,
                          nausea: nausea,
                          shortness_of_breath: shortness_of_breath,
                          loss_of_consciousness: loss_of_consciousness,
                          palpitations: palpitations,
                          conscious: conscious,
                          chest_crepts: chest_crepts,
                          pulse_rate: pulse_rate);
                      print(report.toJson());
                      widget.mainCubit.savePatientReport(report);
                      widget.mainCubit.viewPatientReport();
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
              if (!noReport) _buildReportDetails(),
              editReport || noReport ? _buildForm() : _buildReport(),
              SizedBox(height: SizeConfig.screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  _buildReportDetails() => Column(children: [
        Container(
          width: SizeConfig.screenWidth,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Text(
            "Report's Details",
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

  _buildReport() => ReportDetails(report);

  _buildForm() => Expanded(
        // height: SizeConfig.screenHeight * 0.70,
        // width: SizeConfig.screenWidth * 0.85,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
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
                      Text('ECG Time: '),
                      Container(
                        width: SizeConfig.screenWidth * 0.4,
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          focusNode: null,
                          initialValue: ecgTime != null && ecgTime != "nill"
                              ? ecgTime
                              : null,
                          onSaved: (newValue) => ecgTime = newValue,
                          // validator: (value) => value.isEmpty ? "nill" : null,
                          decoration: const InputDecoration(
                            hintText: "Enter ECG Time",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  // ECG Type
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('ECG Type: '),
                      Container(
                        width: SizeConfig.screenWidth * 0.4,
                        child: DropdownButton<ECGType>(
                          value: ecg_type == null ? ECGType.nill : ecg_type,
                          isDense: false,
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
                  SizedBox(height: getProportionateScreenHeight(20)),
                  // Trop I
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Trop I: '),
                      Container(
                        width: SizeConfig.screenWidth * 0.4,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          focusNode: null,
                          initialValue: trop_i != null && trop_i != "nill"
                              ? trop_i
                              : null,
                          onSaved: (newValue) => trop_i = newValue,
                          // validator: (value) => value.isEmpty ? "nill" : null,
                          decoration: const InputDecoration(
                            hintText: "Enter Trop I",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  // BP
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('BP: '),
                      Container(
                        width: SizeConfig.screenWidth * 0.4,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          focusNode: null,
                          onSaved: (newValue) => bp = newValue,
                          initialValue: bp != null && bp != "nill" ? bp : null,
                          // validator: (value) => value.isEmpty ? "nill" : null,
                          decoration: const InputDecoration(
                            hintText: "Enter BP",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  // CVS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('CVS: '),
                      Container(
                        width: SizeConfig.screenWidth * 0.4,
                        child: DropdownButton<CVS>(
                          value: cvs,
                          isDense: false,
                          onChanged: (CVS newValue) {
                            setState(() {
                              cvs = newValue;
                            });
                          },
                          items: CVS.values.map((CVS value) {
                            return DropdownMenuItem<CVS>(
                              value: value,
                              child: Text(value.toString().split('.')[1]),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  // Onset
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Onset: '),
                      Container(
                        width: SizeConfig.screenWidth * 0.4,
                        child: DropdownButton<Onset>(
                          value: onset,
                          isDense: false,
                          onChanged: (Onset newValue) {
                            setState(() {
                              onset = newValue;
                            });
                          },
                          items: Onset.values.map((Onset value) {
                            return DropdownMenuItem<Onset>(
                              value: value,
                              child: Text(value.toString().split('.')[1]),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  // Severity
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Severity: '),
                        Container(
                          width: SizeConfig.screenWidth * 0.4,
                          child: DropdownButton<Severity>(
                            value: severity,
                            isDense: false,
                            onChanged: (Severity newValue) {
                              setState(() {
                                severity = newValue;
                              });
                            },
                            items: Severity.values.map((Severity value) {
                              return DropdownMenuItem<Severity>(
                                value: value,
                                child: Text(value.toString().split('.')[1]),
                              );
                            }).toList(),
                          ),
                        ),
                      ]),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  // Pain Location
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Pain Location: '),
                      Container(
                        width: SizeConfig.screenWidth * 0.4,
                        child: DropdownButton<PainLocation>(
                          value: pain_location,
                          isDense: false,
                          onChanged: (PainLocation newValue) {
                            setState(() {
                              pain_location = newValue;
                            });
                          },
                          items: PainLocation.values.map((PainLocation value) {
                            return DropdownMenuItem<PainLocation>(
                              value: value,
                              child: Text(value.toString().split('.')[1]),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  // Duration
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Duration: '),
                      Container(
                        width: SizeConfig.screenWidth * 0.4,
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          focusNode: null,
                          initialValue: duration != null && duration != "nill"
                              ? duration
                              : null,
                          onSaved: (newValue) => duration = newValue,
                          // validator: (value) => value.isEmpty ? "nill" : null,
                          decoration: const InputDecoration(
                            hintText: "Enter duration",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  // Radiation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Radiation: '),
                      Container(
                        width: SizeConfig.screenWidth * 0.4,
                        child: DropdownButton<Radiation>(
                          value: radiation,
                          isDense: false,
                          onChanged: (Radiation newValue) {
                            setState(() {
                              radiation = newValue;
                            });
                          },
                          items: Radiation.values.map((Radiation value) {
                            return DropdownMenuItem<Radiation>(
                              value: value,
                              child: Text(value.toString().split('.')[1]),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  // Smoker
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Smoker: '),
                      Container(
                        width: SizeConfig.screenWidth * 0.4,
                        child: DropdownButton<YN>(
                          value: smoker,
                          isDense: false,
                          onChanged: (YN newValue) {
                            setState(() {
                              smoker = newValue;
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
                  // Diabetic
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Diabetic: '),
                      Container(
                        width: SizeConfig.screenWidth * 0.4,
                        child: DropdownButton<YN>(
                          value: diabetic,
                          isDense: false,
                          onChanged: (YN newValue) {
                            setState(() {
                              diabetic = newValue;
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
                  // Hypertensive
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Hypertensive: '),
                      Container(
                        width: SizeConfig.screenWidth * 0.4,
                        child: DropdownButton<YN>(
                          value: hypertensive,
                          isDense: false,
                          onChanged: (YN newValue) {
                            setState(() {
                              hypertensive = newValue;
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
                  // Dyslipidaemia
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Dyslipidaemia: '),
                      Container(
                        width: SizeConfig.screenWidth * 0.4,
                        child: DropdownButton<YN>(
                          value: dyslipidaemia,
                          isDense: false,
                          onChanged: (YN newValue) {
                            setState(() {
                              dyslipidaemia = newValue;
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
                  // Old MI
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Old MI: '),
                      Container(
                        width: SizeConfig.screenWidth * 0.4,
                        child: DropdownButton<YN>(
                          value: old_mi,
                          isDense: false,
                          onChanged: (YN newValue) {
                            setState(() {
                              old_mi = newValue;
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
                  // Chest Pain
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Chest Pain: '),
                      Container(
                        width: SizeConfig.screenWidth * 0.4,
                        child: DropdownButton<YN>(
                          value: chest_pain,
                          isDense: false,
                          onChanged: (YN newValue) {
                            setState(() {
                              chest_pain = newValue;
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
                  // Sweating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Sweating: '),
                      Container(
                        width: SizeConfig.screenWidth * 0.4,
                        child: DropdownButton<YN>(
                          value: sweating,
                          isDense: false,
                          onChanged: (YN newValue) {
                            setState(() {
                              sweating = newValue;
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
                  // Nausea
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Nausea: '),
                      Container(
                        width: SizeConfig.screenWidth * 0.4,
                        child: DropdownButton<YN>(
                          value: nausea,
                          isDense: false,
                          onChanged: (YN newValue) {
                            setState(() {
                              nausea = newValue;
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
                  // Shortness of breath
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Shortness of breath: '),
                      Container(
                        width: SizeConfig.screenWidth * 0.4,
                        child: DropdownButton<YN>(
                          value: shortness_of_breath,
                          isDense: false,
                          onChanged: (YN newValue) {
                            setState(() {
                              shortness_of_breath = newValue;
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
                  // Loss of conciousness
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Loss of Conciousness: '),
                      Container(
                        width: SizeConfig.screenWidth * 0.4,
                        child: DropdownButton<YN>(
                          value: loss_of_consciousness,
                          isDense: false,
                          onChanged: (YN newValue) {
                            setState(() {
                              loss_of_consciousness = newValue;
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
                  // Palpitations
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Palpitations: '),
                      Container(
                        width: SizeConfig.screenWidth * 0.4,
                        child: DropdownButton<YN>(
                          value: palpitations,
                          isDense: false,
                          onChanged: (YN newValue) {
                            setState(() {
                              palpitations = newValue;
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
                  // Concious
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Concious: '),
                      Container(
                        width: SizeConfig.screenWidth * 0.4,
                        child: DropdownButton<YN>(
                          value: conscious,
                          isDense: false,
                          onChanged: (YN newValue) {
                            setState(() {
                              conscious = newValue;
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
                  // Chest crepts
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Chest Crepts: '),
                      Container(
                        width: SizeConfig.screenWidth * 0.4,
                        child: DropdownButton<YN>(
                          value: chest_crepts,
                          isDense: false,
                          onChanged: (YN newValue) {
                            setState(() {
                              chest_crepts = newValue;
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
                  // Pulse Rate
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Pulse Rate: '),
                      Container(
                        width: SizeConfig.screenWidth * 0.4,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          focusNode: null,
                          initialValue: pulse_rate == null || pulse_rate == -1
                              ? null
                              : pulse_rate.toString(),
                          onSaved: (newValue) => pulse_rate =
                              newValue.isEmpty ? 1 : int.parse(newValue),
                          // validator: (value) => value.isEmpty ? "nill" : null,
                          decoration: const InputDecoration(
                            hintText: "Enter Pulse Rate",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
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
        ),
      );
}
