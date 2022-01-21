//@dart=2.9
import 'package:ccarev2_frontend/main/domain/edetails.dart';
import 'package:ccarev2_frontend/pages/home/components/hub/hub_patient_info.dart';
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/user/domain/hub_doc_info.dart';
import 'package:ccarev2_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_cubit/flutter_cubit.dart';

class AcceptedPatientList extends StatelessWidget {
  final List<EDetails> details;
  final MainCubit cubit;
  const AcceptedPatientList(this.details, this.cubit);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.green[100], borderRadius: BorderRadius.circular(20)),
      width: SizeConfig.screenWidth,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: details.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CubitProvider(
                            create: (_) => cubit,
                            child: HubPatientInfo(details: details[index]),
                          )),
                ),
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                child: ListTile(
                    leading: Icon(Icons.person),
                    trailing: Text(
                      details[index].patientDetails.age.toString(),
                      style: TextStyle(color: Colors.green, fontSize: 12.sp),
                    ),
                    title: Text(details[index].patientDetails.name)),
              ),
            );
          }),
    );
  }
}
