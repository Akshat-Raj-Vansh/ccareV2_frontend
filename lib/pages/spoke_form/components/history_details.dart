// import 'package:ccarev2_frontend/main/domain/treatment.dart';
// import 'package:ccarev2_frontend/utils/size_config.dart';
// import 'package:flutter/material.dart';

// class ReportHistoryDetails extends StatelessWidget {
//   final TreatmentReport report1;
//   final TreatmentReport report2;
//   const ReportHistoryDetails(this.report1, this.report2);

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig().init(context);
//     return Expanded(
//       // height: SizeConfig.screenHeight * 0.70,
//       // width: SizeConfig.screenWidth * 0.85,
//       child: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(height: getProportionateScreenHeight(20)),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('Timestamps: '),
//                   Text('7th Aug, 2021'),
//                   Text('9th Sept, 2021'),
//                 ],
//               ),
//               SizedBox(height: getProportionateScreenHeight(20)),
//               // ECG Time
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('ECG Time: '),
//                   Text(report1.ecgTime == null ? "nill" : report1.ecgTime),
//                   Text(report2.ecgTime == null ? "nill" : report2.ecgTime),
//                 ],
//               ),
//               SizedBox(height: getProportionateScreenHeight(20)),
//               // ECG Type
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('ECG Type: '),
//                   Text(report1.ecg_type == null
//                       ? "nill"
//                       : report1.ecg_type.toString().split('.')[1]),
//                   Text(report2.ecg_type == null
//                       ? "nill"
//                       : report2.ecg_type.toString().split('.')[1]),
//                 ],
//               ),
//               SizedBox(height: getProportionateScreenHeight(20)),
//               // Trop I
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('Trop I: '),
//                   Text(report1.trop_i == null ? "nill" : report1.trop_i),
//                   Text(report2.trop_i == null ? "nill" : report2.trop_i),
//                 ],
//               ),
//               SizedBox(height: getProportionateScreenHeight(20)),
//               // BP
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('BP: '),
//                   Text(report1.bp == null ? "nill" : report1.bp),
//                   Text(report2.bp == null ? "nill" : report2.bp),
//                 ],
//               ),
//               SizedBox(height: getProportionateScreenHeight(20)),
//               // CVS
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('CVS: '),
//                   Text(report1.cvs == null
//                       ? "nill"
//                       : report1.cvs.toString().split('.')[1]),
//                   Text(report2.cvs == null
//                       ? "nill"
//                       : report2.cvs.toString().split('.')[1]),
//                 ],
//               ),
//               SizedBox(height: getProportionateScreenHeight(20)),
//               // Onset
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('Onset: '),
//                   Text(report1.onset == null
//                       ? "nill"
//                       : report1.onset.toString().split('.')[1]),
//                   Text(report2.onset == null
//                       ? "nill"
//                       : report2.onset.toString().split('.')[1]),
//                 ],
//               ),
//               SizedBox(height: getProportionateScreenHeight(20)),
//               // Severity
//               Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//                 Text('Severity: '),
//                 Text(report1.severity == null
//                     ? "nill"
//                     : report1.severity.toString().split('.')[1]),
//                 Text(report2.severity == null
//                     ? "nill"
//                     : report2.severity.toString().split('.')[1]),
//               ]),
//               SizedBox(height: getProportionateScreenHeight(20)),
//               // Pain Location
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('Pain Location: '),
//                   Text(report1.pain_location == null
//                       ? "nill"
//                       : report1.pain_location.toString().split('.')[1]),
//                   Text(report2.pain_location == null
//                       ? "nill"
//                       : report2.pain_location.toString().split('.')[1]),
//                 ],
//               ),
//               SizedBox(height: getProportionateScreenHeight(20)),
//               // Duration
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('Duration: '),
//                   Text(report1.duration == null ? "nill" : report1.duration),
//                   Text(report2.duration == null ? "nill" : report2.duration),
//                 ],
//               ),
//               SizedBox(height: getProportionateScreenHeight(20)),
//               // Radiation
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('Radiation: '),
//                   Text(report1.radiation == null
//                       ? "nill"
//                       : report1.radiation.toString().split('.')[1]),
//                   Text(report2.radiation == null
//                       ? "nill"
//                       : report2.radiation.toString().split('.')[1]),
//                 ],
//               ),
//               SizedBox(height: getProportionateScreenHeight(20)),
//               // Smoker
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('Smoker: '),
//                   Text(report1.smoker == null
//                       ? "nill"
//                       : report1.smoker.toString().split('.')[1]),
//                   Text(report2.smoker == null
//                       ? "nill"
//                       : report2.smoker.toString().split('.')[1]),
//                 ],
//               ),
//               SizedBox(height: getProportionateScreenHeight(20)),
//               // Diabetic
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('Diabetic: '),
//                   Text(report1.diabetic == null
//                       ? "nill"
//                       : report1.diabetic.toString().split('.')[1]),
//                   Text(report2.diabetic == null
//                       ? "nill"
//                       : report2.diabetic.toString().split('.')[1]),
//                 ],
//               ),
//               SizedBox(height: getProportionateScreenHeight(20)),
//               // Hypertensive
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('Hypertensive: '),
//                   Text(report1.hypertensive == null
//                       ? "nill"
//                       : report1.hypertensive.toString().split('.')[1]),
//                   Text(report2.hypertensive == null
//                       ? "nill"
//                       : report2.hypertensive.toString().split('.')[1]),
//                 ],
//               ),
//               SizedBox(height: getProportionateScreenHeight(20)),
//               // Dyslipidaemia
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('Dyslipidaemia: '),
//                   Text(report1.dyslipidaemia == null
//                       ? "nill"
//                       : report1.dyslipidaemia.toString().split('.')[1]),
//                   Text(report2.dyslipidaemia == null
//                       ? "nill"
//                       : report2.dyslipidaemia.toString().split('.')[1]),
//                 ],
//               ),
//               SizedBox(height: getProportionateScreenHeight(20)),
//               // Old MI
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('Old MI: '),
//                   Text(report1.old_mi == null
//                       ? "nill"
//                       : report1.old_mi.toString().split('.')[1]),
//                   Text(report2.old_mi == null
//                       ? "nill"
//                       : report2.old_mi.toString().split('.')[1]),
//                 ],
//               ),
//               SizedBox(height: getProportionateScreenHeight(20)),
//               // Chest Pain
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('Chest Pain: '),
//                   Text(report1.chest_pain == null
//                       ? "nill"
//                       : report1.chest_pain.toString().split('.')[1]),
//                   Text(report2.chest_pain == null
//                       ? "nill"
//                       : report2.chest_pain.toString().split('.')[1]),
//                 ],
//               ),
//               SizedBox(height: getProportionateScreenHeight(20)),
//               // Sweating
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('Sweating: '),
//                   Text(report1.sweating == null
//                       ? "nill"
//                       : report1.sweating.toString().split('.')[1]),
//                   Text(report2.sweating == null
//                       ? "nill"
//                       : report2.sweating.toString().split('.')[1]),
//                 ],
//               ),
//               SizedBox(height: getProportionateScreenHeight(20)),
//               // Nausea
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('Nausea: '),
//                   Text(report1.nausea == null
//                       ? "nill"
//                       : report1.nausea.toString().split('.')[1]),
//                   Text(report2.nausea == null
//                       ? "nill"
//                       : report2.nausea.toString().split('.')[1]),
//                 ],
//               ),
//               SizedBox(height: getProportionateScreenHeight(20)),
//               // Shortness of breath
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('Shortness of breath: '),
//                   Text(report1.shortness_of_breath == null
//                       ? "nill"
//                       : report1.shortness_of_breath.toString().split('.')[1]),
//                   Text(report2.shortness_of_breath == null
//                       ? "nill"
//                       : report2.shortness_of_breath.toString().split('.')[1]),
//                 ],
//               ),
//               SizedBox(height: getProportionateScreenHeight(20)),
//               // Loss of conciousness
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('Loss of Conciousness: '),
//                   Text(report1.loss_of_consciousness == null
//                       ? "nill"
//                       : report1.loss_of_consciousness.toString().split('.')[1]),
//                   Text(report2.loss_of_consciousness == null
//                       ? "nill"
//                       : report2.loss_of_consciousness.toString().split('.')[1]),
//                 ],
//               ),
//               SizedBox(height: getProportionateScreenHeight(20)),
//               // Palpitations
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('Palpitations: '),
//                   Text(report1.palpitations == null
//                       ? "nill"
//                       : report1.palpitations.toString().split('.')[1]),
//                   Text(report2.palpitations == null
//                       ? "nill"
//                       : report2.palpitations.toString().split('.')[1]),
//                 ],
//               ),
//               SizedBox(height: getProportionateScreenHeight(20)),
//               // Concious
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('Concious: '),
//                   Text(report1.conscious == null
//                       ? "nill"
//                       : report1.conscious.toString().split('.')[1]),
//                   Text(report2.conscious == null
//                       ? "nill"
//                       : report2.conscious.toString().split('.')[1]),
//                 ],
//               ),
//               SizedBox(height: getProportionateScreenHeight(20)),
//               // Chest crepts
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('Chest Crepts: '),
//                   Text(report1.chest_crepts == null
//                       ? "nill"
//                       : report1.chest_crepts.toString().split('.')[1]),
//                   Text(report2.chest_crepts == null
//                       ? "nill"
//                       : report2.chest_crepts.toString().split('.')[1]),
//                 ],
//               ),
//               SizedBox(height: getProportionateScreenHeight(20)),
//               // Pulse Rate
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('Pulse Rate: '),
//                   Text(report1.pulse_rate == null
//                       ? "nill"
//                       : report1.pulse_rate.toString()),
//                   Text(report2.pulse_rate == null
//                       ? "nill"
//                       : report2.pulse_rate.toString()),
//                 ],
//               ),
//               const SizedBox(height: 30),
//               SizedBox(height: SizeConfig.bottomInsets),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
