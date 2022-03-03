import 'package:ccarev2_frontend/main/domain/edetails.dart';
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/user/domain/hub_doc_info.dart';
import 'package:ccarev2_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RequestPatientList extends StatelessWidget {
  final List<PatientDetails> patients;
  final MainCubit mainCubit;

  const RequestPatientList({required this.patients, required this.mainCubit});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.red[100], borderRadius: BorderRadius.circular(20)),
      width: SizeConfig.screenWidth,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: patients.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: ListTile(
                  leading: Icon(Icons.person),
                  subtitle: Text(
                    patients[index].name,
                    style: TextStyle(color: Colors.green, fontSize: 12.sp),
                  ),
                  title: Text(patients[index].name),
                  trailing: TextButton(
                      onPressed: () {
                        mainCubit.acceptPatientByHub(patients[index].id);
                      },
                      child: Text('Accept'))),
            );
          }),
    );
  }
}
