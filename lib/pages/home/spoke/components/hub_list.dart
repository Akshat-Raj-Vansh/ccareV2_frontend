import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/user/domain/hub_doc_info.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';

class HubDoctorsList extends StatelessWidget {
  final List<String> hubDocs;
  final MainCubit cubit;
  final String patientID;
  const HubDoctorsList(this.hubDocs, this.cubit, this.patientID);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: hubDocs.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              cubit.consultHub(
                hubDocs[index],
                patientID,
              );
              Navigator.pop(context);
            },
            child: ListTile(
              leading: Icon(Icons.local_hospital),
              title: Text(
                hubDocs[index],
                style: TextStyle(color: Colors.green, fontSize: 12.sp),
              ),
              // title: Text(hubDocs[index].name)
            ),
          );
        });
  }
}
