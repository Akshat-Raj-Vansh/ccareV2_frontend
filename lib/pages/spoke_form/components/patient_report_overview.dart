import 'package:ccarev2_frontend/main/domain/treatment.dart';
import 'package:ccarev2_frontend/pages/home/components/fullImage.dart';
import 'package:ccarev2_frontend/utils/constants.dart';
import 'package:ccarev2_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class ReportOverview extends StatefulWidget {
  final TreatmentReport report;
  const ReportOverview(this.report);

  @override
  State<ReportOverview> createState() => _ReportOverviewState();
}

class _ReportOverviewState extends State<ReportOverview> {
  @override
  Widget build(BuildContext context) {
    return _buildReportOverview();
  }

  _buildReportOverview() => SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),

            // Patient Medical Report
            // ECG Report
            Container(
              width: SizeConfig.screenWidth,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Text(
                "ECG Report",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18, color: kPrimaryColor),
              ),
            ),
            _buildECGDetails(),

            // Medical History
            Container(
              width: SizeConfig.screenWidth,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Text(
                "Medical History",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18, color: kPrimaryColor),
              ),
            ),
            _buildMedHistDetails(),

            // Chest Report
            Container(
              width: SizeConfig.screenWidth,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Text(
                "Chest Report",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18, color: kPrimaryColor),
              ),
            ),
            _buildChestDetails(),

            // Symptoms Report
            Container(
              width: SizeConfig.screenWidth,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Text(
                "Symptoms",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18, color: kPrimaryColor),
              ),
            ),
            _buildSymptomsDetails(),

            // Examination Report
            Container(
              width: SizeConfig.screenWidth,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Text(
                "Examination",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18, color: kPrimaryColor),
              ),
            ),
            _buildExaminationDetails(),
          ],
        ),
      );

  _buildECGDetails() => Container(
        width: SizeConfig.screenWidth,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: getProportionateScreenHeight(15)),
            // ECG Time
            Text('Current Report'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ECG Time: '),
                Text(widget.report.ecg.ecg_time == "nill"
                    ? "nill"
                    : DateTime.fromMillisecondsSinceEpoch(
                            int.parse(widget.report.ecg.ecg_time))
                        .toString()),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // ECG Scan
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ECG Scan: '),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return FullScreenImage(
                        imageUrl:
                            "http://192.168.0.139:3000/treatment/fetchECG?fileID=${widget.report.ecg.ecg_file_id}",
                        tag: "generate_a_unique_tag",
                      );
                    }));
                  },
                  child: Hero(
                    child: Image(
                        image: NetworkImage(
                            "http://192.168.0.139:3000/treatment/fetchECG?fileID=${widget.report.ecg.ecg_file_id}",
                            headers: {
                              "Authorization":
                                  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiNjFhMWU5ZGNiYWI4MjZkZTk4NjBmNzkzIiwiaWF0IjoxNjM4MjY1MzkxLCJleHAiOjE2Mzg4NzAxOTEsImlzcyI6ImNvbS5jY2FyZW5pdGgifQ.K-_DprXx2ipOwWt17DODlMDqQSgtWdv8aARjlPdEuzA"
                            }),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover),
                    tag: "generate_a_unique_tag",
                  ),
                )
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // ECG Type
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ECG Type: '),
                Text(widget.report.ecg.ecg_type.toString().split('.')[1]),
              ],
            ),

            SizedBox(height: getProportionateScreenHeight(30)),
          ],
        ),
      );

  _buildMedHistDetails() => Container(
        width: SizeConfig.screenWidth,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: getProportionateScreenHeight(15)),
            // Smoker
            Text('Current Report'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Smoker: '),
                Text(widget.report.medicalHist.smoker.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Diabetic
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Diabetic: '),
                Text(widget.report.medicalHist.diabetic
                    .toString()
                    .split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Hypertensive
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Hypertensive: '),
                Text(widget.report.medicalHist.hypertensive
                    .toString()
                    .split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Dyslipidaemia
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Dyslipidaemia: '),
                Text(widget.report.medicalHist.dyslipidaemia
                    .toString()
                    .split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Old MI
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Old MI: '),
                Text(widget.report.medicalHist.old_mi.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Trop I
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Trop I: '),
                Text(widget.report.medicalHist.trop_i),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(30)),
          ],
        ),
      );

  _buildChestDetails() => Container(
        width: SizeConfig.screenWidth,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: getProportionateScreenHeight(15)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Chest Pain: '),
                Text(widget.report.chestReport.chest_pain
                    .toString()
                    .split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Onset
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Site: '),
                Text(widget.report.chestReport.site.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Pain Location
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Location: '),
                Text(widget.report.chestReport.location
                    .toString()
                    .split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Intensity
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Intensity: '),
              Text(
                  widget.report.chestReport.intensity.toString().split('.')[1]),
            ]),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Severity
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Severity: '),
              Text(widget.report.chestReport.severity.toString().split('.')[1]),
            ]),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Radiation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Radiation: '),
                Text(widget.report.chestReport.radiation
                    .toString()
                    .split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Duration
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Duration: '),
                Text(widget.report.chestReport.duration),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(30)),
          ],
        ),
      );

  _buildSymptomsDetails() => Container(
        width: SizeConfig.screenWidth,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: getProportionateScreenHeight(15)),

            // Blackouts
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Postural Black Out: '),
                Text(widget.report.symptoms.postural_black_out
                    .toString()
                    .split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Palpitations
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Light Headedness: '),
                Text(widget.report.symptoms.light_headedness
                    .toString()
                    .split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            //Sweating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Sweating: '),
                Text(widget.report.symptoms.sweating.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Nausea
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Nausea/Vomiting: '),
                Text(widget.report.symptoms.nausea.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Shortness of breath
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Shortness of breath: '),
                Text(widget.report.symptoms.shortness_of_breath
                    .toString()
                    .split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Loss of conciousness
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Loss of Consciousness: '),
                Text(widget.report.symptoms.loss_of_consciousness
                    .toString()
                    .split('.')[1]),
              ],
            ),

            SizedBox(height: getProportionateScreenHeight(30)),
          ],
        ),
      );

  _buildExaminationDetails() => Container(
        width: SizeConfig.screenWidth,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: getProportionateScreenHeight(15)),
            // Pulse Rate

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Pulse Rate: '),
                Text(widget.report.examination.pulse_rate),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // BP
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('BP: '),
                Text(widget.report.examination.bp),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            // Local Tenderness
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Local Tederness: '),
                Text(widget.report.examination.local_tenderness),
              ],
            ),

            SizedBox(height: getProportionateScreenHeight(100)),
          ],
        ),
      );
}
