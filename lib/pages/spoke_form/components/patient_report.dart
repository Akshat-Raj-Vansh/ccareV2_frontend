//@dart=2.9
import 'package:ccarev2_frontend/components/default_button.dart';
import 'package:ccarev2_frontend/main/domain/report.dart';
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class PatientReport extends StatefulWidget {
  final MainCubit cubit;

  const PatientReport(this.cubit);
  @override
  _PatientReportState createState() => _PatientReportState();
}

class _PatientReportState extends State<PatientReport> {
  final _formKey = GlobalKey<FormState>();
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
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: getProportionateScreenHeight(20)),
          TextFormField(
            keyboardType: TextInputType.text,
            onSaved: (newValue) => ecgTime = newValue,
            validator: (value) => value.isEmpty ? "nill" : null,
            decoration: const InputDecoration(
              labelText: "ECG Time",
              hintText: "Enter ECG Time",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          DropdownButton<ECGType>(
            value: ecg_type,
            isDense: true,
            onChanged: (ECGType newValue) {
              setState(() {
                ecg_type = newValue;
              });
            },
            items: ECGType.values.map((ECGType value) {
              return DropdownMenuItem<ECGType>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          TextFormField(
            keyboardType: TextInputType.text,
            onSaved: (newValue) => trop_i = newValue.toUpperCase(),
            validator: (value) => value.isEmpty ? "nill" : null,
            decoration: const InputDecoration(
              labelText: "Trop I",
              hintText: "Enter Trop I",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          TextFormField(
            keyboardType: TextInputType.text,
            onSaved: (newValue) => bp = newValue.toUpperCase(),
            validator: (value) => value.isEmpty ? "nill" : null,
            decoration: const InputDecoration(
              labelText: "BP",
              hintText: "Enter BP",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          DropdownButton<CVS>(
            value: cvs,
            isDense: true,
            onChanged: (CVS newValue) {
              setState(() {
                cvs = newValue;
              });
            },
            items: CVS.values.map((CVS value) {
              return DropdownMenuItem<CVS>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          DropdownButton<Onset>(
            value: onset,
            isDense: true,
            onChanged: (Onset newValue) {
              setState(() {
                onset = newValue;
              });
            },
            items: Onset.values.map((Onset value) {
              return DropdownMenuItem<Onset>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          DropdownButton<Severity>(
            value: severity,
            isDense: true,
            onChanged: (Severity newValue) {
              setState(() {
                severity = newValue;
              });
            },
            items: Severity.values.map((Severity value) {
              return DropdownMenuItem<Severity>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          DropdownButton<PainLocation>(
            value: pain_location,
            isDense: true,
            onChanged: (PainLocation newValue) {
              setState(() {
                pain_location = newValue;
              });
            },
            items: PainLocation.values.map((PainLocation value) {
              return DropdownMenuItem<PainLocation>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          TextFormField(
            keyboardType: TextInputType.text,
            onSaved: (newValue) => duration = newValue.toUpperCase(),
            validator: (value) => value.isEmpty ? "nill" : null,
            decoration: const InputDecoration(
              labelText: "Duration",
              hintText: "Enter duration",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          DropdownButton<Radiation>(
            value: radiation,
            isDense: true,
            onChanged: (Radiation newValue) {
              setState(() {
                radiation = newValue;
              });
            },
            items: Radiation.values.map((Radiation value) {
              return DropdownMenuItem<Radiation>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          DropdownButton<YN>(
            value: smoker,
            isDense: true,
            onChanged: (YN newValue) {
              setState(() {
                smoker = newValue;
              });
            },
            items: YN.values.map((YN value) {
              return DropdownMenuItem<YN>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          DropdownButton<YN>(
            value: diabetic,
            isDense: true,
            onChanged: (YN newValue) {
              setState(() {
                diabetic = newValue;
              });
            },
            items: YN.values.map((YN value) {
              return DropdownMenuItem<YN>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          DropdownButton<YN>(
            value: hypertensive,
            isDense: true,
            onChanged: (YN newValue) {
              setState(() {
                hypertensive = newValue;
              });
            },
            items: YN.values.map((YN value) {
              return DropdownMenuItem<YN>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          DropdownButton<YN>(
            value: dyslipidaemia,
            isDense: true,
            onChanged: (YN newValue) {
              setState(() {
                dyslipidaemia = newValue;
              });
            },
            items: YN.values.map((YN value) {
              return DropdownMenuItem<YN>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          DropdownButton<YN>(
            value: old_mi,
            isDense: true,
            onChanged: (YN newValue) {
              setState(() {
                old_mi = newValue;
              });
            },
            items: YN.values.map((YN value) {
              return DropdownMenuItem<YN>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          DropdownButton<YN>(
            value: chest_pain,
            isDense: true,
            onChanged: (YN newValue) {
              setState(() {
                chest_pain = newValue;
              });
            },
            items: YN.values.map((YN value) {
              return DropdownMenuItem<YN>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          DropdownButton<YN>(
            value: sweating,
            isDense: true,
            onChanged: (YN newValue) {
              setState(() {
                sweating = newValue;
              });
            },
            items: YN.values.map((YN value) {
              return DropdownMenuItem<YN>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          DropdownButton<YN>(
            value: nausea,
            isDense: true,
            onChanged: (YN newValue) {
              setState(() {
                nausea = newValue;
              });
            },
            items: YN.values.map((YN value) {
              return DropdownMenuItem<YN>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          DropdownButton<YN>(
            value: shortness_of_breath,
            isDense: true,
            onChanged: (YN newValue) {
              setState(() {
                shortness_of_breath = newValue;
              });
            },
            items: YN.values.map((YN value) {
              return DropdownMenuItem<YN>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          DropdownButton<YN>(
            value: loss_of_conciousness,
            isDense: true,
            onChanged: (YN newValue) {
              setState(() {
                loss_of_conciousness = newValue;
              });
            },
            items: YN.values.map((YN value) {
              return DropdownMenuItem<YN>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          DropdownButton<YN>(
            value: palpitations,
            isDense: true,
            onChanged: (YN newValue) {
              setState(() {
                palpitations = newValue;
              });
            },
            items: YN.values.map((YN value) {
              return DropdownMenuItem<YN>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          DropdownButton<YN>(
            value: concious,
            isDense: true,
            onChanged: (YN newValue) {
              setState(() {
                concious = newValue;
              });
            },
            items: YN.values.map((YN value) {
              return DropdownMenuItem<YN>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          DropdownButton<YN>(
            value: smoker,
            isDense: true,
            onChanged: (YN newValue) {
              setState(() {
                smoker = newValue;
              });
            },
            items: YN.values.map((YN value) {
              return DropdownMenuItem<YN>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          DropdownButton<YN>(
            value: chest_crepts,
            isDense: true,
            onChanged: (YN newValue) {
              setState(() {
                chest_crepts = newValue;
              });
            },
            items: YN.values.map((YN value) {
              return DropdownMenuItem<YN>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
          ),
          const Spacer(flex: 1),
          Center(
            child: DefaultButton(
              text: "Save",
              press: () async {
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
                      loss_of_conciousness: loss_of_conciousness,
                      palpitations: palpitations,
                      concious: concious,
                      chest_crepts: chest_crepts,
                      pulse_rate: pulse_rate);
                  widget.cubit.savePatientReport(report);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("All Fields are required"),
                  ));
                }
              },
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
