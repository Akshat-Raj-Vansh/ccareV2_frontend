import 'package:flutter/material.dart';
import '../../../main/domain/examination.dart';
import '../../../utils/size_config.dart';

class ExaminationDetails extends StatelessWidget {
  final Examination report;
  const ExaminationDetails(this.report);

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
            // Aspirin Loading
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Aspirin Loading: '),
                Text(report.aspirin_loading == null
                    ? "nill"
                    : report.aspirin_loading.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            // CPT Loading
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('CPT Loading: '),
                Text(report.c_p_t_loading == null
                    ? "nill"
                    : report.c_p_t_loading.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            // LMWH
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('LMWH: '),
                Text(report.lmwh == null ? "nill" : report.lmwh),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            // Statins
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Statins: '),
                Text(report.statins == null ? "nill" : report.statins),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            // Beta-Blockers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Beta-Blockers: '),
                Text(report.beta_blockers == null
                    ? "nill"
                    : report.beta_blockers),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            // Nitrates
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Nitrates: '),
                Text(report.nitrates == null ? "nill" : report.nitrates),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            // Diuretics
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Diuretics: '),
                Text(report.diuretics == null ? "nill" : report.diuretics),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            // ACEI ARB
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ACEI ARB: '),
                Text(report.acei_arb == null ? "nill" : report.acei_arb),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            // TNK ALU STK
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('TNK ALU STK Successfull: '),
                Text(report.tnk_alu_stk_successfull == null
                    ? "nill"
                    : report.tnk_alu_stk_successfull.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            // Death
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Death: '),
                Text(report.death == null
                    ? "nill"
                    : report.death.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            // Referral
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Referral: '),
                Text(report.referral == null
                    ? "nill"
                    : report.referral.toString().split('.')[1]),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            // Reason for Referral
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Reason for referral: '),
                Text(report.reason_for_referral == null
                    ? "nill"
                    : report.reason_for_referral),
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
