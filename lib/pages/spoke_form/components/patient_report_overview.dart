import 'package:ccarev2_frontend/main/domain/treatment.dart';
import 'package:ccarev2_frontend/pages/home/components/fullImage.dart';
import 'package:ccarev2_frontend/utils/constants.dart';
import 'package:ccarev2_frontend/utils/size_config.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';

import 'package:ccarev2_frontend/utils/constants.dart';

class ReportOverview extends StatefulWidget {
  final TreatmentReport report;
  const ReportOverview(this.report);

  @override
  State<ReportOverview> createState() => _ReportOverviewState();
}

class _ReportOverviewState extends State<ReportOverview> {
  @override
  void initState() {
    print(widget.report.ecg_av);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(DateTime.fromMillisecondsSinceEpoch(
                  int.parse(widget.report.report_time))
              .toString()),
        ),
        body: _buildReportOverview());
  }

  _buildReportOverview() => SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 2.h),

            // Patient Medical Report
            // ECG Report
            Container(
              width: SizeConfig.screenWidth,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Text(
                "ECG Report",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 14.sp, color: kPrimaryColor),
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
                style: TextStyle(fontSize: 14.sp, color: kPrimaryColor),
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
                style: TextStyle(fontSize: 14.sp, color: kPrimaryColor),
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
                style: TextStyle(fontSize: 14.sp, color: kPrimaryColor),
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
                style: TextStyle(fontSize: 14.sp, color: kPrimaryColor),
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
            SizedBox(height: 2.h),
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
            SizedBox(height: 1.h),
            // ECG Scan
            // #FIXME - Add Multiple ECG Scan
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ECG Scan: '),
                // widget.report.ecg_av != null ||
                //         widget.report.ecg_av != true ||
                widget.report.ecg.ecg_file_id.length != 0
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return FullScreenImage(
                              imageUrl:
                                  "$BASEURL/treatment/fetchECG?fileID=${widget.report.ecg.ecg_file_id[0].file_id}",
                              tag: "generate_a_unique_tag",
                            );
                          }));
                        },
                        child: Hero(
                          child: Image(
                              image: NetworkImage(
                                  "$BASEURL/treatment/fetchECG?fileID=${widget.report.ecg.ecg_file_id[0].file_id}",
                                  headers: {
                                    "Authorization":
                                        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiNjFhMWU5ZGNiYWI4MjZkZTk4NjBmNzkzIiwiaWF0IjoxNjM4MjY1MzkxLCJleHAiOjE2Mzg4NzAxOTEsImlzcyI6ImNvbS5jY2FyZW5pdGgifQ.K-_DprXx2ipOwWt17DODlMDqQSgtWdv8aARjlPdEuzA"
                                  }),
                              width: 30.w,
                              height: 15.h,
                              fit: BoxFit.cover),
                          tag: "generate_a_unique_tag",
                        ),
                      )
                    : Text('No ECG Uploaded'),
              ],
            ),
            SizedBox(height: 1.h),
            // ECG Type
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ECG Type: '),
                Text(widget.report.ecg.ecg_type.toString().split('.')[1]),
              ],
            ),

            SizedBox(height: 3.h),
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
            SizedBox(height: 2.h),
            // Smoker
            Text('Current Report'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Smoker: '),
                Text(widget.report.medicalHist.smoker.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: 1.h),
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
            SizedBox(height: 1.h),
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
            SizedBox(height: 1.h),
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
            SizedBox(height: 1.h),
            // Old MI
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Old MI: '),
                Text(widget.report.medicalHist.old_mi.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: 1.h),
            // Trop I
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Trop I: '),
                Text(widget.report.medicalHist.trop_i.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: 3.h),
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
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Chest Pain: '),
                Text(widget.report.chestReport.chest_pain
                    .toString()
                    .split('.')[1]),
              ],
            ),
            SizedBox(height: 1.h),
            // Onset
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Site: '),
                Text(widget.report.chestReport.site.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: 1.h),
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
            // SizedBox(height: 1.h),
            // // Intensity
            // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            //   Text('Intensity: '),
            //   Text(
            //       widget.report.chestReport.intensity.toString().split('.')[1]),
            // ]),
            SizedBox(height: 1.h),
            // Severity
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Severity: '),
              Text(widget.report.chestReport.severity.toString().split('.')[1]),
            ]),
            SizedBox(height: 1.h),
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
            SizedBox(height: 1.h),
            // Duration
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Duration: '),
                Text(widget.report.chestReport.duration),
              ],
            ),
            SizedBox(height: 3.h),
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
            SizedBox(height: 2.h),

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
            // SizedBox(height: 1.h),
            // Palpitations
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text('Light Headedness: '),
            //     Text(widget.report.symptoms.light_headedness
            //         .toString()
            //         .split('.')[1]),
            //   ],
            // ),
            SizedBox(height: 1.h),
            //Sweating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Sweating: '),
                Text(widget.report.symptoms.sweating.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: 1.h),
            // Nausea
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Nausea/Vomiting: '),
                Text(widget.report.symptoms.nausea.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: 1.h),
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
            // SizedBox(height: 1.h),
            // // Loss of conciousness
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text('Loss of Consciousness: '),
            //     Text(widget.report.symptoms.loss_of_consciousness
            //         .toString()
            //         .split('.')[1]),
            //   ],
            // ),

            SizedBox(height: 3.h),
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
            SizedBox(height: 2.h),
            // Pulse Rate

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Pulse Rate: '),
                Text(widget.report.examination.pulse_rate),
              ],
            ),
            SizedBox(height: 1.h),
            // BP
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('DBP: '),
                Text(widget.report.examination.dbp),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('SBP: '),
                Text(widget.report.examination.sbp),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('SpO2: '),
                Text(widget.report.examination.spo2),
              ],
            ),
            SizedBox(height: 1.h),
            // Local Tenderness
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Local Tederness: '),
                Text(widget.report.examination.local_tenderness
                    .toString()
                    .split('.')[1]),
              ],
            ),

            SizedBox(height: getProportionateScreenHeight(100)),
          ],
        ),
      );
}
