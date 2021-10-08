import 'package:ccarev2_frontend/main/domain/report.dart';
import 'package:ccarev2_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class ReportDetails extends StatelessWidget {
  final Report report;
  const ReportDetails(this.report);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SizedBox(
      height: SizeConfig.screenHeight * 0.70,
      width: SizeConfig.screenWidth * 0.85,
      child: SingleChildScrollView(
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
                Text(report.ecgTime == null ? "nill" : report.ecgTime),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            // ECG Type
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ECG Type: '),
                Text(report.ecg_type == null
                    ? "nill"
                    : report.ecg_type.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            // Trop I
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Trop I: '),
                Text(report.trop_i == null ? "nill" : report.trop_i),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            // BP
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('BP: '),
                Text(report.bp == null ? "nill" : report.bp),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            // CVS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('CVS: '),
                Text(report.cvs == null
                    ? "nill"
                    : report.cvs.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            // Onset
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Onset: '),
                Text(report.onset == null
                    ? "nill"
                    : report.onset.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            // Severity
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Severity: '),
              Text(report.severity == null
                  ? "nill"
                  : report.severity.toString().split('.')[1]),
            ]),
            SizedBox(height: getProportionateScreenHeight(20)),
            // Pain Location
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Pain Location: '),
                Text(report.pain_location == null
                    ? "nill"
                    : report.pain_location.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            // Duration
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Duration: '),
                Text(report.duration == null ? "nill" : report.duration),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            // Radiation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Radiation: '),
                Text(report.radiation == null
                    ? "nill"
                    : report.radiation.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            // Smoker
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Smoker: '),
                Text(report.smoker == null
                    ? "nill"
                    : report.smoker.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            // Diabetic
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Diabetic: '),
                Text(report.diabetic == null
                    ? "nill"
                    : report.diabetic.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            // Hypertensive
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Hypertensive: '),
                Text(report.hypertensive == null
                    ? "nill"
                    : report.hypertensive.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            // Dyslipidaemia
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Dyslipidaemia: '),
                Text(report.dyslipidaemia == null
                    ? "nill"
                    : report.dyslipidaemia.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            // Old MI
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Old MI: '),
                Text(report.old_mi == null
                    ? "nill"
                    : report.old_mi.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            // Chest Pain
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Chest Pain: '),
                Text(report.chest_pain == null
                    ? "nill"
                    : report.chest_pain.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            // Sweating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Sweating: '),
                Text(report.sweating == null
                    ? "nill"
                    : report.sweating.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            // Nausea
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Nausea: '),
                Text(report.nausea == null
                    ? "nill"
                    : report.nausea.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            // Shortness of breath
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Shortness of breath: '),
                Text(report.shortness_of_breath == null
                    ? "nill"
                    : report.shortness_of_breath.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            // Loss of conciousness
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Loss of Conciousness: '),
                Text(report.loss_of_consciousness == null
                    ? "nill"
                    : report.loss_of_consciousness.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            // Palpitations
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Palpitations: '),
                Text(report.palpitations == null
                    ? "nill"
                    : report.palpitations.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            // Concious
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Concious: '),
                Text(report.conscious == null
                    ? "nill"
                    : report.conscious.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            // Chest crepts
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Chest Crepts: '),
                Text(report.chest_crepts == null
                    ? "nill"
                    : report.chest_crepts.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            // Pulse Rate
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Pulse Rate: '),
                Text(report.pulse_rate == null
                    ? "nill"
                    : report.pulse_rate.toString()),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(height: SizeConfig.bottomInsets),
          ],
        ),
      ),
    );
  }
}
