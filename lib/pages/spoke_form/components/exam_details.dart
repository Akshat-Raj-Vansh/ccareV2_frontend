// import 'package:flutter/material.dart';
// import '../../../main/domain/examination.dart';
// import '../../../utils/size_config.dart';

// class ExaminationDetails extends StatelessWidget {
//   final Examination report;
//   const ExaminationDetails(this.report);

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig().init(context);
//     return SizedBox(
//       height: SizeConfig.screenHeight * 0.70,
//       width: SizeConfig.screenWidth * 0.85,
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(height : 2.h),
//             // Aspirin Loading
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Aspirin Loading: '),
//                 Text(report.aspirin_loading == null
//                     ? "nill"
//                     : report.aspirin_loading.toString().split('.')[1]),
//               ],
//             ),
//             SizedBox(height : 2.h),
//             // CPT Loading
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('CPT Loading: '),
//                 Text(report.c_p_t_loading == null
//                     ? "nill"
//                     : report.c_p_t_loading.toString().split('.')[1]),
//               ],
//             ),
//             SizedBox(height : 2.h),
//             // LMWH
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('LMWH: '),
//                 Text(report.lmwh == null ? "nill" : report.lmwh),
//               ],
//             ),
//             SizedBox(height : 2.h),
//             // Statins
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Statins: '),
//                 Text(report.statins == null ? "nill" : report.statins),
//               ],
//             ),
//             SizedBox(height : 2.h),
//             // Beta-Blockers
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Beta-Blockers: '),
//                 Text(report.beta_blockers == null
//                     ? "nill"
//                     : report.beta_blockers),
//               ],
//             ),
//             SizedBox(height : 2.h),
//             // Nitrates
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Nitrates: '),
//                 Text(report.nitrates == null ? "nill" : report.nitrates),
//               ],
//             ),
//             SizedBox(height : 2.h),
//             // Diuretics
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Diuretics: '),
//                 Text(report.diuretics == null ? "nill" : report.diuretics),
//               ],
//             ),
//             SizedBox(height : 2.h),
//             // ACEI ARB
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('ACEI ARB: '),
//                 Text(report.acei_arb == null ? "nill" : report.acei_arb),
//               ],
//             ),
//             SizedBox(height : 2.h),
//             // TNK ALU STK
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('TNK ALU STK Successfull: '),
//                 Text(report.tnk_alu_stk_successfull == null
//                     ? "nill"
//                     : report.tnk_alu_stk_successfull.toString().split('.')[1]),
//               ],
//             ),
//             SizedBox(height : 2.h),
//             // Death
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Death: '),
//                 Text(report.death == null
//                     ? "nill"
//                     : report.death.toString().split('.')[1]),
//               ],
//             ),
//             SizedBox(height : 2.h),
//             // Referral
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Referral: '),
//                 Text(report.referral == null
//                     ? "nill"
//                     : report.referral.toString().split('.')[1]),
//               ],
//             ),
//             SizedBox(height : 2.h),
//             // Reason for Referral
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Reason for referral: '),
//                 Text(report.reason_for_referral == null
//                     ? "nill"
//                     : report.reason_for_referral),
//               ],
//             ),

//             SizedBox(height : 5.h),
//             SizedBox(height: SizeConfig.bottomInsets),
//           ],
//         ),
//       ),
//     );
//   }
// }
